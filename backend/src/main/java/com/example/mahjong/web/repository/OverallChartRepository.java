package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.GraphPoint;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Repository
public class OverallChartRepository {

    private final JdbcTemplate jdbc;
    private static final DateTimeFormatter DF = DateTimeFormatter.ISO_LOCAL_DATE;

    public OverallChartRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /** 同一グループの「利用者のみ」名前一覧（type=2=利用者。管理者は除外） */
    public List<String> findUserNamesInGroup(String groupId) {
        String sql = """
            SELECT u.name
              FROM daa_user_knr u
             WHERE u.groupid = ?
               AND u.type = 2
             ORDER BY u.id
            """;
        return jdbc.query(sql, (rs, i) -> rs.getString("name"), groupId);
    }

    /**
     * グラフ用シリーズ（ユーザ名指定）:
     *  - cum_point   : 点数（日合計）を累積
     *  - cum_amount  : 金額（日合計= point × g.rate）を累積
     *  - cum_avg_rank: 累積平均順位 = 累積「順位合計」/ 累積「対局数」
     *
     * 注意（MySQL対応）:
     *  - day_point と day_rank を別々に集計 → UNION ALL → GROUP BY gamedate で日単位に結合
     *  - 対局数は ranking のレコード数（= COUNT(r.rank_no)）
     */
    public List<GraphPoint> loadCumulativeSeriesByName(String groupId, String userName) {
        String sql = """
            WITH
            day_point AS (
                SELECT
                    g.gamedate                                         AS gamedate,
                    SUM(p.point)                                       AS day_point,
                    SUM(p.point * COALESCE(g.rate, 0))                 AS day_amount
                  FROM daa_gamerecords g
                  JOIN daa_point p
                    ON p.game_id = g.id
                 WHERE g.groupid = ?
                   AND p.name    = ?
                 GROUP BY g.gamedate
            ),
            day_rank AS (
                SELECT
                    g.gamedate                                         AS gamedate,
                    SUM(r.rank_no)                                     AS day_rank_sum,
                    COUNT(r.rank_no)                                   AS day_games
                  FROM daa_gamerecords g
                  JOIN daa_ranking r
                    ON r.game_id = g.id
                 WHERE g.groupid = ?
                   AND r.name    = ?
                 GROUP BY g.gamedate
            ),
            day_union AS (
                SELECT gamedate, day_point, day_amount, 0 AS day_rank_sum, 0 AS day_games
                  FROM day_point
                UNION ALL
                SELECT gamedate, 0, 0, day_rank_sum, day_games
                  FROM day_rank
            ),
            day_agg AS (
                SELECT
                    gamedate,
                    SUM(day_point)     AS day_point,
                    SUM(day_amount)    AS day_amount,
                    SUM(day_rank_sum)  AS day_rank_sum,
                    SUM(day_games)     AS day_games
                  FROM day_union
                 GROUP BY gamedate
            )
            SELECT
                gamedate,
                SUM(day_point)  OVER (ORDER BY gamedate
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_point,
                SUM(day_amount) OVER (ORDER BY gamedate
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_amount,
                CASE
                  WHEN SUM(day_games) OVER (ORDER BY gamedate
                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) = 0
                  THEN 0
                  ELSE
                    SUM(day_rank_sum) OVER (ORDER BY gamedate
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                    /
                    SUM(day_games) OVER (ORDER BY gamedate
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                END AS cum_avg_rank
            FROM day_agg
            ORDER BY gamedate
            """;

        return jdbc.query(sql, (rs, i) -> {
            Date d = rs.getDate("gamedate");
            String dateStr = d.toLocalDate().format(DF);
            double cumPoint   = rs.getBigDecimal("cum_point")    == null ? 0.0 : rs.getBigDecimal("cum_point").doubleValue();
            double cumAmount  = rs.getBigDecimal("cum_amount")   == null ? 0.0 : rs.getBigDecimal("cum_amount").doubleValue();
            double cumAvgRank = rs.getBigDecimal("cum_avg_rank") == null ? 0.0 : rs.getBigDecimal("cum_avg_rank").doubleValue();
            return new GraphPoint(dateStr, cumPoint, cumAmount, cumAvgRank);
        }, groupId, userName, groupId, userName);
    }
}