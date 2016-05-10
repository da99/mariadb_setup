
# === {{CMD}}
list-views () {
  local +x SQL="$(cat <<EOF
  SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = database();
EOF)"
  echo "$SQL" | mysql --skip-column-names
} # === end function
