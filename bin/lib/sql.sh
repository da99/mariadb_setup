
standard-name () {
  echo $1 | tr '[:lower:]' '[:upper:]'
}

# === {{CMD}}  UP           path/to/file.sql
# === {{CMD}}  UP-IF        path/to/file.sql
# === {{CMD}}  DOWN         path/to/file.sql
# === {{CMD}}  DOWN-IF      path/to/file.sql
# === {{CMD}}  TOP-COMMENT  path/to/file.sql
# === {{CMD}}  MY-CUSTOM    OTHER-CUSTOM   ...   path/to/file.sql
sql () {
  local +x DIR="$(standard-name $1)";  shift
  local +x TAGS="UP|UP-IF|DOWN|DOWN-IF|$DIR"
  local +x FILE="";

  while [[ ! -z "$@" ]]; do
    if [[ -f "$1" ]]; then
      FILE="$1"
    else
      TAGS="$TAGS|$(standard-name $1)"
    fi
    shift
  done

  if [[ -z "$FILE" ]]; then
    mksh_setup RED "!!! File not specified: $THE_ARGS"
    exit 1
  fi

  if [[ ! -e "$FILE" ]]; then
    mksh_setup RED "!!! File does not exist: {{$FILE}}"
    exit 1
  fi

  if [[ ! -s "$FILE" ]]; then
    mksh_setup RED "!!! File is empty: {{$FILE}}"
    exit 1
  fi

  local +x IFS=$'\n'

  # === IF UNCOMMENT:
  if [[ "$DIR" == 'UNCOMMENT' ]]; then
    # grep -Pzo "(?s)-- \K(.+?)\n" "$FILE"
    sed 's/^-- //'
    return 0
  fi # === IF UNCOMMENT

  # === IF TOP-COMMENT
  if [[ "$DIR" == 'TOP-COMMENT' ]]; then
    grep -Pzo "(?s)\A[\ \n]+\K(.+?)(?=\n[\ \n]{1,})" "$FILE"
    return 0
  fi # === IF TOP-COMMENT

  # === Match: -- $DIR ...
  grep -Pzo "(?s)\n--\ *${DIR}\ *\n\K(.+?)(?=(--\ *(${TAGS})\ *\n|\Z))" "$FILE" || {
    local +x STAT=$?
    if [[ "$DIR" == "UP" ]]; then
      grep -Pzo "(?s)\A[\ \n]*\K(.+?)(?=(--\ *(${TAGS})\ *\n|\Z))" "$FILE"
      return 0
    else
      return $STAT
    fi
  }
} # === end function

specs () {
  local +x DIR="$THIS_DIR/bin/lib/sql"
  local +x SPECS="$(find "$DIR" -mindepth 1 -maxdepth 1 -type f | sort -V)"

  if [[ -z "$SPECS" ]]; then
    mksh_setup RED "!!! No specs found in $DIR"
    exit 1
  fi

  for SPEC in $SPECS; do
    local +x CMD="$(cat "$SPEC" | mksh_setup first-line-after "-- +CMD")"
    echo -n "mariadb_setup sql ""$CMD"" "$SPEC" "

    local +x EXPECT="$(cat "$SPEC" | mksh_setup between-lines "--\ +OUTPUT" "--\ +END")"
    local +x ACTUAL="$(mariadb_setup sql """$CMD""" "$SPEC")"
    should-match "$(echo $EXPECT)" "$(echo $ACTUAL)"
  done

} # === specs ()






