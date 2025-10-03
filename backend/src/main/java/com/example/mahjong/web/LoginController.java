package com.example.mahjong.web;

import com.example.mahjong.web.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/main")
public class LoginController {

    private final UserRepository userRepository;

    public LoginController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/login-in")
    public String loginForm() {
        return "main/login-in";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam("loginName") String loginName,
                          @RequestParam("password")  String password,
                          HttpSession session, Model model){
        var userOpt = userRepository.findByNameAndPassword(loginName, password);
        if (userOpt.isEmpty()){
            model.addAttribute("error","ユーザー名またはパスワードが違います。");
            return "main/login-in";
        }
        var u = userOpt.get();
        session.setAttribute("userId", u.id());
        session.setAttribute("userName", u.name());
        session.setAttribute("groupId", u.groupId());
        session.setAttribute("groupName", u.groupName());
        session.setAttribute("type", String.valueOf(u.type()).trim());
        return "redirect:/admin/home";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/main/login-in";
    }

}