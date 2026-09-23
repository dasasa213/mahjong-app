package com.example.mahjong.web.user;

import com.example.mahjong.web.model.OverallPeriod;
import com.example.mahjong.web.model.OverallStats;
import com.example.mahjong.web.service.OverallStatsService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.MockMvc;

import java.time.Year;
import java.time.ZoneId;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

class OverallStatsControllerTest {
    private StubStatsService service;
    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        service = new StubStatsService();
        mvc = standaloneSetup(new OverallStatsController(service)).build();
    }

    @Test
    void defaultsToAllTimeAndKeepsPlayersWithoutGames() throws Exception {
        OverallStats emptyPlayer = new OverallStats();
        emptyPlayer.setUserName("対局なし");
        service.rows = List.of(emptyPlayer);

        mvc.perform(get("/user/overall").sessionAttr("groupId", 1L))
                .andExpect(status().isOk())
                .andExpect(view().name("user/overall"))
                .andExpect(model().attribute("period", "all"))
                .andExpect(model().attribute("counterStatsAvailable", true))
                .andExpect(model().attributeExists("userNames", "byUser"));
        // This screen must not calculate unused daily deviation (division by zero for new players).
        assertFalse(service.hensaCalled);
        assertEquals(OverallPeriod.ALL, service.period);
    }

    @Test
    void recent100UsesPersonalPeriodAndMarksDailyCountersUnavailable() throws Exception {
        mvc.perform(get("/user/overall").param("period", "recent100").sessionAttr("groupId", "7"))
                .andExpect(status().isOk())
                .andExpect(model().attribute("period", "recent100"))
                .andExpect(model().attribute("counterStatsAvailable", false));
        assertEquals(7L, service.groupId);
        assertEquals(OverallPeriod.RECENT100, service.period);
    }

    @Test
    void yearUsesJapaneseCalendarYear() throws Exception {
        int year = Year.now(ZoneId.of("Asia/Tokyo")).getValue();
        mvc.perform(get("/user/overall").param("period", "year").sessionAttr("groupId", 1L))
                .andExpect(status().isOk())
                .andExpect(model().attribute("period", "year"))
                .andExpect(model().attribute("currentYear", year))
                .andExpect(model().attribute("counterStatsAvailable", true));
        assertEquals(1L, service.groupId);
        assertEquals(OverallPeriod.YEAR, service.period);
        assertEquals(year, service.year);
    }

    @Test
    void unsupportedPeriodFallsBackToAllTime() throws Exception {
        mvc.perform(get("/user/overall").param("period", "unexpected").sessionAttr("groupId", 1L))
                .andExpect(status().isOk())
                .andExpect(model().attribute("period", "all"));
        assertEquals(OverallPeriod.ALL, service.period);
    }

    @Test
    void selectsHistoricalYear() throws Exception {
        mvc.perform(get("/user/overall").param("period", "year").param("year", "2025").sessionAttr("groupId", 1L))
                .andExpect(status().isOk())
                .andExpect(model().attribute("period", "year"))
                .andExpect(model().attribute("selectedYear", 2025));
        assertEquals(2025, service.year);
    }

    @Test
    void missingYearFallsBackToAllTime() throws Exception {
        mvc.perform(get("/user/overall").param("period", "year").param("year", "1900").sessionAttr("groupId", 1L))
                .andExpect(status().isOk())
                .andExpect(model().attribute("period", "all"));
        assertEquals(OverallPeriod.ALL, service.period);
    }

    private static class StubStatsService extends OverallStatsService {
        private List<OverallStats> rows = List.of();
        private long groupId;
        private OverallPeriod period;
        private int year;
        private boolean hensaCalled;

        StubStatsService() {
            super(null);
        }

        @Override
        public List<Integer> years(long groupId) {
            return List.of(Year.now(ZoneId.of("Asia/Tokyo")).getValue(), 2025);
        }

        @Override
        public List<OverallStats> list(long groupId, OverallPeriod period, int year) {
            this.groupId = groupId;
            this.period = period;
            this.year = year;
            return rows;
        }

        @Override
        public void hensa(OverallStats stats) {
            hensaCalled = true;
        }
    }
}
