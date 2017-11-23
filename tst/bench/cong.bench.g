# Options
fp_test := false;
nrpairs := 3;
nr_iterations := 10;
max_size := 1000;

if IsBound(SEMIGROUPS) then
SEMIGROUPS.DefaultOptionsRec.report := false;
SetInfoLevel(InfoSemigroups, 1);
fi;

output_file := Concatenation(GAP_ROOT_PATHS[Length(GAP_ROOT_PATHS)], "pkg/semigroups/tst/bench/output.csv");
input_file := Concatenation(GAP_ROOT_PATHS[Length(GAP_ROOT_PATHS)], "pkg/semigroups/tst/bench/random_tests.txt");
nrgens := 3;
nrtestpairs := 3;

# global variables for EvalString use
F := fail;
S := fail;

method_names := ["tc", "tc_prefill", "kbfp", "p", "default"];
if fp_test then
  method_names[4] := "kbp";
fi;

if IsBound(SEMIGROUPS) then
write_trans_test := function(file, max_size, nrpairs)
  local S, pairs, test_pairs, i, input;
  # Write a test case to the end of "file"
  repeat
    S := RandomSemigroup(IsTransformationSemigroup, nrgens, 6);
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

write_fp_test := function(file, max_size, nrpairs)
  local S, pairs, test_pairs, i, input;
  # Write a test case to the end of "file"
  repeat
    S := RandomSemigroup(IsFpSemigroup, nrgens, 6);
  until Size(S) < max_size;

  pairs := List([1 .. nrpairs], i -> [Random(S), Random(S)]);
  test_pairs := EmptyPlist(nrtestpairs);
  for i in [1 .. nrtestpairs] do
    test_pairs[i] := [Random(S), Random(S)];
  od;

  # Write these things to the input file for reading later
  input := [];
  Add(input, String(Size(FreeGeneratorsOfFpSemigroup(S))));
  Add(input, ReplacedString(PrintString(RelationsOfFpSemigroup(S)), "s", "F."));
  Add(input, ReplacedString(PrintString(pairs), "s", "S."));
  Add(input, ReplacedString(PrintString(test_pairs), "s", "S."));
  input := List(input, str -> Concatenation(StripLineBreakCharacters(str), ";"));
  input := Concatenation(input);
  Remove(input);
  Append(input, "\n");
  FileString(file, input, true);
end;

write_tests := function()
  local i;
  if fp_test then
    FileString(input_file, "nrgens;rels (in F);pairs (in S);testpairs(in S)\n");
  else
    FileString(input_file, "S, pairs, testpairs\n");
  fi;
  for i in [1 .. nr_iterations] do
    if fp_test then
      write_fp_test(input_file, max_size, nrpairs);
    else
      write_trans_test(input_file, max_size, nrpairs);
    fi;
  od;
end;
fi;

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

if IsBound(SEMIGROUPS) then
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
#   ErrorNoReturn("results differ: ", results);
  fi;

  out_list := Concatenation([Size(S), nrpairs, NrEquivalenceClasses(cong)], times);
  out_str := Concatenation(List(out_list, n -> Concatenation(String(n), ",")));
  Remove(out_str);
  Append(out_str, "\n");
  FileString(output_file, out_str, true);
end;
fi;

gap_tests_output := function(S, pairs, test_pairs)
  local max_name_len, results, times, method, cong, i, t, time, out_list,
        out_str;
  Elements(S);
  Print("\n");
  Print("Size of S: ", Size(S), "\n");

  cong := SemigroupCongruenceByGeneratingPairs(S, pairs);
  time := time_test(test_pairs, cong)[2];
  Print("Time taken: ", time, " ms\n");

  out_str := Concatenation(",", String(time), "\n");
  return out_str;
end;

EvalFpTestLine := function(line)
  local strings, pairs, test_pairs;
  strings := SplitString(line, ';');
  F := FreeSemigroup(EvalString(strings[1]));
  S := F / EvalString(strings[2]);
  pairs := EvalString(strings[3]);
  test_pairs := EvalString(strings[4]);
  return [S, pairs, test_pairs];
end;

do_gap_benchmarks := function()
  local in_str, tests, out_lines, i;
  # Get tests from input file
  in_str := SplitString(StringFile(input_file), '\n');;
  Remove(in_str, 1);;
  if fp_test then
    tests := List(in_str, EvalFpTestLine);
  else
    tests := List(in_str, EvalString);
  fi;

  # Read the existing output file
  out_lines := SplitString(StringFile(output_file), '\n');
  # Write the header line, overwriting the file
  FileString(output_file, out_lines[1]);
  FileString(output_file, ",GAP\n", true);

  Remove(out_lines, 1);
  for i in [1 .. Length(out_lines)] do
    # Write the original line
    FileString(output_file, out_lines[i], true);
    # Add the extra test
    FileString(output_file, gap_tests_output(tests[i][1], tests[i][2], tests[i][3]), true);
  od;
end;

if IsBound(SEMIGROUPS) then
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
  if fp_test then
    tests := List(in_str, EvalFpTestLine);
  else
    tests := List(in_str, EvalString);
  fi;

  # Execute tests
  i := 0;
  for test in tests do
    i := i + 1;
    Print("\nTest #", i, ":");
    run_semigroups_tests(test[1], test[2], test[3], output_file);
  od;
end;
fi;
