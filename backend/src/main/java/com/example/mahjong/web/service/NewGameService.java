// src/main/java/com/example/mahjong/web/service/NewGameService.java
package com.example.mahjong.web.service;

import com.example.mahjong.web.repository.DaaGameRecordRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class NewGameService {
    private final DaaGameRecordRepository repo;
    public NewGameService(DaaGameRecordRepository repo){ this.repo = repo; }

    /** 指定日の次の対局番号を返す（存在しなければ 1） */
    public int nextGameno(LocalDate date, String groupId){
        return repo.nextGameno(date, groupId);
    }

    /** デフォルト値＋編集中でヘッダ1行を作成し、生成された id を返す（String） */
    public String createDraft(LocalDate date, int gameno, String groupId){
        return repo.insertDraftReturningId(date, gameno, groupId);
    }

    /** 編集中フラグの解除（確定） */
    public void complete(String id){
        repo.markCompleted(id);
    }
}
