package com.example.mahjong.web.repository;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;

@Repository
public class DaaGameRecordRepository {
    private final JdbcTemplate jdbc;
    public DaaGameRecordRepository(JdbcTemplate jdbc){ this.jdbc = jdbc; }

    /** 指定日の次の対局番号（MAX+1, 既存なしなら1） */
    public int nextGameno(LocalDate date, String groupId){
        return jdbc.queryForObject(
                "SELECT COALESCE(MAX(gameno),0)+1 FROM daa_gamerecords WHERE gamedate=? AND groupid=?",
                Integer.class, Date.valueOf(date), groupId);
    }

    /** 5桁ID（00001〜99999）を、現在の最大値+1で採番 */
    private String next5digitId(){
        Integer max = jdbc.queryForObject("""
            SELECT MAX(CAST(id AS UNSIGNED))
              FROM daa_gamerecords
             WHERE id REGEXP '^[0-9]+$'
        """, Integer.class);
        int next = (max == null ? 0 : max) + 1;
        if (next > 99999) throw new IllegalStateException("ID上限（99999）に達しました。");
        return String.format("%05d", next);
    }

    /** 新フロー: ヘッダ作成（確定） */
    public String insertHeader(LocalDate date, int gameno, String groupId){
        final String sql = """
        INSERT INTO daa_gamerecords
          (id, gamedate, gameno, rate, points, returnpoints, uma1, uma2, editing_flag, groupid)
        VALUES (?,?,?,?,?,?,?,?,?,?)
    """;
        final int MAX_RETRY = 5;
        for (int i=1;i<=MAX_RETRY;i++){
            String id = next5digitId();
            try{
                jdbc.update(sql, id, Date.valueOf(date), gameno, 50, 25000, 30000, 30, 10, null, groupId);
                return id;
            }catch(DuplicateKeyException e){
                try{ Thread.sleep(10L * i);}catch(InterruptedException ignored){}
            }
        }
        throw new IllegalStateException("ID採番の競合が解消できませんでした。");
    }

    /* ===== ここから後方互換メソッド（既存Service対策） ===== */

    /** 互換: 旧名での作成（内部で insertHeader を呼ぶ） */
    public String insertDraftReturningId(LocalDate date, int gameno, String groupId){
        return insertHeader(date, gameno, groupId);
    }

    /** 互換: 編集完了（現仕様では確定挿入だが、互換のため残す） */
    public void markCompleted(String id){
        jdbc.update("UPDATE daa_gamerecords SET editing_flag = NULL WHERE id = ?", id);
    }
}
