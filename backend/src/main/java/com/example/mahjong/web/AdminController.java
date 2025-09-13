package com.example.mahjong.web;

import com.example.mahjong.web.admin.AdminHomeView;
import com.example.mahjong.web.service.AdminDashboardService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminDashboardService service;

    public AdminController(AdminDashboardService service) {
        this.service = service;
    }

    /** ホーム画面 */
    @GetMapping("/home")
    public String home(Model model, HttpSession session){
        Object t = session.getAttribute("type");
        if (!"1".equals(String.valueOf(t).trim())) {
            return "redirect:/user/home";
        }

        Long userId = Long.valueOf(session.getAttribute("userId").toString());
        AdminHomeView vm = service.buildViewFor(userId);

        // グループ未設定なら案内表示（またはセットアップ画面へ誘導）
        if (vm.getGroupId() == null) {
            model.addAttribute("message", "このユーザはグループ未設定です。先にグループを作成/割当してください。");
        }
        model.addAttribute("vm", vm);
        model.addAttribute("active", "admin-home");
        return "admin/home";
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
