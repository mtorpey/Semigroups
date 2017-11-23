#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

echo "Read(\"cong.bench.g\"); write_tests(); quit;" | gap
echo "Read(\"cong.bench.g\"); do_benchmarks(); quit;" | gap
echo "LoadPackage(\"io\"); LoadPackage(\"kbmag\"); Read(\"cong.bench.g\"); do_gap_benchmarks(); quit;" | gap -A
./make_plots
