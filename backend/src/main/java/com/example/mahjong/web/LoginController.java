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
    public String loginPage() {
        return "login-in";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam("loginName") String loginName,
                          @RequestParam("password") String password,
                          HttpSession session, RedirectAttributes ra){
        var r = auth.login(loginName, password);
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