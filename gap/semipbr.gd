############################################################################
##
#W  semipbr.gd
#Y  Copyright (C) 2015                                   James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################

# This file contains declarations for semigroups of PBRs.

DeclareSynonym("IsPartitionedBinaryRelationSemigroup", 
               IsSemigroup and IsPartitionedBinaryRelationCollection);
DeclareSynonym("IsPBRSemigroup", 
               IsPartitionedBinaryRelationSemigroup);
InstallTrueMethod(IsFinite, IsPartitionedBinaryRelationSemigroup);
DeclareAttribute("DegreeOfPartitionedBinaryRelationSemigroup",
                 IsPartitionedBinaryRelationSemigroup);
DeclareAttribute("IsomorphismPBRSemigroup", IsSemigroup);
DeclareAttribute("AsPBRSemigroup", IsSemigroup);
