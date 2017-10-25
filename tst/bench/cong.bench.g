filename := "output.csv";
max_size := 500;
nrpairs := 1;

repeat
  S := RandomSemigroup(IsTransformationSemigroup, 3, 6);
until Size(S) < max_size;
Elements(S);
Print("Size of S: ", Size(S), "\n");

pairs := List([1 .. nrpairs], i -> [Random(S), Random(S)]);
Print("Number of pairs: ", Size(pairs), "\n");

Print("\n");

method_names := ["tc", "tc_prefill", "kbfp", "p", "default"];
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
  end_time := IO_gettimeofday();
  time_taken := 10 ^ 6 * (end_time.tv_sec - start_time.tv_sec) +
                (end_time.tv_usec - start_time.tv_usec);
#  time_taken := Int(Round(Float(time_taken / 1000)));
  Print(" ", time_taken, " us\n");
  times[method] := time_taken;
od;

Print("\n");

Print("Number of classes: ");
if Size(Set(nrclasses)) = 1 then
  Print(nrclasses[1], "\n");
else
  ErrorNoReturn("number of classes differs: ", nrclasses);
fi;

out_list := Concatenation([Size(S), nrclasses[1]], times);
out_str := Concatenation(List(out_list, n -> Concatenation(String(n), ",")));
Remove(out_str);
Append(out_str, "\n");
FileString(filename, out_str, true);
