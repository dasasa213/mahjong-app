package com.example.mahjong.web;

import com.example.mahjong.web.repository.UserHomeRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
public class UserNavController {

    private final UserHomeRepository repo;
    public UserNavController(UserHomeRepository repo) { this.repo = repo; }

    /** /user または /user/ に来たらホームへ */
    @GetMapping({"", "/"})
    public String root() {
        return "redirect:/user/home";
    }

    /** 利用者ホーム：4指標カード表示 */
    @GetMapping("/home")
    public String home(Model model, HttpSession session){
        String groupId = (String) session.getAttribute("groupId");
        String userName = (String)  session.getAttribute("userName");

        if (groupId == null || userName == null || userName.isBlank()) {
            return "redirect:/main/login-in";
        }

        var  stats   = repo.findStats(groupId, userName.trim());

        model.addAttribute("s", stats);
        model.addAttribute("active", "home");
        return "user/home";
    }

    /** 新規対局（既存フローへ委譲） */
    @GetMapping("/matches/new")
    public String newMatch(Model model){
        model.addAttribute("active", "new");
        return "redirect:/user/newgame/date";
    }

    /** 成績（グラフや集計ページ想定） */
    @GetMapping("/stats")
    public String stats(Model model){
        model.addAttribute("active", "stats");
        return "user/stats";
    }
}
