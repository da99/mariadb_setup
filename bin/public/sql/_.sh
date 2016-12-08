
standard-name () {
  echo $1 | tr '[:lower:]' '[:upper:]'
}

# === {{CMD}}  UP           path/to/file.sql
# === {{CMD}}  UP-IF        path/to/file.sql
# === {{CMD}}  DOWN         path/to/file.sql
# === {{CMD}}  DOWN-IF      path/to/file.sql
# === {{CMD}}  TOP-COMMENT  path/to/file.sql
# === {{CMD}}  MY-CUSTOM    OTHER-CUSTOM   ...   path/to/file.sql
# ===
# === echo "...."  |  {{CMD}}  UNCOMMENT
# ===                 {{CMD}}  UNCOMMENT  path/to/file.sql
sql () {
  local +x DIR="$(standard-name $1)";  shift
  # === IF UNCOMMENT:
  if [[ "$DIR" == 'UNCOMMENT' ]]; then
    sed 's/^-- //'
    return 0
  fi # === IF UNCOMMENT

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
    sh_color RED "!!! File not specified: $THE_ARGS"
    exit 1
  fi

  if [[ ! -e "$FILE" ]]; then
    sh_color RED "!!! File does not exist: {{$FILE}}"
    exit 1
  fi

  if [[ ! -s "$FILE" ]]; then
    sh_color RED "!!! File is empty: {{$FILE}}"
    exit 1
  fi

  local +x IFS=$'\n'


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







