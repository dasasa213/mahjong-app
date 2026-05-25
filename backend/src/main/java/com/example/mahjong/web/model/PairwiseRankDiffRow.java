package com.example.mahjong.web.model;

import java.math.BigDecimal;

public class PairwiseRankDiffRow {
    private String rowUserName;
    private String colUserName;
    private BigDecimal rankDiff;
    private long gameCount;

    public String getRowUserName() {
        return rowUserName;
    }

    public void setRowUserName(String rowUserName) {
        this.rowUserName = rowUserName;
    }

    public String getColUserName() {
        return colUserName;
    }

    public void setColUserName(String colUserName) {
        this.colUserName = colUserName;
    }

    public BigDecimal getRankDiff() {
        return rankDiff;
    }

    public void setRankDiff(BigDecimal rankDiff) {
        this.rankDiff = rankDiff;
    }

    public long getGameCount() {
        return gameCount;
    }

    public void setGameCount(long gameCount) {
        this.gameCount = gameCount;
    }
}
