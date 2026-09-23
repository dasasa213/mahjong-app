package com.example.mahjong.web.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class GraphResponse {
    private final List<String> labels = new ArrayList<>();
    private final List<Double> series = new ArrayList<>();
    private String metric;
    private final Map<String, List<Double>> movingAverages = new LinkedHashMap<>();

    public Map<String, List<Double>> getMovingAverages() { return movingAverages; }

    public List<String> getLabels() { return labels; }
    public List<Double> getSeries() { return series; }
    public String getMetric() { return metric; }
    public void setMetric(String metric) { this.metric = metric; }
}
