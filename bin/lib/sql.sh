
# === {{CMD}}  UP       path/to/file.sql
# === {{CMD}}  UP-IF    path/to/file.sql
# === {{CMD}}  DOWN     path/to/file.sql
# === {{CMD}}  DOWN-IF  path/to/file.sql
sql () {
  local +x DIR="$(echo $1 | tr '[:lower:]' '[:upper:]')";  shift
  local +x FILE="$1"; shift

  if [[ ! -e "$FILE" ]]; then
    mksh_setup RED "!!! File does not exist: {{$FILE}}"
    exit 1
  fi

  if [[ ! -s "$FILE" ]]; then
    mksh_setup RED "!!! File is empty: {{$FILE}}"
    exit 1
  fi

  case "$DIR" in
    BOTH|UP|DOWN|"UP-IF"|"DOWN-IF"|OUTPUT)
      :
      ;;
    *)
      mksh_setup RED "!!! Invalid value: {{$DIR}}"
      exit 1
      ;;
  esac

  local +x IFS=$'\n'
  local +x CURRENT="UP"

  for LINE in $(cat "$FILE"); do

    local +x CLEAN_LINE="$(echo $LINE)"
    local +x NEW_DIR="$(echo "$CLEAN_LINE" | grep -Po '^[\-\ ]+\K(UP|DOWN|UP-IF|DOWN-IF)(?=\ *)$' | tr '[:lower:]' '[:upper:]')"

    case "$NEW_DIR" in
      UP)
        CURRENT="UP"
        ;;
      UP-IF)
        CURRENT="UP-IF"
        ;;
      DOWN)
        CURRENT="DOWN"
        ;;
      DOWN-IF)
        CURRENT="DOWN-IF"
        ;;
      *)
        if [[ "$CURRENT" == "$DIR" ]]; then
          echo "$LINE"
        fi
        ;;
    esac
  done

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

    local +x EXPECT="$(cat "$SPEC" | mksh_setup first-line-after "-- +OUTPUT")"
    local +x ACTUAL="$(mariadb_setup sql """$CMD""" "$SPEC")"
    should-match "$(echo $EXPECT)" "$(echo $ACTUAL)"
  done
} # === specs ()






