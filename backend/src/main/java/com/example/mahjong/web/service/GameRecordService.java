// src/main/java/com/example/mahjong/web/service/GameRecordService.java
package com.example.mahjong.web.service;

import com.example.mahjong.web.model.GameRecord;
import com.example.mahjong.web.repository.GamePlayersRepository;
import com.example.mahjong.web.repository.GameRecordRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class GameRecordService {

    private final GameRecordRepository recordRepo;
    private final GamePlayersRepository playersRepo;

    public GameRecordService(GameRecordRepository recordRepo,
                             GamePlayersRepository playersRepo) {
        this.recordRepo = recordRepo;
        this.playersRepo = playersRepo;
    }

    public GameRecord findById(String id, String groupId) {
        return recordRepo.findById(id, groupId);
    }
    public List<GameRecord> searchByDateRange(LocalDate from, LocalDate to, String groupId, String order) {
        return recordRepo.findByDateRange(from, to, groupId, order);
    }

    @Transactional
    public int deleteById(String id, String groupId) {
        // 子を先に消す
        playersRepo.deleteByGameId(id);
        // 親を削除
        return recordRepo.deleteById(id, groupId);
    }
}
