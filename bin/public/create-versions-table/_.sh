
source "$THIS_DIR"/bin/public/has-versions-table/_.sh

# === {{CMD}}
# === Uses the env variable: VERSIONS_TABLE_NAME
# === Default: _versions
create-versions-table () {
  if has-versions-table; then
    return 0
  fi

  local SQL="$(cat "$THIS_DIR"/create-versions.sql)"
  SQL="${SQL//"{{TABLE_NAME}}"/$VERSIONS_TABLE_NAME}"

  sh_color BOLD "=== Creating table: {{$VERSIONS_TABLE_NAME}}"
  echo "$SQL" | mysql
} # === end function
