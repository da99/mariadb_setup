local +x SCHEME_TABLE_NAME="${SCHEME_TABLE_NAME:-"_versions"}"

# === {{CMD}}  # _versions
# === {{CMD}}  _schema_table_name_
create-versions-table () {
  local SQL="$(cat "$THIS_DIR"/create-versions.sql)"
  SQL="${SQL//"{{TABLE_NAME}}"/$SCHEME_TABLE_NAME}"

  echo "$SQL" | mysql

} # === end function
