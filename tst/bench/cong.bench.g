S := RandomSemigroup(IsTransformationSemigroup, 2, 5);
Print("Size of S: ", Size(S), "\n");

pairs := [[Random(S), Random(S)]];
Print("Number of pairs: ", Size(pairs), "\n");

method_names := ["tc", "tc_prefill", "kbfp", "p"];
for method in [1 .. 4] do
  cong := SemigroupCongruence(S, pairs);
  CONG_PAIRS_FORCE(cong, method);
  Print("Running ", method_names[method], "...\n");
  nrclasses := NrEquivalenceClasses(cong);
  Print("\n");
od;
