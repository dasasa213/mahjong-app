CREATE TABLE IF NOT EXISTS daa_point (
  point_id   BIGINT            NOT NULL AUTO_INCREMENT,
  game_id    VARCHAR(5)        NOT NULL,
  row_no     SMALLINT UNSIGNED NOT NULL,
  name       VARCHAR(10)       NOT NULL,
  point      DECIMAL(7,2)      NOT NULL,
  created_at TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (point_id),
  UNIQUE KEY uq_point_game_row_name (game_id, row_no, name),
  KEY idx_point_game (game_id),
  CONSTRAINT fk_point_game
    FOREIGN KEY (game_id) REFERENCES daa_gamerecords(id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT fk_point_user
    FOREIGN KEY (name)    REFERENCES daa_user_knr(name)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;