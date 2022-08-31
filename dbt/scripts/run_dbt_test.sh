#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
dbt_test_dir="$script_dir/../orders_analytics/test"


usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h | --help] [-c | --clean] [--target <target_name>] [--threads <parallelism>]

Script to automate the execution of DBT tests.

Available options:

-h, --help        Print this help and exit
-c, --clean       Flag to clean and resolve dependencies before running a DBT command
--target          The target profile database (local by default)
--threads         The level of paralellism when executing the tests (by default, the configured value in the DBT profile)

EOF
  exit
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  echo "$msg"
  exit "$code"
}

parse_params() {
  
  # default values of variables set from params
  clean=0
  target=local
  threads=0

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -c | --clean) clean=1 ;;
    --target) target="${2-}" 
      shift
      ;;
    --threads) threads="${2-}"
        shift
        ;;
    --) break ;;
      -?*) die "unrecognized option: $1" ;;
    *) break;;
    esac
    shift
  done

  return 0
}

print_params() {
  echo 
  echo "Running with parameters:"
  echo "- target: $target"
  echo "- clean: $clean"
  if [[ $threads -ne 0 ]]; then
    echo "- threads: $threads"
  fi
}


run_test_dbt() {
    
    cd $dbt_test_dir
    check_clean_run 

    if [[ $threads -ne 0 ]]; then
      dbt_threads="--threads "$threads
    fi

    echo 
    echo "------- RUNNING TESTS ------"
    dbt test --target=${target} $dbt_threads || EXIT_STATUS=$?
    
}

check_clean_run() {
    if [[ $clean -eq 1 ]]; then
        dbt clean && dbt deps || EXIT_STATUS=$?
    fi
}

# Run the tests
EXIT_STATUS=0

parse_params "$@"
print_params
run_test_dbt

exit $EXIT_STATUS