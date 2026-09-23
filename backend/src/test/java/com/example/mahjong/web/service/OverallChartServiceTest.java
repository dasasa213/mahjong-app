package com.example.mahjong.web.service;

import com.example.mahjong.web.model.*;
import com.example.mahjong.web.repository.OverallChartRepository;
import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class OverallChartServiceTest {
    private static class HistoryRepo extends OverallChartRepository {
        final List<RankPoint> history = new ArrayList<>();
        HistoryRepo(int count) {
            super(null);
            Random random = new Random(73);
            for (int i = 0; i < count; i++) history.add(new RankPoint("2026-01-01", 1 + random.nextInt(4)));
        }
        @Override public List<RankPoint> loadRankHistory(String group, String name) {
            assertEquals("7", group);
            return name.equals("Alice") ? history : List.of();
        }
        @Override public List<GraphPoint> loadCumulativeSeriesByName(String group, String name) {
            return List.of(new GraphPoint("2026-01-01", 35.0, 1750.0, 2.0));
        }
    }

    @Test void movingAveragesMatchIndependentWindowCalculation() {
        HistoryRepo repo = new HistoryRepo(137);
        GraphResponse graph = new OverallChartService(repo).buildGraphByName("7", "Alice", "avgRank");
        assertEquals(137, graph.getLabels().size());
        for (int window : new int[]{25, 50, 100}) {
            List<Double> values = graph.getMovingAverages().get(String.valueOf(window));
            assertEquals(137, values.size());
            for (int i = 0; i < values.size(); i++) {
                if (i + 1 < window) assertNull(values.get(i));
                else {
                    double expected = repo.history.subList(i + 1 - window, i + 1).stream()
                            .mapToInt(RankPoint::rank).average().orElseThrow();
                    assertEquals(expected, values.get(i), 1e-12);
                }
            }
        }
        assertEquals(repo.history.stream().mapToInt(RankPoint::rank).average().orElseThrow(),
                graph.getSeries().getLast(), 1e-12);
    }

    @Test void eachWindowStartsAtItsExactThreshold() {
        for (int count : new int[]{0, 24, 25, 26, 49, 50, 99, 100}) {
            GraphResponse graph = new OverallChartService(new HistoryRepo(count))
                    .buildGraphByName("7", "Alice", "avgRank");
            for (int window : new int[]{25, 50, 100}) {
                long visible = graph.getMovingAverages().get(String.valueOf(window)).stream()
                        .filter(Objects::nonNull).count();
                assertEquals(Math.max(0, count - window + 1), visible);
            }
        }
    }

    @Test void changingPlayerDoesNotReuseAnotherPlayersHistory() {
        OverallChartService service = new OverallChartService(new HistoryRepo(110));
        assertEquals(110, service.buildGraphByName("7", "Alice", "avgRank").getSeries().size());
        GraphResponse bob = service.buildGraphByName("7", "Bob", "avgRank");
        assertTrue(bob.getSeries().isEmpty());
        assertTrue(bob.getMovingAverages().values().stream().allMatch(List::isEmpty));
    }

    @Test void pointAndAmountKeepExistingDailySeries() {
        OverallChartService service = new OverallChartService(new HistoryRepo(100));
        for (String metric : List.of("point", "amount")) {
            GraphResponse result = service.buildGraphByName("7", "Alice", metric);
            assertEquals(List.of("2026-01-01"), result.getLabels());
            assertEquals(List.of(metric.equals("point") ? 35.0 : 1750.0), result.getSeries());
            assertTrue(result.getMovingAverages().isEmpty());
        }
    }
}
