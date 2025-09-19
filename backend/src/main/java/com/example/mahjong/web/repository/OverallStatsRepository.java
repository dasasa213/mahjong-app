package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.OverallStats;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class OverallStatsRepository {

    private final JdbcTemplate jdbc;

    public OverallStatsRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<OverallStats> findByGroupId(long groupId) {
        String sql = """
                SELECT
                  u.name                                  AS user_name,
                  COALESCE(p.total_point,   0)            AS total_point,
                  COALESCE(p.total_amount,  0)            AS total_amount,
                  COALESCE(r.avg_rank,      0)            AS avg_rank,
                  COALESCE(r.rate1,         0)            AS rate1,
                  COALESCE(r.rate2,         0)            AS rate2,
                  COALESCE(r.rate3,         0)            AS rate3,
                  COALESCE(r.rate4,         0)            AS rate4,
                  COALESCE(gp.play_count,   0)            AS participate_days,
                  COALESCE(pt.hanshan_cnt,  0)            AS hanshan_count
                FROM daa_user_knr u
                LEFT JOIN (
                  SELECT
                    p.name,
                    SUM(p.point)             AS total_point,
                    SUM(p.point * g.rate)    AS total_amount
                  FROM daa_point p
                  JOIN daa_gamerecords g ON g.id = p.game_id
                  GROUP BY p.name
                ) p ON p.name = u.name
                LEFT JOIN (
                  SELECT
                    r.name,
                    AVG(r.rank_no) AS avg_rank,
                    100.0 * SUM(CASE WHEN r.rank_no = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS rate1,
                    100.0 * SUM(CASE WHEN r.rank_no = 2 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS rate2,
                    100.0 * SUM(CASE WHEN r.rank_no = 3 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS rate3,
                    100.0 * SUM(CASE WHEN r.rank_no = 4 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS rate4
                  FROM daa_ranking r
                  GROUP BY r.name
                ) r ON r.name = u.name
                LEFT JOIN (
                  SELECT gp.user_name, COUNT(*) AS play_count
                  FROM daa_gameplayers gp
                  GROUP BY gp.user_name
                ) gp ON gp.user_name = u.name
                LEFT JOIN (
                  SELECT name, COUNT(*) AS hanshan_cnt
                  FROM daa_point
                  GROUP BY name
                ) pt ON pt.name = u.name
                WHERE u.groupid = ?
                  AND u.type = '2'
                ORDER BY u.id;
            """;

        return jdbc.query(sql, (rs, rowNum) -> map(rs), groupId);
    }

    private OverallStats map(ResultSet rs) throws SQLException {
        OverallStats o = new OverallStats();
        o.setUserName(rs.getString("user_name"));
        o.setTotalPoint(rs.getLong("total_point"));
        o.setTotalAmount(rs.getLong("total_amount"));
        o.setAvgRank(rs.getBigDecimal("avg_rank") == null ? BigDecimal.ZERO : rs.getBigDecimal("avg_rank"));
        o.setRate1(rs.getBigDecimal("rate1") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate1"));
        o.setRate2(rs.getBigDecimal("rate2") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate2"));
        o.setRate3(rs.getBigDecimal("rate3") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate3"));
        o.setRate4(rs.getBigDecimal("rate4") == null ? BigDecimal.ZERO : rs.getBigDecimal("rate4"));
        o.setParticipateDays(rs.getLong("participate_days"));
        o.setHanshanCount(rs.getLong("hanshan_count"));
        return o;
    }
}
