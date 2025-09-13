CREATE TABLE IF NOT EXISTS daa_user_knr (
  id         VARCHAR(5)   PRIMARY KEY,
  name       VARCHAR(5)   NOT NULL,
  password   VARCHAR(10)  NOT NULL,   -- BCrypt格納
  groupid    VARCHAR(5)   NOT NULL,
  type       CHAR(1)      NOT NULL   -- '1':管理者, '2':利用者
);