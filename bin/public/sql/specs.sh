
DIR="$THIS_DIR/bin/lib/sql"
SPECS="$(find "$DIR" -mindepth 1 -maxdepth 1 -type f | sort -V)"

if [[ -z "$SPECS" ]]; then
  sh_color RED "!!! No specs found in $DIR"
  exit 1
fi

for SPEC in $SPECS; do
  CMD="$(cat "$SPEC" | mksh_setup first-line-after "-- +CMD")"
  echo -n "mariadb_setup sql ""$CMD"" "$SPEC" "

  EXPECT="$(cat "$SPEC" | mksh_setup between-lines "--\ +OUTPUT" "--\ +END")"
  ACTUAL="$(mariadb_setup sql """$CMD""" "$SPEC")"
  should-match "$(echo $EXPECT)" "$(echo $ACTUAL)"
done

