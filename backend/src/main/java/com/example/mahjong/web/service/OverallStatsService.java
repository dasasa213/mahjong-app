package com.example.mahjong.web.service;

import com.example.mahjong.web.model.OverallStats;
import com.example.mahjong.web.repository.OverallStatsRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OverallStatsService {
    private final OverallStatsRepository repo;

    public OverallStatsService(OverallStatsRepository repo) {
        this.repo = repo;
    }

    public List<OverallStats> list(long groupId) {
        return repo.findByGroupId(groupId);
    }
}
