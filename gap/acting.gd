############################################################################
##
#W  acting.gd
#Y  Copyright (C) 2013-15                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

DeclareCategory("IsSemigroupData", IsList);
DeclareFilter("IsClosedData", IsSemigroupData);

DeclareCategory("IsActingSemigroup", IsSemigroup and IsFinite, 8);
# so that the rank of IsActingSemigroup is higher than that of
# IsSemigroup and IsFinite and HasGeneratorsOfSemigroup, and
# IsSemigroupIdeal and IsFinite and HasGeneratorsOfSemigroupIdeal

DeclareAttribute("SemigroupData", IsActingSemigroup, "mutable");
DeclareAttribute("SizeOfSemigroupData", IsSemigroupData);
DeclareProperty("IsGeneratorsOfActingSemigroup", IsAssociativeElementCollection);
DeclareProperty("IsActingSemigroupWithFixedDegreeMultiplication",
                IsActingSemigroup);

DeclareOperation("Enumerate", [IsSemigroupData]);
DeclareOperation("Enumerate", [IsSemigroupData, IsCyclotomic]);
DeclareOperation("Enumerate", [IsSemigroupData, IsCyclotomic, IsFunction]);
DeclareOperation("OrbitGraphAsSets", [IsSemigroupData]);
DeclareOperation("OrbitGraph", [IsSemigroupData]);
DeclareOperation("PositionOfFound", [IsSemigroupData]);

# these must be here since UniversalFakeOne is used in lots of other places

DeclareCategory("IsUniversalFakeOne", IsAssociativeElement);

BindGlobal("UniversalFakeOneFamily",
  NewFamily("UniversalFakeOneFamily", IsUniversalFakeOne,
   CanEasilyCompareElements, CanEasilyCompareElements));

BindGlobal("UniversalFakeOne",
Objectify(NewType(UniversalFakeOneFamily, IsUniversalFakeOne), rec()));
