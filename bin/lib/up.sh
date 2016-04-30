
source $THIS_DIR/bin/lib/create-versions-table.sh

# === {{CMD}}  NAME  dir/of/sql/files
# === Uses SCHEME_TABLE_NAME="_migrate_versions"
up () {
  local +x NAME="$1"; shift
  local +x DIR="$1";  shift

  create-versions-table

  # === Files that always are run (eg stored procedures):
  for FILE in $(find "$DIR" -maxdepth 1 -mindepth 1 -type f -name '*.sql' -print | sort -V | grep -v -P "/[0-9]+[^\/]+.sql") ; do
    mksh_setup BOLD "=== Executing: {{$FILE}}"
    mysql < "$FILE" || {
      local +x stat="$?"
      cat "$FILE"
      exit "$stat"
    }
  done

  # === Regular migration files:
  for FILE in $(find "$DIR" -maxdepth 1 -mindepth 1 -type f -name '*.sql' -print | sort -V | grep -v -P "/_[^\/]+.sql") ; do
    echo "=== $FILE"
  done

} # === end function


