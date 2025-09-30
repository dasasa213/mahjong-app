package com.example.mahjong.web;

import com.example.mahjong.web.model.GroupEditForm;
import com.example.mahjong.web.service.GroupService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/group")
public class AdminGroupController {
    private final GroupService groups;
    public AdminGroupController(GroupService groups){ this.groups = groups; }

    @GetMapping("/edit")
    public String editPage(HttpSession session, Model model){
        model.addAttribute("active", "group"); // サイドメニューのハイライトだけ
        return "admin/groups";             // JSPは sessionScope.groupName を参照
    }

    @PostMapping("/update")
    public String update(@RequestParam("newName") String newName,
                         HttpSession session,
                         RedirectAttributes ra){
        String groupId = (String) session.getAttribute("groupId"); // String想定
        if (newName == null || newName.isBlank()){
            ra.addFlashAttribute("error", "グループ名を入力してください。");
            return "redirect:/admin/group/edit";
        }
        if (newName.length() > 10){
            ra.addFlashAttribute("error", "グループ名は10文字以内で入力してください。");
            return "redirect:/admin/group/edit";
        }

        boolean ok = groups.changeName(groupId, newName); // DB更新
        if (ok){
            session.setAttribute("groupName", newName);   // ★ヘッダー/画面表示も即時反映
            ra.addFlashAttribute("success", "グループ名を変更しました。");
        }else{
            ra.addFlashAttribute("error", "変更に失敗しました。");
        }
        return "redirect:/admin/group/edit";
    }
}
