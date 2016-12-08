
source "$THIS_DIR"/bin/public/describe/_.sh
source "$THIS_DIR"/bin/public/has-versions-table/_.sh
source "$THIS_DIR"/bin/public/underscore-sql-files/_.sh
source "$THIS_DIR"/bin/public/regular-sql-files/_.sh

# === {{CMD}}  NAME   pat/to/dir/of/sql/files/
DOWN () {
  local +x NAME="$1"; shift
  local +x DIR="$1";  shift
  local +x IS_DEV="${IS_DEV:-""}"

  if [[ -z "$IS_DEV" ]]; then
    sh_color RED "!!! This is not a dev machine."
    exit 1
  fi

  if ! has-versions-table ; then
    sh_color ORANGE "=== No {{versions}} table found." >&2
    return 0
  fi

  # === Regular migration files:
  local +x TARGET_BASENAMES="$(describe "$NAME" | tac)"
  if [[ -z "$TARGET_BASENAMES" ]]; then
    sh_color ORANGE "=== {{Up-to-date}}: $NAME"
  fi

  for BASENAME in $TARGET_BASENAMES; do
    local +x FILE="$DIR/$BASENAME"
    sh_color BOLD "=== Running down: {{$FILE}}"
    $0 sql DOWN "$FILE" | mysql || {
      local +x stat="$?"
      # cat "$FILE"
      exit "$stat"
    }
    echo "DELETE FROM $VERSIONS_TABLE_NAME WHERE name = \"$NAME\" AND file_name = \"$BASENAME\" ;" | mysql
  done

  # === Underscore files: __files
  for FILE in $(underscore-sql-files "$DIR" | tac) ; do
    sh_color BOLD "=== Running down: {{$FILE}}"
    $0 sql DOWN "$FILE" | mysql || {
      local +x stat="$?"
      # cat "$FILE"
      exit "$stat"
    }
  done


} # === end function
