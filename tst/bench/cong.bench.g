# Commands to run:
# Read("tst/bench/cong.bench.g"); do_benchmarks(30);
# less output.csv

output_file := Concatenation(SEMIGROUPS.PackageDir, "/tst/bench/output.csv");
input_file := Concatenation(SEMIGROUPS.PackageDir, "/tst/bench/random_tests.g");
max_size := 10000;
nrpairs := 1;
nrtestpairs := 3;
method_names := ["tc", "tc_prefill", "kbfp", "p", "default"];

random_benchmark := function(input_file, output_file, max_size, nrpairs)
  local S, pairs, test_pairs, i, input, max_name_len, results, times, method, 
        cong, start_time, fin_time, time_taken, out_list, out_str;
  repeat
    S := RandomSemigroup(IsTransformationSemigroup, 2, 6);
  until Size(S) < max_size;
  Elements(S);
  Print("\n");
  Print("Size of S: ", Size(S), "\n");

  pairs := List([1 .. nrpairs], i -> [Random(S), Random(S)]);
  Print("Number of pairs: ", Size(pairs), "\n");
  test_pairs := EmptyPlist(nrtestpairs);
  for i in [1 .. nrtestpairs] do
    test_pairs[i] := [Random(S), Random(S)];
  od;
  
  # Write these things to the input file for reading later
  input := [S, pairs, test_pairs];
  input := Concatenation(StripLineBreakCharacters(PrintString(input)), "\n");
  FileString(input_file, input, true);

  max_name_len := Maximum(List(method_names, Length));
  results := [];
  times := EmptyPlist(Length(method_names));
  for method in [1 .. 5] do
    cong := SemigroupCongruenceByGeneratingPairs(S, pairs);
    CONG_PAIRS_FORCE(cong, method);
    Print(method_names[method], " ...");
    for i in [1 .. max_name_len - Length(method_names[method])] do
      Print(".");
    od;
    start_time := IO_gettimeofday();
    results[method] := EmptyPlist(nrtestpairs);
    for i in [1 .. nrtestpairs] do
      Add(results[method], test_pairs[i] in cong);
    od;
    fin_time := IO_gettimeofday();
    time_taken := 10 ^ 6 * (fin_time.tv_sec - start_time.tv_sec) +
                  (fin_time.tv_usec - start_time.tv_usec);
    time_taken := Float(time_taken) / 1000;
    Print(" ", time_taken, " ms\n");
    times[method] := time_taken;
  od;

  Print("Results: ");
  if Size(Set(results)) = 1 then
    Print(results[1], "\n");
  else
    ErrorNoReturn("results differ: ", results);
  fi;

  out_list := Concatenation([Size(S), nrpairs, NrEquivalenceClasses(cong)], times);
  out_str := Concatenation(List(out_list, n -> Concatenation(String(n), ",")));
  Remove(out_str);
  Append(out_str, "\n");
  FileString(output_file, out_str, true);
end;

random_benchmark_repeat := function(nr_iterations, input_file, output_file, max_size, nrpairs)
  local i;
  for i in [1 .. nr_iterations] do
    Print("\nExample ", i, " of ", nr_iterations, ":\n");
    random_benchmark(input_file, output_file, max_size, nrpairs);
  od;
end;

do_benchmarks := function(nr_iterations)
  local out_str;
  out_str := "Size(S),nrpairs,nrclasses,";
  Append(out_str, Concatenation(List(method_names, name -> Concatenation(name, ","))));
  Remove(out_str);
  Append(out_str, "\n");
  FileString(output_file, out_str);
  FileString(input_file, "S, pairs, testpairs\n");
  random_benchmark_repeat(nr_iterations, input_file, output_file, max_size, nrpairs);
end;
