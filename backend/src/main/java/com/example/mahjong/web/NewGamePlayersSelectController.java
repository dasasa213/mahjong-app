// src/main/java/com/example/mahjong/web/game/NewGamePlayersSelectController.java
package com.example.mahjong.web;

import com.example.mahjong.web.service.NewGameOrchestratorService;
import com.example.mahjong.web.repository.GamePlayersRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/user/newgame/players")
public class NewGamePlayersSelectController {
    private final GamePlayersRepository repo;
    private final NewGameOrchestratorService orchestrator;

    public NewGamePlayersSelectController(GamePlayersRepository repo,
                                          NewGameOrchestratorService orchestrator){
        this.repo = repo; this.orchestrator = orchestrator;
    }

    @GetMapping
    public String page(@RequestParam(value="q", required=false) String q,
                       HttpSession session, Model model){
        LocalDate date = getDateAttr(session, "newGameDate");
        if (date == null) return "redirect:/user/newgame/date";

        // ★ ログイン時に入れている groupid を使う（キー名は運用に合わせて両対応）
        String groupId = getStrAttr(session, "groupid", "groupId");

        model.addAttribute("gamedate", date);
        model.addAttribute("users", repo.listUserNames(q, groupId)); // ★ type='2' & （同グループのみ）
        model.addAttribute("query", q);
        model.addAttribute("active","newgame");
        return "user/newgame-players-select";
    }

    /* ヘルパー */
    private String getStrAttr(HttpSession session, String... keys){
        for (String k : keys){
            Object v = session.getAttribute(k);
            if (v instanceof String s && !s.isBlank()) return s;
            if (v != null) return String.valueOf(v);
        }
        return null;
    }
    private LocalDate getDateAttr(HttpSession session, String key){
        Object v = session.getAttribute(key);
        if (v instanceof LocalDate d) return d;
        if (v instanceof String s && !s.isBlank()){
            try { return LocalDate.parse(s.trim()); } catch(Exception ignore){}
        }
        return null;
    }

    @PostMapping("/save")
    public String save(@RequestParam(value="userNames", required=false) List<String> names,
                       HttpSession session, RedirectAttributes ra){
        LocalDate date = getDateAttr(session, "newGameDate");
        if (date == null) return "redirect:/user/newgame/date";

        String groupId = (String) session.getAttribute("groupId");
        var created = orchestrator.create(date, names, groupId);
        session.setAttribute("newGameHeaderId", created.gameId());
        session.setAttribute("newGameNo", created.gameno());

        ra.addFlashAttribute("gameId", created.gameId());
        ra.addFlashAttribute("gameno", created.gameno());
        ra.addFlashAttribute("players", names);
        return "redirect:/user/newgame/players/confirm";
    }

    @GetMapping("/confirm")
    public String confirm(@ModelAttribute("gameId") String gameId,
                          @ModelAttribute("gameno") Integer gameno,
                          @ModelAttribute("players") List<String> players,
                          HttpSession session, Model model) {

        // gameId / gameno をセッションから補完
        if (gameId == null || gameId.isBlank()) {
            Object v = session.getAttribute("newGameHeaderId");
            if (v != null) gameId = String.valueOf(v);
        }
        if (gameno == null) {
            Object v = session.getAttribute("newGameNo");
            if (v instanceof Number n) gameno = n.intValue();
            else if (v instanceof String s && !s.isBlank()) {
                try { gameno = Integer.valueOf(s); } catch (Exception ignored) {}
            }
        }

        // players は無ければ DB から再読込
        if ((players == null || players.isEmpty()) && gameId != null) {
            players = repo.listPlayerNames(gameId);
        }

        // 対局日（表示用）
        Object d = session.getAttribute("newGameDate");

        model.addAttribute("gamedate", d);
        model.addAttribute("gameId", gameId);
        model.addAttribute("gameno", gameno);
        model.addAttribute("players", players);
        model.addAttribute("active", "newgame");
        return "user/newgame-players-confirm";
    }
}
