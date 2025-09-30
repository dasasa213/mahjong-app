// src/main/java/com/example/mahjong/web/model/GameRecord.java
package com.example.mahjong.web.model;

import java.time.LocalDate;

public class GameRecord {
    private String id;
    private LocalDate gamedate;
    private Integer gameno;
    private Integer rate;
    private Integer points;
    private Integer returnpoints;
    private Integer uma1;
    private Integer uma2;
    private String editingFlag;

    // getter/setter 省略（必要分だけでもOK）
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public LocalDate getGamedate() { return gamedate; }
    public void setGamedate(LocalDate gamedate) { this.gamedate = gamedate; }
    public Integer getGameno() { return gameno; }
    public void setGameno(Integer gameno) { this.gameno = gameno; }
    public Integer getRate() { return rate; }
    public void setRate(Integer rate) { this.rate = rate; }
    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }
    public Integer getReturnpoints() { return returnpoints; }
    public void setReturnpoints(Integer returnpoints) { this.returnpoints = returnpoints; }
    public Integer getUma1() { return uma1; }
    public void setUma1(Integer uma1) { this.uma1 = uma1; }
    public Integer getUma2() { return uma2; }
    public void setUma2(Integer uma2) { this.uma2 = uma2; }
    public String getEditingFlag() { return editingFlag; }
    public void setEditingFlag(String editingFlag) { this.editingFlag = editingFlag; }
}
