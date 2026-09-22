package com.example.mahjong.web.model;

/** 集計期間。URLには固定の値だけを受け付ける。 */
public enum OverallPeriod {
    ALL("all"), RECENT100("recent100"), YEAR("year");

    private final String value;

    OverallPeriod(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static OverallPeriod fromValue(String value) {
        for (OverallPeriod period : values()) {
            if (period.value.equals(value)) {
                return period;
            }
        }
        return ALL;
    }
}
