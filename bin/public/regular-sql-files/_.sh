
# === {{CMD}}  path/to/dir
regular-sql-files () {
  local +x DIR="$1"; shift
  find "$DIR" -maxdepth 1 -mindepth 1 -type f -name '*.sql' -print | sort -V | grep -v -P "/_[^\/]+.sql"
} # === end function
