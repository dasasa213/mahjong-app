// src/main/java/com/example/mahjong/web/service/NewGameOrchestratorService.java
package com.example.mahjong.web.service;

import com.example.mahjong.web.repository.DaaGameRecordRepository;
import com.example.mahjong.web.repository.GamePlayersRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class NewGameOrchestratorService {
    private final DaaGameRecordRepository recordRepo;
    private final GamePlayersRepository playersRepo;

    public NewGameOrchestratorService(DaaGameRecordRepository recordRepo,
                                      GamePlayersRepository playersRepo) {
        this.recordRepo = recordRepo;
        this.playersRepo = playersRepo;
    }

    // ★ここを唯一のcreateにする
    public CreatedGame create(LocalDate date, List<String> names, String groupId) {
        int gameno = recordRepo.nextGameno(date, groupId);           // ← groupId版
        String gameId = recordRepo.insertHeader(date, gameno, groupId); // ← groupId付与
        playersRepo.bulkInsert(gameId, names);
        return new CreatedGame(gameId, gameno);
    }

    public record CreatedGame(String gameId, int gameno) {}
}
