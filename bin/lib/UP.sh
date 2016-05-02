
source $THIS_DIR/bin/lib/create-versions-table.sh
source $THIS_DIR/bin/lib/regular-sql-files.sh
source $THIS_DIR/bin/lib/underscore-sql-files.sh
source $THIS_DIR/bin/lib/describe.sh

# === {{CMD}}  NAME  dir/of/sql/files
# === Uses SCHEME_TABLE_NAME="_migrate_versions"
UP () {
  local +x NAME="$1"; shift
  local +x DIR="$1";  shift

  create-versions-table
  local +x CURRENT="$(describe "$NAME" || echo "error")"

  if [[ "$CURRENT" == "error" ]]; then
    exit 1
  fi

  local +x IFS=$'\n'
  # === Files that always are run (eg stored procedures):
  for FILE in $(underscore-sql-files "$DIR") ; do
    mksh_setup BOLD "=== Running: {{$FILE}}"
    $0 sql UP "$FILE" | mysql || {
      local +x stat="$?"
      # cat "$FILE"
      exit "$stat"
    }
    local +x BASENAME="$(basename "$FILE")"
    local +x SQL="$(cat <<EOF
      INSERT IGNORE INTO $VERSIONS_TABLE_NAME (name, file_name)
      VALUES ( "$NAME" , "$BASENAME");
EOF)"
    echo "$SQL" | mysql
  done

  # === Regular migration files:
  local +x PATTERNS="$(mktemp)"
  describe "$NAME" > "$PATTERNS"
  local +x REG_SQL_FILE_NAMES="$(regular-sql-files "$DIR" | xargs -I SQL_FILE basename "SQL_FILE" | grep -x -v -f "$PATTERNS")"
  rm -f "$PATTERNS"

  if [[ -z "$REG_SQL_FILE_NAMES" ]]; then
    mksh_setup BOLD "=== {{Up-to-date}}: $NAME" >&2
    return 0
  fi

  for BASENAME in $REG_SQL_FILE_NAMES ; do
    local +x FILE="$DIR"/"$BASENAME"
    $0 sql UP "$FILE" | mysql || {
      local +x stat="$?"
      # cat "$FILE"
      exit "$stat"
    }
    local +x SQL="$(cat <<EOF
      INSERT INTO $VERSIONS_TABLE_NAME (name, file_name)
      VALUES ( "$NAME" , "$BASENAME");
EOF)"
    mksh_setup BOLD "=== Running: {{$FILE}}"
    echo "$SQL" | mysql
  done

} # === end function

