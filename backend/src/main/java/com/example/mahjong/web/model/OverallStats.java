package com.example.mahjong.web.model;

import java.math.BigDecimal;

public class OverallStats {
    private String userName;
    private BigDecimal totalPoint;        // 合計点数
    private long totalAmount;       // 合計金額
    private BigDecimal avgRank;     // 平均順位(小数)
    private BigDecimal rate1;       // 1位率(%)
    private BigDecimal rate2;       // 2位率(%)
    private BigDecimal rate3;       // 3位率(%)
    private BigDecimal rate4;       // 4位率(%)
    private long participateDays;   // 参加日数(件数)
    private long hanshanCount;      // 半荘数

    // getter / setter
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public BigDecimal getTotalPoint() { return totalPoint; }
    public void setTotalPoint(BigDecimal totalPoint) { this.totalPoint = totalPoint; }
    public long getTotalAmount() { return totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getAvgRank() { return avgRank; }
    public void setAvgRank(BigDecimal avgRank) { this.avgRank = avgRank; }
    public BigDecimal getRate1() { return rate1; }
    public void setRate1(BigDecimal rate1) { this.rate1 = rate1; }
    public BigDecimal getRate2() { return rate2; }
    public void setRate2(BigDecimal rate2) { this.rate2 = rate2; }
    public BigDecimal getRate3() { return rate3; }
    public void setRate3(BigDecimal rate3) { this.rate3 = rate3; }
    public BigDecimal getRate4() { return rate4; }
    public void setRate4(BigDecimal rate4) { this.rate4 = rate4; }
    public long getParticipateDays() { return participateDays; }
    public void setParticipateDays(long participateDays) { this.participateDays = participateDays; }
    public long getHanshanCount() { return hanshanCount; }
    public void setHanshanCount(long hanshanCount) { this.hanshanCount = hanshanCount; }
}
