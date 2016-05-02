
source "$THIS_DIR"/bin/lib/has-versions-table.sh

# === {{CMD}}
# === Uses the env variable: VERSIONS_TABLE_NAME
# === Default: _versions
create-versions-table () {
  if has-versions-table; then
    return 0
  fi

  local SQL="$(cat "$THIS_DIR"/create-versions.sql)"
  SQL="${SQL//"{{TABLE_NAME}}"/$VERSIONS_TABLE_NAME}"

  mksh_setup BOLD "=== Creating table: {{$VERSIONS_TABLE_NAME}}"
  echo "$SQL" | mysql
} # === end function
