package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.PairwiseRankDiffRow;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public class PairwiseRankStatsRepository {

    private final JdbcTemplate jdbc;

    public PairwiseRankStatsRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<String> findUserNames(long groupId) {
        String sql = """
                SELECT name
                FROM daa_user_knr
                WHERE groupid = ?
                  AND type = '2'
                ORDER BY id
                """;
        return jdbc.query(sql, (rs, rowNum) -> rs.getString("name"), groupId);
    }

    public List<PairwiseRankDiffRow> findRankDiffRows(long groupId) {
        String sql = """
                SELECT
                  r1.name AS row_user_name,
                  r2.name AS col_user_name,
                  AVG(r1.rank_no - r2.rank_no) AS rank_diff,
                  COUNT(*) AS game_count
                FROM daa_ranking r1
                JOIN daa_ranking r2
                  ON r1.game_id = r2.game_id
                 AND r1.name <> r2.name
                JOIN daa_gamerecords g
                  ON g.id = r1.game_id
                JOIN daa_user_knr u1
                  ON u1.name = r1.name
                 AND u1.groupid = ?
                 AND u1.type = '2'
                JOIN daa_user_knr u2
                  ON u2.name = r2.name
                 AND u2.groupid = ?
                 AND u2.type = '2'
                WHERE g.groupid = ?
                GROUP BY r1.name, r2.name
                """;

        return jdbc.query(sql, (rs, rowNum) -> {
            PairwiseRankDiffRow row = new PairwiseRankDiffRow();
            row.setRowUserName(rs.getString("row_user_name"));
            row.setColUserName(rs.getString("col_user_name"));
            BigDecimal diff = rs.getBigDecimal("rank_diff");
            row.setRankDiff(diff == null ? BigDecimal.ZERO : diff);
            row.setGameCount(rs.getLong("game_count"));
            return row;
        }, groupId, groupId, groupId);
    }
}
