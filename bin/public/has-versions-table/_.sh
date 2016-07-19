
source "$THIS_DIR"/bin/public/versions-table-name/_.sh

# === {{CMD}}
# === Exits with 0 if table exists, non-zero otherwise.
has-versions-table () {
  echo "SHOW TABLES" | mysql | grep '^'$VERSIONS_TABLE_NAME'$' >/dev/null 2>&1
} # === end function
