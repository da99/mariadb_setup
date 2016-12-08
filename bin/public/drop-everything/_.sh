
# === {{CMD}}
# === Only for $IS_DEV="..."
# === Removes all: tables, views, functions, procedures
drop-everything () {
  if ! mksh_setup is-dev; then
    sh_color RED "!!! Clean only be used on a {{dev}} machine."
    exit 1
  fi

  for TABLE in $($0 list-tables); do
    sh_color ORANGE '=== DROP TABLE `{{'$TABLE'}}`;'
    echo 'DROP TABLE `'$TABLE'`;' | mysql
  done

  for VIEW in $($0 list-views); do
    sh_color ORANGE '=== DROP VIEW `{{'$VIEW'}}`;'
    echo 'DROP VIEW `'$VIEW'`;' | mysql
  done

  for FUNC in $($0 list-functions); do
    sh_color ORANGE '=== DROP FUNCTION `{{'$FUNC'}}`;'
    echo 'DROP FUNCTION `'$FUNC'`;' | mysql
  done

  for PROC in $($0 list-procedures); do
    sh_color ORANGE '=== DROP PROCEDURE `{{'$PROC'}}`;'
    echo 'DROP PROCEDURE `'$PROC'`;' | mysql
  done
} # === end function



