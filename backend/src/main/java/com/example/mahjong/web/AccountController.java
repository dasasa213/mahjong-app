package com.example.mahjong.web;

import com.example.mahjong.web.service.AccountService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/account")
public class AccountController {

    private final AccountService service;
    public AccountController(AccountService service){ this.service = service; }

    @GetMapping("/register")
    public String page(@ModelAttribute("success") String success,
                       @ModelAttribute("error") String error,
                       Model model) {
        model.addAttribute("active", "account");
        if (success != null && !success.isBlank()) model.addAttribute("success", success);
        if (error != null && !error.isBlank()) model.addAttribute("error", error);
        return "admin/accounts";
    }

    @PostMapping("/register")
    public String register(@RequestParam("name") String name,
                           @RequestParam("password") String password,
                           @RequestParam("passwordConfirm") String confirm,
                           HttpSession session,
                           RedirectAttributes ra) {

        // 必須 & 文字数チェック（テーブル幅に合わせる）
        if (name == null || name.isBlank()) {
            ra.addFlashAttribute("error", "名前を入力してください。");
            return "redirect:/account/register";
        }
        if (name.length() > 10) {
            ra.addFlashAttribute("error", "名前は10文字以内で入力してください。");
            return "redirect:/account/register";
        }
        if (password == null || password.isBlank()) {
            ra.addFlashAttribute("error", "パスワードを入力してください。");
            return "redirect:/account/register";
        }
        if (password.length() > 10) {
            ra.addFlashAttribute("error", "パスワードは10文字以内で入力してください。");
            return "redirect:/account/register";
        }
        if (!password.equals(confirm)) {
            ra.addFlashAttribute("error", "パスワードと確認用が一致しません。");
            return "redirect:/account/register";
        }

        // ログイン中のグループID必須
        String groupId = (String) session.getAttribute("groupId");
        if (groupId == null || groupId.isBlank()) {
            ra.addFlashAttribute("error", "グループ情報が取得できません。再度ログインしてください。");
            return "redirect:/account/register";
        }

        try {
            String newId = service.register(name.trim(), password, groupId);
            ra.addFlashAttribute("success", "登録しました。ユーザーID: " + newId);
        } catch (org.springframework.dao.DuplicateKeyException dup) {
            ra.addFlashAttribute("error", "同じ名前のユーザーが既に存在します。別の名前を指定してください。");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "登録に失敗しました。");
        }
        return "redirect:/account/register"; // 成功時も入力クリア
    }
}