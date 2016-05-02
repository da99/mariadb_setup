
source "$THIS_DIR"/bin/lib/describe.sh
source "$THIS_DIR"/bin/lib/has-versions-table.sh
source "$THIS_DIR"/bin/lib/underscore-sql-files.sh
source "$THIS_DIR"/bin/lib/regular-sql-files.sh

# === {{CMD}}  NAME   pat/to/dir/of/sql/files/
DOWN () {
  local +x NAME="$1"; shift
  local +x DIR="$1";  shift
  local +x IS_DEV="${IS_DEV:-""}"

  if [[ -z "$IS_DEV" ]]; then
    mksh_setup RED "!!! This is not a dev machine."
    exit 1
  fi

  if ! has-versions-table ; then
    mksh_setup ORANGE "=== No {{versions}} table found." >&2
    return 0
  fi

  # === Regular migration files:
  local +x TARGET_BASENAMES="$(describe "$NAME" | tac)"
  if [[ -z "$TARGET_BASENAMES" ]]; then
    mksh_setup ORANGE "=== {{Up-to-date}}: $NAME"
  fi

  for BASENAME in $TARGET_BASENAMES; do
    local +x FILE="$DIR/$BASENAME"
    mksh_setup BOLD "=== Running down: {{$FILE}}"
    $0 sql DOWN "$FILE" | mysql || {
      local +x stat="$?"
      # cat "$FILE"
      exit "$stat"
    }
    echo "DELETE FROM $VERSIONS_TABLE_NAME WHERE name = \"$NAME\" AND file_name = \"$BASENAME\" ;" | mysql
  done

  # === Underscore files: __files
  for FILE in $(underscore-sql-files "$DIR" | tac) ; do
    mksh_setup BOLD "=== Running down: {{$FILE}}"
    $0 sql DOWN "$FILE" | mysql || {
      local +x stat="$?"
      # cat "$FILE"
      exit "$stat"
    }
  done


} # === end function
