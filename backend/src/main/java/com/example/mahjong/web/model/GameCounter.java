package com.example.mahjong.web.model;

import java.time.LocalDate;

public class GameCounter {

    private long id;
    private LocalDate gameDate;
    private long userId;

    private int handCount;
    private int winCount;
    private int callCount;
    private int riichiCount;
    private int dealInCount;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public LocalDate getGameDate() {
        return gameDate;
    }

    public void setGameDate(LocalDate gameDate) {
        this.gameDate = gameDate;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getHandCount() {
        return handCount;
    }

    public void setHandCount(int handCount) {
        this.handCount = handCount;
    }

    public int getWinCount() {
        return winCount;
    }

    public void setWinCount(int winCount) {
        this.winCount = winCount;
    }

    public int getCallCount() {
        return callCount;
    }

    public void setCallCount(int callCount) {
        this.callCount = callCount;
    }

    public int getRiichiCount() {
        return riichiCount;
    }

    public void setRiichiCount(int riichiCount) {
        this.riichiCount = riichiCount;
    }

    public int getDealInCount() {
        return dealInCount;
    }

    public void setDealInCount(int dealInCount) {
        this.dealInCount = dealInCount;
    }
}