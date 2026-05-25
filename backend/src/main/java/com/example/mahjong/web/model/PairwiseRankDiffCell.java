package com.example.mahjong.web.model;

import java.math.BigDecimal;

public class PairwiseRankDiffCell {
    private BigDecimal value;
    private String displayValue;
    private String cssClass;

    public PairwiseRankDiffCell() {
    }

    public PairwiseRankDiffCell(BigDecimal value, String displayValue, String cssClass) {
        this.value = value;
        this.displayValue = displayValue;
        this.cssClass = cssClass;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }

    public String getDisplayValue() {
        return displayValue;
    }

    public void setDisplayValue(String displayValue) {
        this.displayValue = displayValue;
    }

    public String getCssClass() {
        return cssClass;
    }

    public void setCssClass(String cssClass) {
        this.cssClass = cssClass;
    }
}
