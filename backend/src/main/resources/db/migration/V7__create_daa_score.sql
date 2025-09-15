CREATE TABLE IF NOT EXISTS daa_score (
  score_id   BIGINT            NOT NULL AUTO_INCREMENT,
  game_id    VARCHAR(5)        NOT NULL,
  row_no     SMALLINT UNSIGNED NOT NULL,
  name       VARCHAR(10)       NOT NULL,
  score      INT               NOT NULL,     -- マイナス可／上限なし
  created_at TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (score_id),
  UNIQUE KEY uq_score_game_row_name (game_id, row_no, name),
  KEY idx_score_game (game_id),
  CONSTRAINT fk_score_game
    FOREIGN KEY (game_id) REFERENCES daa_gamerecords(id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_score_user
    FOREIGN KEY (name)    REFERENCES daa_user_knr(name)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
