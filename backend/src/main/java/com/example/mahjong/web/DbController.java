package com.example.mahjong.web;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class DbController {

    private final JdbcTemplate jdbc;

    public DbController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/db/ping")
    public Map<String, String> ping() {
        Integer one = jdbc.queryForObject("SELECT 1", Integer.class);
        return Map.of("status", "db: ok", "select1", String.valueOf(one));
    }

    @GetMapping("/db/info")
    public Map<String, String> info() {
        return jdbc.queryForObject(
                "SELECT DATABASE() db, CURRENT_USER() dbUser",
                (rs, rowNum) -> Map.of(
                        "database", rs.getString("db"),
                        "user", rs.getString("dbUser")
                )
        );
    }

    @GetMapping("/db/version")
    public Map<String, String> version() {
        String v = jdbc.queryForObject("SELECT VERSION()", String.class);
        return Map.of("mysqlVersion", v);
    }

    @GetMapping("/db/now")
    public Map<String, String> now() {
        String ts = jdbc.queryForObject("SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')", String.class);
        return Map.of("now", ts);
    }
}
