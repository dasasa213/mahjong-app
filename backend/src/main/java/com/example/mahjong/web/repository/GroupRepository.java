package com.example.mahjong.web.repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class GroupRepository {
    private final JdbcTemplate jdbc;
    public GroupRepository(JdbcTemplate jdbc){ this.jdbc = jdbc; }

    public String findNameById(String groupId){
        var sql = "SELECT name FROM daa_group_knr WHERE groupid = ?";
        return jdbc.query(sql, rs -> rs.next() ? rs.getString("name") : null, groupId);
    }

    public int updateName(String groupId, String newName){
        var sql = "UPDATE daa_group_knr SET name = ? WHERE groupid = ?";
        return jdbc.update(sql, newName, groupId);
    }
}
