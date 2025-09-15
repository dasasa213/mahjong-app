CREATE TABLE daa_gamerecords (
  id            VARCHAR(5) PRIMARY KEY,
  gamedate      DATE NOT NULL,
  gameno        INT NOT NULL,
  rate          INT NOT NULL DEFAULT 50,       -- レート
  points        INT NOT NULL DEFAULT 25000,    -- 持点
  returnpoints  INT NOT NULL DEFAULT 30000,    -- 返し
  uma1          INT NOT NULL DEFAULT 30,       -- ウマ（1位と4位の差など）
  uma2          INT NOT NULL DEFAULT 10,       -- ウマ（2位と3位の差など）
  editing_flag  VARCHAR(255),                  -- 「編集中」などのフラグ
  groupid       varchar(5) NOT NULL,

  UNIQUE KEY uk_gamedate_gameno (gamedate, gameno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
