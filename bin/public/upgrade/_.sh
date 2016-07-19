
# === {{CMD}}
upgrade () {
  if pacman -Q -u mariadb; then
   sudo pacman -Syu mariadb
   sudo mysql_upgrade -u root -p
 fi
} # === end function
