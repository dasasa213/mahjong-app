CREATE TABLE daa_gameplayers (
  id       VARCHAR(5) PRIMARY KEY,
  game_id  VARCHAR(5) NOT NULL,
  user_name  VARCHAR(10) NOT NULL,
  UNIQUE KEY uk_game_user (game_id, user_name),
  INDEX idx_game (game_id),
  INDEX idx_user (user_name),
  CONSTRAINT fk_gp_game FOREIGN KEY (game_id) REFERENCES daa_gamerecords(id),
  CONSTRAINT fk_gp_user FOREIGN KEY (user_name) REFERENCES daa_user_knr(name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
