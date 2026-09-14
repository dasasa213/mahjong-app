package com.example.mahjong.web.model;

import java.math.BigDecimal;
import java.util.Date;

public class UserHomeStats {
    private Date lastDate;
    private long totalPoint;
    private long totalAmount;
    private BigDecimal avgRank;

    public Date getLastDate() { return lastDate; }
    public void setLastDate(Date lastDate) { this.lastDate = lastDate; }

    public long getTotalPoint() { return totalPoint; }
    public void setTotalPoint(long totalPoint) { this.totalPoint = totalPoint; }

    public long getTotalAmount() { return totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }

    public BigDecimal getAvgRank() { return avgRank; }
    public void setAvgRank(BigDecimal avgRank) { this.avgRank = avgRank; }
}
