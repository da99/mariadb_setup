
CREATE TABLE IF NOT EXISTS {{TABLE_NAME}} (
  name              varchar(255) NOT NULL PRIMARY KEY,
  version           varchar(255) NOT NULL UNIQUE
);
