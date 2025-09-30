package com.example.mahjong.web.service;

import com.example.mahjong.web.repository.GamePlayersRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GamePlayerService {
    private final GamePlayersRepository repo;
    public GamePlayerService(GamePlayersRepository repo){ this.repo = repo; }

    /** 利用者一覧（groupId で絞り込み） */
    public List<String> listUserNames(String q, String groupId){
        return repo.listUserNames(q, groupId);
    }
    /** 互換：groupId なし */
    public List<String> listUserNames(String q){
        return repo.listUserNames(q);
    }

    /** 登録済み参加者 */
    public List<String> listPlayerNames(String gameId){
        return repo.listPlayerNames(gameId);
    }

    /** 置き換え保存 */
    @Transactional
    public void replace(String gameId, List<String> names){
        repo.deleteAll(gameId);
        repo.bulkInsert(gameId, names); // ← bukInsert → bulkInsert
    }
}
