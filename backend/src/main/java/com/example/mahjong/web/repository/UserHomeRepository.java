package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.UserHomeStats;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class UserHomeRepository {

    private final JdbcTemplate jdbc;
    public UserHomeRepository(JdbcTemplate jdbc){ this.jdbc = jdbc; }

    /**
     * 利用者ホーム用 4指標
     *  - 直近の対局日（グループ全体）
     *  - 合計点数（ユーザー×グループ）
     *  - 合計金額（ユーザー×グループ） = SUM(point * rate)
     *  - 平均順位（ユーザー×グループ）  = AVG(rank_no)
     */
    public UserHomeStats findStats(String groupId, String userName){
        String sql = """
            SELECT
              /* 直近の対局日（グループ内） */
              (SELECT MAX(g.gamedate)
                 FROM daa_gamerecords g
                WHERE g.groupid = ?) AS last_date,

              /* 合計点数（ユーザー×グループ） */
              (SELECT COALESCE(SUM(p.point), 0)
                 FROM daa_point p
                 JOIN daa_gamerecords g ON g.id = p.game_id
                WHERE g.groupid = ?
                  AND p.name    = ?) AS total_point,

              /* 合計金額（ユーザー×グループ）: point * rate の総和 */
              (SELECT COALESCE(SUM(p.point * g.rate), 0)
                 FROM daa_point p
                 JOIN daa_gamerecords g ON g.id = p.game_id
                WHERE g.groupid = ?
                  AND p.name    = ?) AS total_amount,

              /* 平均順位（ユーザー×グループ） */
              (SELECT AVG(r.rank_no)
                 FROM daa_ranking r
                 JOIN daa_gamerecords g ON g.id = r.game_id
                WHERE g.groupid = ?
                  AND r.name    = ?) AS avg_rank
            """;

        return jdbc.query(sql, rs -> rs.next() ? map(rs) : new UserHomeStats(),
                groupId, groupId, userName, groupId, userName, groupId, userName);
    }

    private UserHomeStats map(ResultSet rs) throws SQLException {
        var s = new UserHomeStats();
        s.setLastDate(rs.getDate("last_date"));
        // point は INT 想定のため long で受け取り（DECIMAL の場合は getBigDecimal に変更してください）
        s.setTotalPoint(rs.getLong("total_point"));
        // 金額は設計に合わせて long。必要なら getBigDecimal へ変更可
        s.setTotalAmount(rs.getLong("total_amount"));

        BigDecimal avg = rs.getBigDecimal("avg_rank");
        s.setAvgRank(avg == null ? BigDecimal.ZERO : avg);
        return s;
    }
}
