package com.example.mahjong.web.repository;


import com.example.mahjong.web.model.SaveTablesRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SaveTablesRepository {
    private final JdbcTemplate jdbc;
    public SaveTablesRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public void insertScore(String gameId, SaveTablesRequest.Row row) {
        jdbc.update("INSERT INTO daa_score (game_id, row_no, name, score) VALUES (?, ?, ?, ?);", gameId, row.row_num, row.name, row.value);
    }

    public void insertRanking(String gameId, SaveTablesRequest.Row row) {
        jdbc.update("INSERT INTO daa_ranking (game_id, row_no, name, rank_no) VALUES (?, ?, ?, ?);", gameId, row.row_num, row.name, row.value);
    }

    public void insertPoint(String gameId, SaveTablesRequest.Row row) {
        jdbc.update("INSERT INTO daa_point (game_id, row_no, name, point) VALUES (?, ?, ?, ?);", gameId, row.row_num, row.name, row.value);
    }

    public void deleteALL(String game_id) {
        deleteScore(game_id);
        deleteRanking(game_id);
        deletePoint(game_id);
    }

    public void deleteScore(String game_id) {
        jdbc.update("DELETE FROM daa_score WHERE game_id = ?", game_id);
    }
    public void deleteRanking(String game_id) {
        jdbc.update("DELETE FROM daa_ranking WHERE game_id = ?", game_id);
    }
    public void deletePoint(String game_id) {
        jdbc.update("DELETE FROM daa_point WHERE game_id = ?", game_id);
    }

    public SaveTablesRequest findGame(SaveTablesRequest saveTablesRequest, String game_id) {
        saveTablesRequest.scores = findByIdScore(game_id);
        saveTablesRequest.rankings = findByIdRanking(game_id);
        saveTablesRequest.points = findByIdPoint(game_id);
        
        return saveTablesRequest;
    }

    public List<SaveTablesRequest.Row> findByIdScore(String game_id) {
        var sql = """
            SELECT row_no, name, score
              FROM daa_score
             WHERE game_id = ?
             ORDER BY row_no
        """;
        return jdbc.query(sql, (rs, i) -> {
            var row = new SaveTablesRequest.Row();
            row.row_num = rs.getInt("row_no");
            row.name = rs.getString("name");
            row.value = rs.getBigDecimal("score");
            return row;
        }, game_id);
    }

    public List<SaveTablesRequest.Row> findByIdRanking(String game_id) {
        var sql = """
            SELECT row_no, name, rank_no
              FROM daa_ranking
             WHERE game_id = ?
             ORDER BY row_no
        """;
        return jdbc.query(sql, (rs, i) -> {
            var row = new SaveTablesRequest.Row();
            row.row_num = rs.getInt("row_no");
            row.name = rs.getString("name");
            row.value = rs.getBigDecimal("rank_no");
            return row;
        }, game_id);
    }

    public List<SaveTablesRequest.Row> findByIdPoint(String game_id) {
        var sql = """
            SELECT row_no, name, point
              FROM daa_point
             WHERE game_id = ?
             ORDER BY row_no
        """;
        return jdbc.query(sql, (rs, i) -> {
            var row = new SaveTablesRequest.Row();
            row.row_num = rs.getInt("row_no");
            row.name = rs.getString("name");
            row.value = rs.getBigDecimal("point");
            return row;
        }, game_id);
    }


}
