CREATE TABLE daa_ranking (
  ranking_id BIGINT            NOT NULL AUTO_INCREMENT,
  game_id    VARCHAR(5)        NOT NULL,
  row_no     SMALLINT UNSIGNED NOT NULL,
  name       VARCHAR(10)       NOT NULL,
  rank_no    TINYINT           NOT NULL,              -- ← 予約語回避
  created_at TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ranking_id),
  UNIQUE KEY uq_rank_game_row_name (game_id, row_no, name),
  KEY idx_rank_game (game_id),
  CONSTRAINT fk_rank_game
    FOREIGN KEY (game_id) REFERENCES daa_gamerecords(id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_rank_user
    FOREIGN KEY (name)    REFERENCES daa_user_knr(name)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK (rank_no BETWEEN 1 AND 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;