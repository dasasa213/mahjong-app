package com.example.mahjong.web.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class SaveTablesRequest {
    public Header header = new Header();
    public List<Row> scores = new ArrayList<>();
    public List<Row> rankings = new ArrayList<>();
    public List<Row> points = new ArrayList<>();
    public String gameId;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Header {
        public LocalDate gamedate;       // "yyyy-MM-dd"
        public Integer gameno;
        public Integer rate;
        public Integer points;
        public Integer returnpoints;
        public Integer uma1;
        public Integer uma2;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Row {
        public Integer row_num;
        public String name;
        public Integer value;
    }
}
