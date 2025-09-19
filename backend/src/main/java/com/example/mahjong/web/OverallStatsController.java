package com.example.mahjong.web.user;

import com.example.mahjong.web.model.OverallStats;
import com.example.mahjong.web.service.OverallStatsService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user/overall")
public class OverallStatsController {

    private final OverallStatsService service;

    public OverallStatsController(OverallStatsService service) {
        this.service = service;
    }

    @GetMapping
    public String page(HttpSession session, Model model) {
        Object gid = session.getAttribute("groupId");
        long groupId = (gid instanceof Number) ? ((Number) gid).longValue() : Long.parseLong(String.valueOf(gid));

        List<OverallStats> rows = service.list(groupId);

        // JSPで「行：指標／列：ユーザー名」にしたいので、ピボット用のMapを作る
        // keys: userName（列見出し）
        // 各行の値は JSP 側で取り出す
        Map<String, OverallStats> byUser = new LinkedHashMap<>();
        for (OverallStats r : rows) {
            byUser.put(r.getUserName(), r);
        }
        model.addAttribute("byUser", byUser);
        model.addAttribute("userNames", byUser.keySet()); // 列順管理
        model.addAttribute("active", "overall");          // サイドメニュー選択用（必要なら）

        return "user/overall"; // /WEB-INF/views/user/overall.jsp
    }
}
