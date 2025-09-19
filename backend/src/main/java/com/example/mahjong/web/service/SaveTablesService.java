package com.example.mahjong.web.service;

import com.example.mahjong.web.model.SaveTablesRequest;
import com.example.mahjong.web.repository.GamePlayersRepository;
import com.example.mahjong.web.repository.GameRecordRepository;
import com.example.mahjong.web.repository.SaveTablesRepository;
import org.springframework.stereotype.Service;

@Service
public class SaveTablesService {
    private final SaveTablesRepository saveRepo;
    public SaveTablesService(SaveTablesRepository saveRepo) {
        this.saveRepo = saveRepo;
    }

    public SaveTablesRequest findGameAll(SaveTablesRequest saveTablesRequest){
        return saveRepo.findGame(saveTablesRequest, saveTablesRequest.gameId);
    }

    public  void deleteAll(String game_id){
        saveRepo.deleteALL(game_id);
    }

    public  void insertAll(SaveTablesRequest saveTablesRequest){
        for (SaveTablesRequest.Row r : saveTablesRequest.getScores()) {
            saveRepo.insertScore(saveTablesRequest.getGameId(), r);
        }
        // rankings
        for (SaveTablesRequest.Row r : saveTablesRequest.getRankings()) {
            saveRepo.insertRanking(saveTablesRequest.getGameId(), r);
        }
        // points
        for (SaveTablesRequest.Row r : saveTablesRequest.getPoints()) {
            saveRepo.insertPoint(saveTablesRequest.getGameId(), r);
        }
    }
}
