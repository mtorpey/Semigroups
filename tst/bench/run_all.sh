#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

echo "Read(\"cong.bench.g\"); write_tests(20); quit;" | gap
echo "Read(\"cong.bench.g\"); do_benchmarks(); quit;" | gap
./make_plots
