
# === {{CMD}}
list-tables () {
  local +x SQL="$(cat <<EOF
  SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE
    TABLE_SCHEMA = database()
    AND
    TABLE_TYPE = 'BASE TABLE';
EOF)"
  echo "$SQL" | mysql --skip-column-names
} # === end function
