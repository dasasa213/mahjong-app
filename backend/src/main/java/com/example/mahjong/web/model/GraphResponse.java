package com.example.mahjong.web.model;

import java.util.ArrayList;
import java.util.List;

public class GraphResponse {
    private final List<String> labels = new ArrayList<>();
    private final List<Double> series = new ArrayList<>();
    private String metric;

    public List<String> getLabels() { return labels; }
    public List<Double> getSeries() { return series; }
    public String getMetric() { return metric; }
    public void setMetric(String metric) { this.metric = metric; }
}
