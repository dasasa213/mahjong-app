package com.example.mahjong.web.dao;

import com.example.mahjong.web.model.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserDao {
    private final JdbcTemplate jdbc;
    public UserDao(JdbcTemplate jdbc){ this.jdbc = jdbc; }

    public User findByName(String name){
        var sql = "SELECT id, name, password, type FROM daa_user_knr WHERE name = ?";
        return jdbc.query(sql, rs -> {
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getString("id"));
                u.setName(rs.getString("name"));
                u.setPassword(rs.getString("password")); // プレーン比較
                u.setType(rs.getString("type"));         // '1' or '2'
                return u;
            }
            return null;
        }, name);
    }
}
