package com.example.mahjong.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
public class UserNavController {

    @GetMapping("/home")
    public String home(Model model){
        model.addAttribute("active", "home"); // ← サイドバーのactiveに合わせる
        return "user/home"; // ← 直接JSP（/WEB-INF/views/user/home.jsp）
    }

    @GetMapping("/matches/new")
    public String newMatch(Model model){
        model.addAttribute("active", "new");
        return "redirect:/user/newgame/date";
    }

    @GetMapping("/stats")
    public String stats(Model model){
        model.addAttribute("active", "stats");
        return "user/stats";
    }
}
