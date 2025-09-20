// src/main/java/com/example/mahjong/web/service/GameRecordService.java
package com.example.mahjong.web.service;

import com.example.mahjong.web.model.GameRecord;
import com.example.mahjong.web.model.SaveTablesRequest;
import com.example.mahjong.web.repository.GamePlayersRepository;
import com.example.mahjong.web.repository.GameRecordRepository;
import com.example.mahjong.web.repository.SaveTablesRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class GameRecordService {

    private final GameRecordRepository recordRepo;
    private final GamePlayersRepository playersRepo;
    private final SaveTablesRepository saveRepo;

    public GameRecordService(GameRecordRepository recordRepo, GamePlayersRepository playersRepo, SaveTablesRepository saveRepo) {
        this.recordRepo = recordRepo;
        this.playersRepo = playersRepo;
        this.saveRepo = saveRepo;
    }

    public GameRecord findById(String id, String groupId) {
        return recordRepo.findById(id, groupId);
    }
    public List<GameRecord> searchByDateRange(LocalDate from, LocalDate to, String groupId, String order) {
        return recordRepo.findByDateRange(from, to, groupId, order);
    }

    @Transactional
    public int deleteById(String game_id, String groupId) {
        // 子を先に消す
        playersRepo.deleteByGameId(game_id);
        saveRepo.deleteALL(game_id);

        // 親を削除
        return recordRepo.deleteById(game_id, groupId);
    }

    @Transactional
    public void updateById(SaveTablesRequest saveTablesRequest, String gameId, String groupId) {
        recordRepo.updateById(saveTablesRequest, gameId, groupId);
    }
}
