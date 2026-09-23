package com.example.mahjong.web.user;

import com.example.mahjong.web.model.PairwiseRankDiffCell;
import com.example.mahjong.web.service.PairwiseRankStatsService;
import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

class PairwiseRankStatsControllerTest {
    private static class StatsService extends PairwiseRankStatsService {
        Integer selected;
        StatsService() { super(null); }
        @Override public List<Integer> years(long group) { return List.of(2026, 2025); }
        @Override public List<String> userNames(long group) { return List.of("Alice", "Bob"); }
        @Override public Map<String, Map<String, PairwiseRankDiffCell>> matrix(long group, List<String> names, Integer year) {
            assertEquals(7L, group);
            selected = year;
            return Map.of();
        }
    }

    @Test void historicalYearAndAllTimeArePassedToService() throws Exception {
        StatsService service = new StatsService();
        var mvc = standaloneSetup(new PairwiseRankStatsController(service)).build();
        mvc.perform(get("/user/pairwise-rank").param("year", "2025").sessionAttr("groupId", 7L))
                .andExpect(status().isOk()).andExpect(model().attribute("selectedYear", 2025));
        assertEquals(2025, service.selected);
        mvc.perform(get("/user/pairwise-rank").sessionAttr("groupId", 7L)).andExpect(status().isOk());
        assertNull(service.selected);
        mvc.perform(get("/user/pairwise-rank").param("year", "1900").sessionAttr("groupId", 7L))
                .andExpect(status().isOk());
        assertNull(service.selected);
    }

    @Test void noSessionRedirectsToLogin() throws Exception {
        standaloneSetup(new PairwiseRankStatsController(new StatsService())).build()
                .perform(get("/user/pairwise-rank"))
                .andExpect(redirectedUrl("/main/login-in"));
    }
}
