package com.example.mahjong.web;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
public class UserController {

    @GetMapping("/home")
    public String home(Model model, HttpSession session){
        // ログイン済みチェック（任意）
        if (session.getAttribute("userId") == null) {
            return "redirect:/main/login-in";
        }
        model.addAttribute("active", "user-home");
        return "user/home"; // /WEB-INF/jsp/user/home.jsp を返す
    }
}
