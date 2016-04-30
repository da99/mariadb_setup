
# === {{CMD}}  BOTH  path/to/file.sql
# === {{CMD}}  UP    path/to/file.sql
# === {{CMD}}  DOWN  path/to/file.sql
sql () {
  local +x DIR="$(echo $1 | tr '[:lower:]' '[:upper:]')";  shift
  local +x FILE="$1"; shift

  case "$DIR" in
    UP|DOWN)
      :
      ;;
    *)
      mksh_setup RED "!!! Invalid value: {{$DIR}}"
      exit 1
      ;;
  esac

  local +x IFS=$'\n'
  local +x UP_CONTENT=""
  local +x DOWN_CONTENT=""
  local +x NO_NAME=""
  local +x CURRENT="UP"

  for LINE in $(cat "$FILE"); do

    local +x CLEAN_LINE="$(echo $LINE)"
    local +x NEW_DIR="$(echo "$CLEAN_LINE" | grep -Po '^[\-\ ]+\K(UP|DOWN|BOTH)(?=\ *)$' | tr '[:lower:]' '[:upper:]')"

    set -x
    case "$NEW_DIR" in
      UP)
        CURRENT="UP"
        ;;
      DOWN)
        CURRENT="DOWN"
        ;;
      BOTH)
        CURRENT="BOTH"
        ;;
      *)
        case "$CURRENT" in
          UP)
            UP_CONTENT="$UP_CONTENT\n$LINE"
            ;;
          DOWN)
            DOWN_CONTENT="$DOWN_CONTENT\n$LINE"
            ;;
          BOTH)
            UP_CONTENT="$UP_CONTENT\n$LINE"
            DOWN_CONTENT="$DOWN_CONTENT\n$LINE"
            ;;
          *)
            mksh_setup RED "!!! Unknown direction: {{$CURRENT}}"
            exit 1
            ;;
        esac
        ;;
    esac
  done

  if [[ "$DIR" == "UP" ]]; then
    echo -e "$UP_CONTENT"
  else
    echo -e "$DOWN_CONTENT"
  fi
} # === end function



