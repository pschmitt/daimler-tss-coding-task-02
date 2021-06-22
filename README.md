# Merge intervals

## Exercice Instructions

https://docs.google.com/document/d/1FS272sy-boGQ49TBFKirIbn5YLasZi1XcyAq5NZ2uBI/edit#

# Installation

## Quick and dirty, using Python

Requirements: Python 3

### Usage example

```shell
./interval_merge.py "[25,30]" "[2,19]" "[14, 23]" "[4,8]"
```

## Container

```shell
docker run -it --rm pschmitt/interval-merge:latest -h
```

### Usage example

```shell
docker run -it --rm pschmitt/interval-merge "[25,30]" "[2,19]" "[14, 23]" "[4,8]"
```

## Performance and benchmarks

🚧 WIP. See [./benchmark.sh](./benchmark.sh)

# Similar work

- https://codereview.stackexchange.com/q/69242
