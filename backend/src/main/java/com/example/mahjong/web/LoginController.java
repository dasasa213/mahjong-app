package com.example.mahjong.web;

import com.example.mahjong.web.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LoginController {
    private final AuthService auth;
    public LoginController(AuthService auth){ this.auth = auth; }

    @GetMapping("/main/login-in")
    public String showLogin(@RequestParam(value="error", required=false) String error, Model model){
        if (error != null) model.addAttribute("error", "ユーザIDまたはパスワードが正しくありません。");
        return "login-in";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam("loginId") String loginId,
                          @RequestParam("password") String password,
                          HttpSession session, RedirectAttributes ra){
        var r = auth.login(loginId, password);
        if (r.ok()){
            session.setAttribute("userId", r.userId());
            session.setAttribute("userName", r.userName());
            session.setAttribute("type", r.type());
            return "redirect:" + ("1".equals(r.type()) ? "/admin/home" : "/user/home");
        }
        ra.addAttribute("error","1");
        return "redirect:/main/login-in";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "redirect:/main/login-in";
    }

    @GetMapping("/admin/home") public String adminHome(){ return "admin-home"; }
    @GetMapping("/user/home")  public String userHome(){  return "user-home"; }
}