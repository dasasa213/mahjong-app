package com.example.mahjong.web.model;

public record GraphPoint(
        String gamedate,
        double cumPoint,
        double cumAmount,
        double cumAvgRank   // 平均順位（累積）
) {}
