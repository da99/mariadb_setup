
# === {{CMD}}
list-functions () {
  local +x SQL="$(cat <<EOF
  SELECT SPECIFIC_NAME
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_TYPE = "FUNCTION"
  ;
EOF)"
  echo "$SQL" | mysql --skip-column-names
} # === end function
