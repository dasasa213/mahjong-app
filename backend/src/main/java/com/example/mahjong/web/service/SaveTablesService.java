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
}
