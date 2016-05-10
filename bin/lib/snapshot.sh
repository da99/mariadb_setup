
# === {{CMD}} path/to/dir
# === Gets definitions of tables, functions, and procedures and saves them to "path/to/dir"
snapshot () {
  local +x DIR="$1"; shift
  mkdir -p "$DIR"

  # === Procedures:
  $0 list-procedures | while read PROC ; do
    echo "$(echo 'SHOW CREATE PROCEDURE `'$PROC'`;' | mysql)" > "$DIR/$PROC.procedure.sql"
    mksh_setup BOLD "=== Procedure: {{$PROC}}"
  done

  # === Functions:
  $0 list-functions | while read FUNC ; do
    echo "$(echo 'SHOW CREATE FUNCTION `'$FUNC'`;' | mysql)" > "$DIR/$FUNC.function.sql"
    mksh_setup BOLD "=== Function: {{$FUNC}}"
  done

  # === Tables:
  $0 list-tables | while read TBL ; do
    echo "$(echo 'SHOW CREATE TABLE `'$TBL'`;' | mysql)" > "$DIR/$TBL.table.sql"
    mksh_setup BOLD "=== Table: {{$TBL}}"
  done

  # === Views:
  $0 list-views | while read VIEW ; do
    echo "$(echo 'SHOW CREATE VIEW `'$VIEW'`;' | mysql)" > "$DIR/$VIEW.view.sql"
    mksh_setup BOLD "=== View: {{$VIEW}}"
  done
} # === end function