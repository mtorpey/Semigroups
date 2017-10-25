S := RandomSemigroup(IsTransformationSemigroup, 3, 7);
Print("Size of S: ", Size(S), "\n");

pairs := [[Random(S), Random(S)]];
Print("Number of pairs: ", Size(pairs), "\n");

method_names := ["tc", "tc_prefill", "kbfp", "p"];
nrclasses := [];
for method in [1 .. 4] do
  cong := SemigroupCongruence(S, pairs);
  CONG_PAIRS_FORCE(cong, method);
  Print("Running ", method_names[method], " . . . ");
  start_time := IO_gettimeofday();
  Add(nrclasses, NrEquivalenceClasses(cong));
  end_time := IO_gettimeofday();
  time_taken := 10 ^ 6 * (end_time.tv_sec - start_time.tv_sec) +
                (end_time.tv_usec - start_time.tv_usec);
  time_taken := Int(Round(Float(time_taken / 1000)));
  Print(time_taken, " ms\n");
od;

Print("\n");
Print("Size of S: ", Size(S), "\n");
Print("Number of classes: ");
if Size(Set(nrclasses)) = 1 then
  Print(nrclasses[1], "\n");
else
  Print(nrclasses, "\n");
fi;
