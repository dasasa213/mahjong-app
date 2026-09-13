package com.example.mahjong.web.repository;

import com.example.mahjong.web.model.GameCounter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Repository
public class GameCounterRepository {

    private final JdbcTemplate jdbc;

    public GameCounterRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /**
     * 指定日・指定ユーザーのカウンターを取得
     */
    public GameCounter findByUserIdAndDate(long userId, LocalDate gameDate) {

        String sql = """
                SELECT
                    id,
                    game_date,
                    user_id,
                    hand_count,
                    win_count,
                    call_count,
                    riichi_count,
                    deal_in_count
                FROM daa_game_counter
                WHERE user_id = ?
                  AND game_date = ?
                """;

        List<GameCounter> list = jdbc.query(
                sql,
                (rs, rowNum) -> {
                    GameCounter counter = new GameCounter();

                    counter.setId(rs.getLong("id"));
                    counter.setGameDate(rs.getDate("game_date").toLocalDate());
                    counter.setUserId(rs.getLong("user_id"));
                    counter.setHandCount(rs.getInt("hand_count"));
                    counter.setWinCount(rs.getInt("win_count"));
                    counter.setCallCount(rs.getInt("call_count"));
                    counter.setRiichiCount(rs.getInt("riichi_count"));
                    counter.setDealInCount(rs.getInt("deal_in_count"));

                    return counter;
                },
                userId,
                Date.valueOf(gameDate)
        );

        if (list.isEmpty()) {
            return null;
        }

        return list.get(0);
    }

    /**
     * 当日のカウンターを登録。
     * 同じ日付・ユーザーが存在する場合は更新する。
     */
    public void saveOrUpdate(GameCounter counter) {

        String sql = """
                INSERT INTO daa_game_counter (
                    game_date,
                    user_id,
                    hand_count,
                    win_count,
                    call_count,
                    riichi_count,
                    deal_in_count
                )
                VALUES (?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    hand_count = VALUES(hand_count),
                    win_count = VALUES(win_count),
                    call_count = VALUES(call_count),
                    riichi_count = VALUES(riichi_count),
                    deal_in_count = VALUES(deal_in_count)
                """;

        jdbc.update(
                sql,
                Date.valueOf(counter.getGameDate()),
                counter.getUserId(),
                counter.getHandCount(),
                counter.getWinCount(),
                counter.getCallCount(),
                counter.getRiichiCount(),
                counter.getDealInCount()
        );
    }

    public List<GameCounter> findByUserId(long userId) {

        String sql = """
            SELECT
                id,
                game_date,
                user_id,
                hand_count,
                win_count,
                call_count,
                riichi_count,
                deal_in_count
            FROM daa_game_counter
            WHERE user_id = ?
            ORDER BY game_date DESC, id DESC
            """;

        return jdbc.query(
                sql,
                (rs, rowNum) -> {
                    GameCounter counter = new GameCounter();

                    counter.setId(rs.getLong("id"));
                    counter.setGameDate(rs.getDate("game_date").toLocalDate());
                    counter.setUserId(rs.getLong("user_id"));
                    counter.setHandCount(rs.getInt("hand_count"));
                    counter.setWinCount(rs.getInt("win_count"));
                    counter.setCallCount(rs.getInt("call_count"));
                    counter.setRiichiCount(rs.getInt("riichi_count"));
                    counter.setDealInCount(rs.getInt("deal_in_count"));

                    return counter;
                },
                userId
        );
    }

    public GameCounter findByIdAndUserId(long id, long userId) {

        String sql = """
            SELECT
                id,
                game_date,
                user_id,
                hand_count,
                win_count,
                call_count,
                riichi_count,
                deal_in_count
            FROM daa_game_counter
            WHERE id = ?
              AND user_id = ?
            """;

        List<GameCounter> list = jdbc.query(
                sql,
                (rs, rowNum) -> {
                    GameCounter counter = new GameCounter();

                    counter.setId(rs.getLong("id"));
                    counter.setGameDate(rs.getDate("game_date").toLocalDate());
                    counter.setUserId(rs.getLong("user_id"));
                    counter.setHandCount(rs.getInt("hand_count"));
                    counter.setWinCount(rs.getInt("win_count"));
                    counter.setCallCount(rs.getInt("call_count"));
                    counter.setRiichiCount(rs.getInt("riichi_count"));
                    counter.setDealInCount(rs.getInt("deal_in_count"));

                    return counter;
                },
                id,
                userId
        );

        return list.isEmpty() ? null : list.get(0);
    }

    public void update(GameCounter counter) {

        String sql = """
            UPDATE daa_game_counter
            SET
                hand_count = ?,
                win_count = ?,
                call_count = ?,
                riichi_count = ?,
                deal_in_count = ?
            WHERE id = ?
              AND user_id = ?
            """;

        jdbc.update(
                sql,
                counter.getHandCount(),
                counter.getWinCount(),
                counter.getCallCount(),
                counter.getRiichiCount(),
                counter.getDealInCount(),
                counter.getId(),
                counter.getUserId()
        );
    }

    public void delete(long id, long userId) {

        String sql = """
            DELETE FROM daa_game_counter
            WHERE id = ?
              AND user_id = ?
            """;

        jdbc.update(sql, id, userId);
    }
}