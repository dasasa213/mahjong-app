package com.example.mahjong.web;

import com.example.mahjong.web.model.GraphResponse;
import com.example.mahjong.web.service.OverallChartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/user/overall")
public class OverallChartController {

    private final OverallChartService service;

    public OverallChartController(OverallChartService service) {
        this.service = service;
    }

    /** 表示ページ */
    @GetMapping("/chart")
    public String chartPage(Model model, HttpSession session) {
        // 初期値: ログインユーザの名前、point
        String loginUserName = (String) session.getAttribute("userName");
        Object gidObj = session.getAttribute("groupId");
        String groupId = gidObj == null ? null : String.valueOf(gidObj);

        // 対象者プルダウン（同一グループのユーザ名一覧）
        List<String> users = service.findUserNamesInGroup(groupId);
        model.addAttribute("users", users);

        model.addAttribute("defaultUserName", loginUserName);
        model.addAttribute("defaultMetric", "point");
        model.addAttribute("active", "overall"); // レイアウトのアクティブ表示用
        return "user/overall-chart";
    }

    /** グラフデータAPI（name基準） */
    @GetMapping("/chart/data")
    @ResponseBody
    public GraphResponse fetchData(@RequestParam("userName") String userName,
                                   @RequestParam("metric") String metric,
                                   HttpSession session) {
        Object gidObj = session.getAttribute("groupId");
        String groupId = gidObj == null ? null : String.valueOf(gidObj);
        return service.buildGraphByName(groupId, userName, metric);
    }
}
