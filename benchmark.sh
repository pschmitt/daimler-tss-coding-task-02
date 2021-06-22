#!/usr/bin/env bash

usage() {
  echo "Usage: $(basename "$0") [-i NUM_INTERVALS] [-r NUM_RUNS]"
  echo
  echo "ARGS:"
  echo
  echo "    NUM_INTERVALS  Number of intervals to randomly generate (default: 10)"
  echo "    NUM_RUNS       Number of runs (default: 10)"
}

check_requirements() {
  if ! command -v hyperfine >/dev/null
  then
    {
      echo "This program requires hyperfine to be installed."
      echo "Please head to: https://github.com/sharkdp/hyperfine"
    }>&2
    return 1
  fi
}

# Generate a random interval
# eg: 289,8891
generate_single_interval() {
  local -i r1="$RANDOM"
  local -i r2="$RANDOM"
  local interval

  if [[ "$(printf "%s\n%s" "${r1}" "${r2}" | sort -n | head -1)" == "$r1" ]]
  then
    interval="${r1},${r2}"
  else
    interval="${r2},${r1}"
  fi

  echo -n "$interval"
}

# Generates a bunch of intervals
# eg: 13627,29998 14221,20495 10427,10972 5348,22249 6896,27043
generate_intervals() {
  local num="${1:-10}"
  local -a intervals=()

  for _ in $(seq "$num")
  do
    intervals+=("$(generate_single_interval)")
  done

  echo "${intervals[@]}"
}

# Run the benchmark, using hyperfine
run_bench() {
  cd "$(cd "$(dirname "$0")" >/dev/null 2>&1; pwd -P)" || exit 9

  local intervals
  intervals="$(generate_intervals "${INTERVALS:-10}")"
  set -x
  # shellcheck disable=2128,2086
  hyperfine --min-runs "${RUNS:-10}" "python ./merge_intervals.py $intervals"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  case "$1" in
    help|h|-h|--help)
      usage
      exit 0
      ;;
  esac

  check_requirements || exit 3

  # Defaults
  declare -i INTERVALS=10
  declare -i RUNS=10

  while [[ -n "$*" ]]
  do
    case "$1" in
      -r|--runs)
        RUNS="$2"
        shift 2
        ;;
      -i|--intervals)
        INTERVALS="$2"
        shift 2
        ;;
    esac
  done

  run_bench
fi

# vim: set ft=shet ts=2 sw=2 :
