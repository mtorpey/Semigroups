# Commands to run:
# Read("tst/bench/cong.bench.g"); do_benchmarks(30);
# less output.csv

output_file := Concatenation(GAP_ROOT_PATHS[2], "pkg/semigroups/tst/bench/output.csv");
input_file := Concatenation(GAP_ROOT_PATHS[2], "pkg/semigroups/tst/bench/random_tests.txt");
max_size := 10000;
nrpairs := 1;
nrtestpairs := 3;
method_names := ["tc", "tc_prefill", "kbfp", "p", "default"];

write_test := function(file, max_size, nrpairs)
  local S, pairs, test_pairs, i, input;
  # Write a test case to the end of "file"
  repeat
    S := RandomSemigroup(IsTransformationSemigroup, 3, 6);
  until Size(S) < max_size;

  pairs := List([1 .. nrpairs], i -> [Random(S), Random(S)]);
  test_pairs := EmptyPlist(nrtestpairs);
  for i in [1 .. nrtestpairs] do
    test_pairs[i] := [Random(S), Random(S)];
  od;
  
  # Write these things to the input file for reading later
  input := [S, pairs, test_pairs];
  input := Concatenation(StripLineBreakCharacters(PrintString(input)), "\n");
  FileString(file, input, true);
end;

write_tests := function(nr_iterations)
  local i;
  FileString(input_file, "S, pairs, testpairs\n");
  for i in [1 .. nr_iterations] do
    write_test(input_file, max_size, nrpairs);
  od;
end;

time_test := function(test_pairs, cong)
  local start_time, results, i, fin_time, time_taken;
  start_time := IO_gettimeofday();
  results := EmptyPlist(nrtestpairs);
  for i in [1 .. nrtestpairs] do
    Add(results, test_pairs[i][1] in
                 EquivalenceClassOfElement(cong, test_pairs[i][2]));
  od;
  fin_time := IO_gettimeofday();
  time_taken := 10 ^ 6 * (fin_time.tv_sec - start_time.tv_sec) +
                (fin_time.tv_usec - start_time.tv_usec);
  time_taken := Float(time_taken) / 1000;
  return [results, time_taken];
end;

run_semigroups_tests := function(S, pairs, test_pairs, output_file)
  local max_name_len, results, times, method, cong, i, t, time, out_list, 
        out_str;
  Elements(S);
  Print("\n");
  Print("Size of S: ", Size(S), "\n");
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
    t := time_test(test_pairs, cong);
    results[method] := t[1];
    time := t[2];
    Print(" ", time, " ms\n");
    times[method] := time;
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

do_benchmarks := function()
  local out_str, in_str, tests, i, test;
  # Header
  out_str := "Size(S),nrpairs,nrclasses,";
  Append(out_str, Concatenation(List(method_names, name -> Concatenation(name, ","))));
  Remove(out_str);
  Append(out_str, "\n");
  FileString(output_file, out_str);
  
  # Get tests from input file
  in_str := SplitString(StringFile(input_file), '\n');;
  Remove(in_str, 1);;
  tests := List(in_str, EvalString);
  
  # Execute tests
  i := 0;
  for test in tests do
    i := i + 1;
    Print("Test #", i, ":\n");
    run_semigroups_tests(test[1], test[2], test[3], output_file);
  od;
end;
