
# === {{CMD}}
# === Only for $IS_DEV="..."
# === Removes all: tables, views, functions, procedures
drop-everything () {
  if ! mksh_setup is-dev; then
    mksh_setup RED "!!! Clean only be used on a {{dev}} machine."
    exit 1
  fi

  for TABLE in $($0 list-tables); do
    mksh_setup ORANGE '=== DROP TABLE `{{'$TABLE'}}`;'
    echo 'DROP TABLE `'$TABLE'`;' | mysql
  done

  for VIEW in $($0 list-views); do
    mksh_setup ORANGE '=== DROP VIEW `{{'$VIEW'}}`;'
    echo 'DROP VIEW `'$VIEW'`;' | mysql
  done

  for FUNC in $($0 list-functions); do
    mksh_setup ORANGE '=== DROP FUNCTION `{{'$FUNC'}}`;'
    echo 'DROP FUNCTION `'$FUNC'`;' | mysql
  done

  for PROC in $($0 list-procedures); do
    mksh_setup ORANGE '=== DROP PROCEDURE `{{'$PROC'}}`;'
    echo 'DROP PROCEDURE `'$PROC'`;' | mysql
  done
} # === end function



