
CREATE TABLE IF NOT EXISTS {{TABLE_NAME}} (
  id                SMALLINT     AUTO_INCREMENT PRIMARY KEY,
  name              varchar(255) NOT NULL,
  file_name         varchar(255) NOT NULL,
  CONSTRAINT UNIQUE `name_to_file_name_unique_idx` (name, file_name)
);
