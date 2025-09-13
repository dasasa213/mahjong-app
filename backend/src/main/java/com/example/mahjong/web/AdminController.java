package com.example.mahjong.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    /** ホーム画面 */
    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("active", "admin-home");
        return "admin/home"; // /WEB-INF/views/admin/home.jsp
    }

    /** アカウント管理 */
    @GetMapping("/accounts")
    public String accounts(Model model) {
        model.addAttribute("active", "accounts");
        return "admin/accounts";
    }

    /** グループ管理 */
    @GetMapping("/groups")
    public String groups(Model model) {
        model.addAttribute("active", "groups");
        return "admin/groups";
    }
}
