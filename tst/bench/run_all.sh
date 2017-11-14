#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

echo "Read(\"cong.bench.g\"); write_tests(5000); quit;" | gap
echo "Read(\"cong.bench.g\"); do_benchmarks(); quit;" | gap
echo "Read(\"cong.bench.g\"); do_gap_benchmarks(); quit;" | gap -r
./make_plots
