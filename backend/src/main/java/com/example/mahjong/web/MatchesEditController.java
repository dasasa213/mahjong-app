// src/main/java/com/example/mahjong/web/user/MatchesEditController.java
package com.example.mahjong.web;

import com.example.mahjong.web.model.SaveTablesRequest;
import com.example.mahjong.web.service.GamePlayerService;
import com.example.mahjong.web.service.GameRecordService;
import com.example.mahjong.web.model.GameRecord;
import com.example.mahjong.web.service.SaveTablesService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/user/matches")
public class MatchesEditController {

    private final GameRecordService recordService;
    private final GamePlayerService playerService;
    private final SaveTablesService saveService;

    public MatchesEditController(GameRecordService recordService, GamePlayerService playerService, SaveTablesService saveService) {
        this.recordService = recordService;
        this.playerService = playerService;
        this.saveService = saveService;
    }

    /** 検索画面（一覧） */
    @GetMapping("/edit")
    public String list(@RequestParam(value = "from", required = false) String fromStr,
                       @RequestParam(value = "to", required = false) String toStr,
                       @RequestParam(value = "order", required = false, defaultValue = "desc") String order, // ★追加
                       HttpSession session,
                       Model model) {
        model.addAttribute("active", "matches-edit");

        LocalDate to = (toStr == null || toStr.isBlank()) ? LocalDate.now() : LocalDate.parse(toStr);
        LocalDate from = (fromStr == null || fromStr.isBlank()) ? to.minusDays(14) : LocalDate.parse(fromStr);

        // order は "asc" / "desc" のみ許可（それ以外は desc にフォールバック）
        order = ("asc".equalsIgnoreCase(order)) ? "asc" : "desc";

        String groupId = (String) session.getAttribute("groupId");
        List<GameRecord> list = recordService.searchByDateRange(from, to, groupId, order);

        model.addAttribute("from", from);
        model.addAttribute("to", to);
        model.addAttribute("order", order);                   // ★JSPで使う
        model.addAttribute("records", list);
        return "user/matches-edit";
    }

    @GetMapping("/edit/{id}")
    public String editDetail(@PathVariable String id,
                             @SessionAttribute("groupId") String groupId,
                             Model model) {
        var game = recordService.findById(id, groupId);
        if (game == null) {
            model.addAttribute("error", "指定の対局が見つかりません。");
            return "user/matches-edit"; // 一覧に戻すなど
        }

        //詰め替え
        SaveTablesRequest saveTablesRequest = new SaveTablesRequest();
        saveTablesRequest.gameId = game.getId();
        saveTablesRequest.header.gamedate = game.getGamedate();
        saveTablesRequest.header.gameno = game.getGameno();
        saveTablesRequest.header.points = game.getPoints();
        saveTablesRequest.header.returnpoints = game.getReturnpoints();
        saveTablesRequest.header.rate = game.getRate();
        saveTablesRequest.header.uma1 = game.getUma1();
        saveTablesRequest.header.uma2 = game.getUma2();

        saveTablesRequest = saveService.findGameAll(saveTablesRequest);

        model.addAttribute("saveTablesRequest", saveTablesRequest);
        model.addAttribute("players", playerService.listPlayerNames(id));
        model.addAttribute("active", "matches");
        return "user/matches-edit-detail";
    }

    /** 削除 */
    @PostMapping("/delete")
    public String delete(@RequestParam("id") String id,
                         @RequestParam("agree") boolean agree,
                         RedirectAttributes ra,
                         @RequestParam("from") String fromStr,
                         @RequestParam("to") String toStr,
                         @RequestParam("order") String order,   // ★保持
                         HttpSession session) {
        if (!agree) {
            ra.addFlashAttribute("error", "削除には同意チェックが必要です。");
            return "redirect:/user/matches/edit?from=" + fromStr + "&to=" + toStr + "&order=" + order;
        }
        String groupId = (String) session.getAttribute("groupId");
        int rows = recordService.deleteById(id, groupId);
        if (rows > 0) ra.addFlashAttribute("success", "ID " + id + " を削除しました。");
        else ra.addFlashAttribute("error", "削除対象が見つかりませんでした。");
        return "redirect:/user/matches/edit?from=" + fromStr + "&to=" + toStr + "&order=" + order; // ★保持
    }

    @PostMapping("/save")
    public String save(@RequestParam("payload") String payloadJson,
                       @RequestParam("id") String gameId,
                       RedirectAttributes ra,
                       HttpSession session) throws Exception {
        ObjectMapper om = new ObjectMapper();
        // LocalDate を "yyyy-MM-dd" で受け取るため
        om.registerModule(new JavaTimeModule());
        om.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        SaveTablesRequest req = om.readValue(payloadJson, SaveTablesRequest.class);
        req.gameId = gameId;

        recordService.updateById(req, gameId, (String) session.getAttribute("groupId"));
        saveService.deleteAll(req.gameId);
        saveService.insertAll(req);

        ra.addFlashAttribute("success", "保存しました");
        return "redirect:/user/matches/edit/" + req.getGameId();
    }
}
