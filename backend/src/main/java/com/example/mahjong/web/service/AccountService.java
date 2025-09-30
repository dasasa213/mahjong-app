package com.example.mahjong.web.service;

import com.example.mahjong.web.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AccountService {
    private final UserRepository repo;
    public AccountService(UserRepository repo){ this.repo = repo; }

    @Transactional
    public String register(String name, String plainPassword, String groupId) {
        // --- サーバ側バリデーション ---
        if (groupId == null || groupId.isBlank()) {
            throw new IllegalArgumentException("グループIDが取得できません。ログインし直してください。");
        }
        if (name == null || name.isBlank() || name.length() > 10) {
            throw new IllegalArgumentException("名前は1〜10文字で入力してください。");
        }
        if (plainPassword == null || plainPassword.isBlank() || plainPassword.length() > 10) {
            throw new IllegalArgumentException("パスワードは1〜10文字で入力してください。");
        }

        int next = repo.nextNumericIdForUpdate();   // 同一Tx内
        String newId = String.format("%05d", next); // 5桁0埋め
        repo.insertUser(newId, name, plainPassword, groupId, "2"); // type=2固定
        return newId;
    }
}