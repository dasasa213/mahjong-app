// src/main/java/com/example/mahjong/web/repository/GameRecordRepository.java
package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.GameRecord;
import com.example.mahjong.web.model.SaveTablesRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Repository
public class GameRecordRepository {

    private final JdbcTemplate jdbc;

    public GameRecordRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public GameRecord findById(String id, String groupId) {
        var sql = """
            SELECT id, gamedate, gameno, rate, points, returnpoints, uma1, uma2, editing_flag
              FROM daa_gamerecords
             WHERE id = ? AND groupid = ?
        """;
        return jdbc.query(sql, rs -> {
            if (rs.next()) {
                var r = new GameRecord();
                r.setId(rs.getString("id"));
                r.setGamedate(rs.getDate("gamedate").toLocalDate());
                r.setGameno(rs.getInt("gameno"));
                r.setRate(rs.getInt("rate"));
                r.setPoints(rs.getInt("points"));
                r.setReturnpoints(rs.getInt("returnpoints"));
                r.setUma1(rs.getInt("uma1"));
                r.setUma2(rs.getInt("uma2"));
                r.setEditingFlag(rs.getString("editing_flag"));
                return r;
            }
            return null;
        }, id, groupId);
    }
    public List<GameRecord> findByDateRange(LocalDate from, LocalDate to, String groupId, String order) {
        String dir = "asc".equalsIgnoreCase(order) ? "ASC" : "DESC"; // ホワイトリスト
        String sql = """
        SELECT id, gamedate, gameno, rate, points, returnpoints, uma1, uma2, editing_flag
          FROM daa_gamerecords
         WHERE gamedate BETWEEN ? AND ?
           AND groupid = ?
         ORDER BY gamedate %s, gameno %s, id %s
    """.formatted(dir, dir, dir); // 同じ向きで並べる

        return jdbc.query(sql, (rs, i) -> {
            GameRecord g = new GameRecord();
            g.setId(rs.getString("id"));
            g.setGamedate(rs.getDate("gamedate").toLocalDate());
            g.setGameno(rs.getInt("gameno"));
            g.setRate(rs.getInt("rate"));
            g.setPoints(rs.getInt("points"));
            g.setReturnpoints(rs.getInt("returnpoints"));
            g.setUma1((Integer) rs.getObject("uma1"));
            g.setUma2((Integer) rs.getObject("uma2"));
            g.setEditingFlag(rs.getString("editing_flag"));
            return g;
        }, Date.valueOf(from), Date.valueOf(to), groupId);
    }

    public int deleteById(String id, String groupId) {
        return jdbc.update("DELETE FROM daa_gamerecords WHERE id = ? AND groupid = ?", id, groupId);
    }

    public int updateById(SaveTablesRequest saveTablesRequest, String gameId, String groupId) {
        SaveTablesRequest.Header header = saveTablesRequest.header;
        String sql = """
        UPDATE daa_gamerecords SET rate = ?, points = ?, returnpoints = ?, uma1 = ?, uma2 = ? WHERE id = ? AND groupid = ?
        """;

        return jdbc.update(sql, header.rate, header.points, header.returnpoints, header.uma1, header.uma2, gameId, groupId);
    }

}
