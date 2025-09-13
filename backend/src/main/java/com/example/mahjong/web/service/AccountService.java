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
        int next = repo.nextNumericIdForUpdate();       // MAX(id)+1（悲観ロック）
        String newId = String.format("%05d", next);     // 5桁0埋め
        repo.insertUser(newId, name, plainPassword, groupId, "2"); // type=2固定
        return newId;
    }
}