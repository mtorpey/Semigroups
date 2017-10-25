# Commands to run:
# Read("tst/bench/cong.bench.g"); do_benchmarks(30);
# less output.csv

filename := "output.csv";
max_size := 500;
nrpairs := 1;
method_names := ["tc", "tc_prefill", "kbfp", "p", "default"];

random_benchmark := function(filename, max_size, nrpairs)
  local S, pairs, max_name_len, nrclasses, times, method, cong, i, start_time,
        fin_time, time_taken, out_list, out_str;
  repeat
    S := RandomSemigroup(IsTransformationSemigroup, 3, 6);
  until Size(S) < max_size;
  Elements(S);
  Print("\n");
  Print("Size of S: ", Size(S), "\n");

  pairs := List([1 .. nrpairs], i -> [Random(S), Random(S)]);
  Print("Number of pairs: ", Size(pairs), "\n");

  max_name_len := Maximum(List(method_names, Length));
  nrclasses := [];
  times := EmptyPlist(Length(method_names));
  for method in [1 .. 5] do
    cong := SemigroupCongruence(S, pairs);
    CONG_PAIRS_FORCE(cong, method);
    Print(method_names[method], " ...");
    for i in [1 .. max_name_len - Length(method_names[method])] do
      Print(".");
    od;
    start_time := IO_gettimeofday();
    Add(nrclasses, NrEquivalenceClasses(cong));
    fin_time := IO_gettimeofday();
    time_taken := 10 ^ 6 * (fin_time.tv_sec - start_time.tv_sec) +
                  (fin_time.tv_usec - start_time.tv_usec);
    #  time_taken := Int(Round(Float(time_taken / 1000)));
    Print(" ", time_taken, " us\n");
    times[method] := time_taken;
  od;

  Print("Number of classes: ");
  if Size(Set(nrclasses)) = 1 then
    Print(nrclasses[1], "\n");
  else
    ErrorNoReturn("number of classes differs: ", nrclasses);
  fi;

  out_list := Concatenation([Size(S), nrpairs, nrclasses[1]], times);
  out_str := Concatenation(List(out_list, n -> Concatenation(String(n), ",")));
  Remove(out_str);
  Append(out_str, "\n");
  FileString(filename, out_str, true);
end;

random_benchmark_repeat := function(nr_iterations, filename, max_size, nrpairs)
  local i;
  for i in [1 .. nr_iterations] do
    random_benchmark(filename, max_size, nrpairs);
  od;
end;

do_benchmarks := function(nr_iterations)
  local out_str;
  out_str := "Size(S),nrpairs,nrclasses,";
  Append(out_str, Concatenation(List(method_names, name -> Concatenation(name, ","))));
  Remove(out_str);
  Append(out_str, "\n");
  FileString(filename, out_str);
  random_benchmark_repeat(nr_iterations, filename, max_size, nrpairs);
end;
