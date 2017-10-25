max_size := 3000;
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
  time_taken := Int(Round(Float(time_taken / 1000)));
  Print(" ", time_taken, " ms\n");
od;

Print("\n");

Print("Number of classes: ");
if Size(Set(nrclasses)) = 1 then
  Print(nrclasses[1], "\n");
else
  Print(nrclasses, "\n");
fi;
