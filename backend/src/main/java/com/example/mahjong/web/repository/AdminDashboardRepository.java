package com.example.mahjong.web.repository;

import com.example.mahjong.web.admin.GroupRow;
import com.example.mahjong.web.admin.MemberRow;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class AdminDashboardRepository {
    private final JdbcTemplate jdbc;
    public AdminDashboardRepository(JdbcTemplate jdbc){ this.jdbc = jdbc; }

    // ログイン中ユーザの所属グループを取得
    public Optional<GroupRow> findGroupByUserId(Long userId){
        String sql = """
        SELECT g.groupid, g.name, g.sakusei_day
          FROM daa_group_knr g
          JOIN daa_user_knr  u ON u.groupid = g.groupid
         WHERE u.id = ?
        """;
        var list = jdbc.query(sql, (rs, i) -> new GroupRow(
                rs.getString("groupid"),
                rs.getString("name"),
                rs.getString("sakusei_day")
        ), userId);
        return list.stream().findFirst();
    }

    // 同じグループのメンバー一覧
    public List<MemberRow> findMembersByGroupId(String groupId){
        String sql = """
            SELECT u.id, u.name, u.type
              FROM daa_user_knr u
             WHERE u.groupid = ?
             ORDER BY u.id
            """;
        return jdbc.query(sql, (rs, i) ->
                new MemberRow(
                        rs.getString("id"),
                        rs.getString("name"),
                        rs.getString("type")
                ), groupId);
    }
}
