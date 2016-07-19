
source "$THIS_DIR"/bin/public/has-versions-table/_.sh

# === {{CMD}}  Name
describe () {
  if ! has-versions-table ; then
    return 0
  fi

  local +x NAME="$1"; shift
  local +x SQL="$(cat <<EOF
    SELECT file_name
      FROM $VERSIONS_TABLE_NAME
      WHERE name = "$NAME"
      ORDER BY id;
EOF)"
  echo "$SQL" | mysql --skip-column-names
} # === end function
