package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.OverallStats;
import com.example.mahjong.web.model.OverallPeriod;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository
public class OverallStatsRepository {

    private final JdbcTemplate jdbc;

    public OverallStatsRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<OverallStats> findByGroupId(long groupId) {
        return findByGroupId(groupId, OverallPeriod.ALL,
                LocalDate.now(ZoneId.of("Asia/Tokyo")).getYear());
    }

    public List<OverallStats> findByGroupId(long groupId, OverallPeriod period, int year) {
        int yearOnly = period == OverallPeriod.YEAR ? 1 : 0;
        int recentOnly = period == OverallPeriod.RECENT100 ? 1 : 0;
        Date yearStart = Date.valueOf(LocalDate.of(year, 1, 1));
        Date yearEnd = Date.valueOf(LocalDate.of(year + 1, 1, 1));

        // 点数・順位・半荘数は同じ半荘集合から集計する。
        // カウンターは日単位のため、直近100半荘では集計せず画面に「—」を表示する。
        String sql = """
                WITH period_games AS (
                  SELECT id, gamedate, gameno, rate
                  FROM daa_gamerecords
                  WHERE groupid = ?
                    AND (? = 0 OR (gamedate >= ? AND gamedate < ?))
                ), ranked_hands AS (
                  SELECT p.name, p.point, g.rate, g.gamedate, r.rank_no,
                    ROW_NUMBER() OVER (
                      PARTITION BY p.name
                      ORDER BY g.gamedate DESC, g.gameno DESC, p.row_no DESC, p.point_id DESC
                    ) AS rn
                  FROM daa_point p
                  JOIN period_games g ON g.id = p.game_id
                  LEFT JOIN daa_ranking r
                    ON r.game_id = p.game_id AND r.row_no = p.row_no AND r.name = p.name
                ), selected_hands AS (
                  SELECT * FROM ranked_hands WHERE ? = 0 OR rn <= 100
                ), hand_stats AS (
                  SELECT name,
                    SUM(point) AS total_point,
                    SUM(point * rate) AS total_amount,
                    AVG(rank_no) AS avg_rank,
                    AVG(CASE WHEN rn <= 100 THEN rank_no END) AS recent100_avg_rank,
                    100.0 * SUM(CASE WHEN rank_no = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(rank_no), 0) AS rate1,
                    100.0 * SUM(CASE WHEN rank_no = 2 THEN 1 ELSE 0 END) / NULLIF(COUNT(rank_no), 0) AS rate2,
                    100.0 * SUM(CASE WHEN rank_no = 3 THEN 1 ELSE 0 END) / NULLIF(COUNT(rank_no), 0) AS rate3,
                    100.0 * SUM(CASE WHEN rank_no = 4 THEN 1 ELSE 0 END) / NULLIF(COUNT(rank_no), 0) AS rate4,
                    COUNT(DISTINCT gamedate) AS participate_days,
                    COUNT(*) AS hanshan_count
                  FROM selected_hands
                  GROUP BY name
                ), counter_stats AS (
                  SELECT gc.user_id,
                    SUM(gc.hand_count) AS hand_count,
                    100.0 * SUM(gc.win_count) / NULLIF(SUM(gc.hand_count), 0) AS win_rate,
                    100.0 * SUM(gc.call_count) / NULLIF(SUM(gc.hand_count), 0) AS call_rate,
                    100.0 * SUM(gc.riichi_count) / NULLIF(SUM(gc.hand_count), 0) AS riichi_rate,
                    100.0 * SUM(gc.deal_in_count) / NULLIF(SUM(gc.hand_count), 0) AS deal_in_rate
                  FROM daa_game_counter gc
                  JOIN daa_user_knr cu ON cu.id = gc.user_id
                  WHERE cu.groupid = ? AND cu.type = '2' AND ? = 0
                    AND (? = 0 OR (gc.game_date >= ? AND gc.game_date < ?))
                  GROUP BY gc.user_id
                )
                SELECT
                  u.name AS user_name,
                  COALESCE(h.total_point, 0) AS total_point,
                  COALESCE(h.total_amount, 0) AS total_amount,
                  COALESCE(h.avg_rank, 0) AS avg_rank,
                  COALESCE(h.recent100_avg_rank, 0) AS recent100_avg_rank,
                  COALESCE(h.rate1, 0) AS rate1,
                  COALESCE(h.rate2, 0) AS rate2,
                  COALESCE(h.rate3, 0) AS rate3,
                  COALESCE(h.rate4, 0) AS rate4,
                  COALESCE(h.participate_days, 0) AS participate_days,
                  COALESCE(h.hanshan_count, 0) AS hanshan_count,
                  COALESCE(gc.hand_count, 0) AS hand_count,
                  COALESCE(gc.win_rate, 0) AS win_rate,
                  COALESCE(gc.call_rate, 0) AS call_rate,
                  COALESCE(gc.riichi_rate, 0) AS riichi_rate,
                  COALESCE(gc.deal_in_rate, 0) AS deal_in_rate
                FROM daa_user_knr u
                LEFT JOIN hand_stats h ON h.name = u.name
                LEFT JOIN counter_stats gc ON gc.user_id = u.id
                WHERE u.groupid = ? AND u.type = '2'
                ORDER BY u.id
                """;

        return jdbc.query(sql, (rs, rowNum) -> map(rs),
                groupId, yearOnly, yearStart, yearEnd, recentOnly,
                groupId, recentOnly, yearOnly, yearStart, yearEnd, groupId);
    }

    private OverallStats map(ResultSet rs) throws SQLException {
        OverallStats o = new OverallStats();
        o.setUserName(rs.getString("user_name"));
        o.setTotalPoint(rs.getBigDecimal("total_point"));
        o.setTotalAmount(rs.getLong("total_amount"));
        o.setAvgRank(rs.getBigDecimal("avg_rank") == null ? BigDecimal.ZERO : rs.getBigDecimal("avg_rank"));
        o.setRecent100AvgRank(rs.getBigDecimal("recent100_avg_rank") == null ? BigDecimal.ZERO : rs.getBigDecimal("recent100_avg_rank"));
        o.setRate1(rs.getBigDecimal("rate1") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate1"));
        o.setRate2(rs.getBigDecimal("rate2") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate2"));
        o.setRate3(rs.getBigDecimal("rate3") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate3"));
        o.setRate4(rs.getBigDecimal("rate4") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate4"));
        o.setParticipateDays(rs.getLong("participate_days"));
        o.setHanshanCount(rs.getLong("hanshan_count"));
        o.setHandCount(rs.getLong("hand_count"));
        o.setWinRate(rs.getBigDecimal("win_rate") == null ? BigDecimal.ZERO : rs.getBigDecimal("win_rate"));
        o.setCallRate(rs.getBigDecimal("call_rate") == null ? BigDecimal.ZERO : rs.getBigDecimal("call_rate"));
        o.setRiichiRate(rs.getBigDecimal("riichi_rate") == null ? BigDecimal.ZERO : rs.getBigDecimal("riichi_rate"));
        o.setDealInRate(rs.getBigDecimal("deal_in_rate") == null ? BigDecimal.ZERO : rs.getBigDecimal("deal_in_rate"));
        return o;
    }

    public List<BigDecimal> findByname(String name) {
        String sql = """
                SELECT
                        SUM(point) AS total_point
                    FROM daa_point
                    where name = ?
                    GROUP BY
                        name, game_id
                    ;
            """;

        return jdbc.query(sql, (rs, rowNum) -> rs.getBigDecimal("total_point"), name);
    }

    public Map<String, BigDecimal> findHarfByname(String name) {
        String sql = """
                WITH split AS (
                      SELECT
                        name,
                        CASE
                          WHEN NTILE(2) OVER (PARTITION BY name, game_id ORDER BY row_no) = 1
                          THEN '前半'
                          ELSE '後半'
                        END AS half,
                        point
                      FROM daa_point
                      WHERE name = ?
                    )
                    SELECT
                      name,
                      half,
                      SUM(point) AS total_point
                    FROM split
                    GROUP BY name, half
                    ORDER BY
                      CASE half WHEN '前半' THEN 1 ELSE 2 END;
            """;

        List<Map.Entry<String, BigDecimal>> rows = jdbc.query(
                sql,
                (rs, rowNum) -> Map.entry(
                        rs.getString("half"),
                        rs.getBigDecimal("total_point")
                ),
                name
        );

        Map<String, BigDecimal> result = new LinkedHashMap<>();
        for (var e : rows) {
            result.put(e.getKey(), e.getValue());
        }
        return result;
    }
}
