package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.LoginUser;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class UserRepository {

    private final JdbcTemplate jdbc;

    public UserRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public Optional<LoginUser> findByNameAndPassword(String name, String password) {
        var sql = """
        SELECT u.id,
               u.name      AS user_name,
               u.groupid   AS group_id,
               g.name      AS group_name,
               u.type      AS user_type
          FROM daa_user_knr u
          LEFT JOIN daa_group_knr g ON g.groupid = u.groupid
         WHERE u.name = ? AND u.password = ?
        """;

        var list = jdbc.query(sql, (rs, n) -> new LoginUser(
                rs.getString("id"),
                rs.getString("user_name"),
                rs.getString("group_id"),
                rs.getString("group_name"),
                toInteger(rs.getObject("user_type"))
        ), name, password);

        return list.stream().findFirst();
    }

    private static Integer toInteger(Object v) {
        if (v == null) return null;
        if (v instanceof Number num) return num.intValue();
        return Integer.valueOf(v.toString().trim()); // "1" → 1
    }
}
