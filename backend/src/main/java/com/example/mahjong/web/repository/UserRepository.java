package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.LoginUser;
import com.example.mahjong.web.model.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public class UserRepository {

    private final JdbcTemplate jdbc;

    public UserRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

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

    // 最大ID+1 を取得（FOR UPDATE で競合回避）
    @Transactional
    public int nextNumericIdForUpdate() {
        Integer max = jdbc.queryForObject(
                "SELECT COALESCE(MAX(CAST(id AS UNSIGNED)), 0) FROM daa_user_knr FOR UPDATE",
                Integer.class
        );
        return (max == null ? 0 : max) + 1;
    }

    // 追加：ユーザー登録（type=2固定、groupidはセッションのもの）
    public void insertUser(String id, String name, String password, String groupId, String type) {
        jdbc.update(
                "INSERT INTO daa_user_knr (id, name, password, groupid, type) VALUES (?, ?, ?, ?, ?)",
                id, name, password, groupId, type
        );
    }
}
