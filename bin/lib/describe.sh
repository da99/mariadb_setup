
source "$THIS_DIR"/bin/lib/has-versions-table.sh

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
