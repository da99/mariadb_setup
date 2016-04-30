
# === {{CMD}}
install-arch-mariadb.sh () {
  if ! which mysqld ; then
    sudo pacman -S mariadb
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    sudo systemctl enable  mysqld.service
    sudo systemctl start   mysqld.service
    sudo systemctl status  mysqld.service
    sudo mysql_secure_installation
    return 0
  fi
  mksh_setup ORANGE "=== Already {{installed}}: mysql/mariadb"
} # === end function
