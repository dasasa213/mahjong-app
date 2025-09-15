package com.example.mahjong.web.repository;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class GamePlayersRepository {
    private final JdbcTemplate jdbc;
    public GamePlayersRepository(JdbcTemplate jdbc){ this.jdbc = jdbc; }

    /** 利用者(type='2')のみ。groupId があれば同グループで絞る */
    public List<String> listUserNames(String keyword, String groupId){
        String q = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        if (groupId != null && !groupId.isBlank()){
            return jdbc.query("""
                SELECT name
                  FROM daa_user_knr
                 WHERE type = '2'
                   AND groupid = ?
                   AND name LIKE ?
                 ORDER BY name
            """, (rs,i)->rs.getString(1), groupId, q);
        } else {
            return jdbc.query("""
                SELECT name
                  FROM daa_user_knr
                 WHERE type = '2'
                   AND name LIKE ?
                 ORDER BY name
            """, (rs,i)->rs.getString(1), q);
        }
    }

    /** 後方互換：引数1つ版 */
    public List<String> listUserNames(String keyword){
        return listUserNames(keyword, null);
    }

    /** 対局に紐づく参加者名一覧 */
    public List<String> listPlayerNames(String gameId){
        return jdbc.query("""
            SELECT user_name
              FROM daa_gameplayers
             WHERE game_id = ?
             ORDER BY user_name
        """, (rs,i)->rs.getString(1), gameId);
    }

    /** 指定対局の参加者を全削除（置き換え保存用） */
    public void deleteAll(String gameId){
        jdbc.update("DELETE FROM daa_gameplayers WHERE game_id = ?", gameId);
    }

    /** 5桁ID（00001〜99999）を、現在の最大値+1で採番 */
    private String next5digitId(){
        Integer max = jdbc.queryForObject("""
            SELECT MAX(CAST(id AS UNSIGNED))
              FROM daa_gameplayers
             WHERE id REGEXP '^[0-9]+$'
        """, Integer.class);
        int next = (max == null ? 0 : max) + 1;
        if (next > 99999) throw new IllegalStateException("daa_gameplayers.id が上限(99999)に到達しました。");
        return String.format("%05d", next);
    }

    /** 1件INSERT（PK衝突時はリトライ） */
    private void insertOneWithRetry(String gameId, String userName){
        final String sql = "INSERT INTO daa_gameplayers (id, game_id, user_name) VALUES (?,?,?)";
        final int MAX_RETRY = 5;
        for (int attempt = 1; attempt <= MAX_RETRY; attempt++){
            String id = next5digitId();
            try{
                jdbc.update(sql, id, gameId, userName);
                return;
            }catch (DuplicateKeyException e){
                try { Thread.sleep(10L * attempt); } catch (InterruptedException ignored) {}
            }
        }
        throw new IllegalStateException("daa_gameplayers のID採番で衝突が解消できませんでした。");
    }

    /** 一括登録（順次INSERT） */
    public void bulkInsert(String gameId, List<String> names){
        if (names == null || names.isEmpty()) return;
        for (String name : names){
            insertOneWithRetry(gameId, name);
        }
    }

    public void deleteByGameId(String gameId) {
        jdbc.update("DELETE FROM daa_gameplayers WHERE game_id = ?", gameId);
    }
}
