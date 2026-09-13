package com.example.mahjong.web.service;

import com.example.mahjong.web.model.GameCounter;
import com.example.mahjong.web.repository.GameCounterRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class GameCounterService {

    private final GameCounterRepository repository;

    public GameCounterService(GameCounterRepository repository) {
        this.repository = repository;
    }

    public GameCounter findToday(long userId) {
        return repository.findByUserIdAndDate(userId, LocalDate.now());
    }

    public void save(GameCounter counter) {
        repository.saveOrUpdate(counter);
    }

    public List<GameCounter> findHistory(long userId) {
        return repository.findByUserId(userId);
    }

    public GameCounter findById(long id, long userId) {
        return repository.findByIdAndUserId(id, userId);
    }

    public void update(GameCounter counter) {
        repository.update(counter);
    }

    public void delete(long id, long userId) {
        repository.delete(id, userId);
    }
}