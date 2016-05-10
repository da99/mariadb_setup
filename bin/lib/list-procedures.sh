
# === {{CMD}}
list-procedures () {
  local +x SQL="$(cat <<EOF
  SELECT SPECIFIC_NAME
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE ROUTINE_TYPE = "PROCEDURE"
  ;
EOF)"
  echo "$SQL" | mysql --skip-column-names
} # === end function
