#!/usr/bin/env mksh
#
#
THE_ARGS="$@"
THIS_DIR="$(bash_setup dirname_of_bin "$0")"

if [[ -z "$@" ]]; then
  action="watch"
else
  action=$1
  shift
fi

set -u -e -o pipefail

case $action in
  help|--help)
    mksh_setup print-help $0
    ;;

  *)
    func_file="$THIS_DIR/bin/lib/${action}.sh"
    if [[ -s "$func_file" ]]; then
      source "$func_file"
      "$action" $@
      exit 0
    fi

    # === Check progs/bin:
    if [[ -f "progs/bin/$action" ]]; then
      export PATH="$PWD/progs/bin:$PATH"
      progs/bin/$action $@
      exit 0
    fi

    # === It's an error:
    echo "!!! Unknown action: $action" 1>&2
    exit 1
    ;;

esac
