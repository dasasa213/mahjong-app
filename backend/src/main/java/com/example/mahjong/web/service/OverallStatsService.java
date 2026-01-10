package com.example.mahjong.web.service;

import com.example.mahjong.web.model.OverallStats;
import com.example.mahjong.web.repository.OverallStatsRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
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

    public void hensa(OverallStats overallStats) {
        long N = overallStats.getParticipateDays(); //日数
        BigDecimal hopePoint =overallStats.getTotalPoint().divide(BigDecimal.valueOf(N), 10, java.math.RoundingMode.HALF_UP); //期待値
        List<BigDecimal> pointList = repo.findByname(overallStats.getUserName()); //1日の点数リスト
        BigDecimal squaredDiffSum = BigDecimal.valueOf(0);

        //偏差の2乗の合計
        for (BigDecimal p : pointList) {
            BigDecimal squaredDiff = p.subtract(hopePoint);
            squaredDiffSum = squaredDiffSum.add(squaredDiff.multiply(squaredDiff));
        }

        //分散
        BigDecimal bunsan = squaredDiffSum.divide(BigDecimal.valueOf(N), 10, RoundingMode.HALF_UP);

        //標準偏差
        BigDecimal hensaP;
        hensaP = BigDecimal.valueOf(Math.sqrt(bunsan.doubleValue()));

        overallStats.setHensa(hensaP);
    }
}
