#!/usr/bin/env python3
# coding: utf-8


import argparse
import logging
import pprint
import re
import sys

LOGGER = logging.getLogger(__name__)


def read_interval(s: str) -> list:
    """
    Parse strings as intervals
    Format: [\d+,\d+] (brackets are optional)
    """
    # NOTE: I made the brackets optional here.
    match = re.match(r"\[?(\d+)\s*,\s*(\d+)\]?", s)
    if not match:
        raise ValueError(f"Invalid interval: {s}")
    interval_start = int(match.group(1))
    # NOTE: range()'s args are -> inclusive for start but exclusive for stop
    # hence the +1 below
    interval_stop = int(match.group(2)) + 1
    assert interval_start < interval_stop, f"Invalid interval: {s}"
    # FIXME Using a list here is a bit of a waste of memory here.
    # A set will most prob be better suited, especially since we do not
    # care about the values inbetween start and stop.
    return list(range(interval_start, interval_stop))


def merge_intervals(intervals: list) -> list:
    """
    Merge several intervals together (provided they overlap). If there's no
    overlap return the interval as is.
    """
    # Ensure intervals are sorted (by min/start value)
    intervals = sorted(intervals, key=lambda x: x[0])
    LOGGER.debug(f"Sorted Intervals: {pprint.pformat(intervals)}")
    # [2, 5] -> intv_start=2 ; intv_stop=5
    intv_start = intervals[0][0]
    intv_stop = intervals[0][-1]

    for current_interval in intervals[1:]:
        # Compare the intv_start val of the current interval with intv_stop
        # value of the first interval
        if current_interval[0] <= intv_stop:
            # Overlap: merge with with current interval
            intv_stop = max(intv_stop, current_interval[-1])
        else:
            # No overlap. Return verbatim
            yield [intv_start, intv_stop]
            # Reset intv_stop and intv_start values with min/max values of
            # current interval
            intv_start = current_interval[0]
            intv_stop = current_interval[-1]

    yield [intv_start, intv_stop]


def parse_args() -> argparse.Namespace:
    """
    Parse CLI Args
    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-d",
        "--debug",
        action="store_true",
        default=False,
        help="Debug. Verbose output",
    )
    parser.add_argument("INTERVAL", nargs="+")
    return parser.parse_args()


def main() -> int:
    """
    Main logic, entrypoint
    returns the exit code
    """
    try:
        args = parse_args()
        logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)
        LOGGER.debug(f"ARGS: {args}")
        # parse provided intervals
        intervals = [read_interval(x) for x in args.INTERVAL]
        res = [x for x in merge_intervals(intervals)]
        # FIXME This is a bit hard to read
        print(" ".join(str(f"[{x[0]},{x[1]}]") for x in res))
        return 0
    except Exception as exc:
        LOGGER.error(f"Exception caught: {exc}")
        return 1


if __name__ == "__main__":
    sys.exit(main())

# vim: set ft=python et ts=4 sw=4 :
