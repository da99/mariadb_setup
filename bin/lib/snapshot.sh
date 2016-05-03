
# === {{CMD}} path/to/dir
# === Gets definitions of tables, functions, and procedures and saves them to "path/to/dir"
snapshot () {
  local +x DIR="$1"; shift
  mkdir -p "$DIR"

  local +x SQL="$(cat <<EOF
  SELECT SPECIFIC_NAME
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_TYPE = "PROCEDURE"
  ;
EOF)"
  echo "$SQL" | mysql --skip-column-names | while read PROC ; do
    echo 'SHOW CREATE PROCEDURE `'$PROC'`;' | mysql > "$DIR/$PROC.procedure.sql"
    mksh_setup BOLD "=== Procedure: {{$PROC}}"
  done

  local +x SQL="$(cat <<EOF
  SELECT SPECIFIC_NAME
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_TYPE = "FUNCTION"
  ;
EOF)"
  echo "$SQL" | mysql --skip-column-names | while read FUNC ; do
    echo 'SHOW CREATE FUNCTION `'$FUNC'`;' | mysql > "$DIR/$FUNC.function.sql"
    mksh_setup BOLD "=== Function: {{$FUNC}}"
  done

  local +x SQL="$(cat <<EOF
  SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = database();
EOF)"
  echo "$SQL" | mysql --skip-column-names | while read TBL ; do
    echo 'SHOW CREATE TABLE `'$TBL'`;' | mysql > "$DIR/$TBL.table.sql"
    mksh_setup BOLD "=== Table: {{$TBL}}"
  done
} # === end function
