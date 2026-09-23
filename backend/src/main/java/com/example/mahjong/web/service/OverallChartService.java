package com.example.mahjong.web.service;

import com.example.mahjong.web.model.GraphPoint;
import com.example.mahjong.web.model.RankPoint;
import com.example.mahjong.web.model.GraphResponse;
import com.example.mahjong.web.repository.OverallChartRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.ArrayList;

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

        if ("avgRank".equals(m)) {
            return buildRankGraph(repo.loadRankHistory(groupId, userName));
        }
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

    private GraphResponse buildRankGraph(List<RankPoint> history) {
        GraphResponse res = new GraphResponse();
        res.setMetric("avgRank");
        int[] windows = {25, 50, 100};
        long[] windowSums = new long[windows.length];
        for (int window : windows) {
            res.getMovingAverages().put(String.valueOf(window), new ArrayList<>());
        }
        long total = 0;
        for (int i = 0; i < history.size(); i++) {
            RankPoint point = history.get(i);
            total += point.rank();
            res.getLabels().add(point.gameDate() + "（" + (i + 1) + "半荘目）");
            res.getSeries().add((double) total / (i + 1));
            for (int w = 0; w < windows.length; w++) {
                int window = windows[w];
                windowSums[w] += point.rank();
                if (i >= window) {
                    windowSums[w] -= history.get(i - window).rank();
                }
                // null means no point/line until the full personal window is available.
                res.getMovingAverages().get(String.valueOf(window))
                        .add(i + 1 < window ? null : (double) windowSums[w] / window);
            }
        }
        return res;
    }
}
