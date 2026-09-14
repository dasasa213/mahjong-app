package com.example.mahjong.web.service;

import com.example.mahjong.web.model.GraphPoint;
import com.example.mahjong.web.model.GraphResponse;
import com.example.mahjong.web.repository.OverallChartRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OverallChartService {

    private final OverallChartRepository repo;

    public OverallChartService(OverallChartRepository repo) {
        this.repo = repo;
    }

    /** プルダウン候補：利用者のみ（type=2） */
    public List<String> findUserNamesInGroup(String groupId) {
        return repo.findUserNamesInGroup(groupId);
    }

    /** metric: point | amount | avgRank */
    public GraphResponse buildGraphByName(String groupId, String userName, String metric) {
        String m = switch (metric == null ? "" : metric) {
            case "amount"  -> "amount";
            case "avgRank" -> "avgRank";
            default        -> "point";
        };

        List<GraphPoint> points = repo.loadCumulativeSeriesByName(groupId, userName);

        GraphResponse res = new GraphResponse();
        for (GraphPoint p : points) {
            res.getLabels().add(p.gamedate());
            switch (m) {
                case "amount"  -> res.getSeries().add(p.cumAmount());
                case "avgRank" -> res.getSeries().add(p.cumAvgRank());
                default        -> res.getSeries().add(p.cumPoint());
            }
        }
        res.setMetric(m);
        return res;
    }
}
