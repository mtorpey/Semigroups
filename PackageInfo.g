############################################################################
##
#W  PackageInfo.g
#Y  Copyright (C) 2011-13                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

RecogsFunnyNameFormatterFunction := function(st)
  if Length(st) = 0 then 
      return st;
  else
      return Concatenation(" (",st,")");
  fi;
end;

RecogsFunnyWWWURLFunction := function(re)
  if IsBound(re.WWWHome) then
      return re.WWWHome;
  else
      return "";
  fi;
end;

##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "2.0">
##  <!ENTITY GAPVERS "4.7.3">
##  <!ENTITY ORBVERS "4.7">
##  <!ENTITY IOVERS "4.3">
##  <!ENTITY GRAPEVERS "4.5">
##  <!ENTITY GENSSVERS "1.5">
##  <!ENTITY ARCHIVENAME "semigroups-2.0">
##  <!ENTITY COPYRIGHTYEARS "2011-14">
##  <#/GAPDoc>

SetPackageInfo( rec(
PackageName := "Semigroups",
Subtitle := "Methods for Semigroups",
Version := "2.0",
Date := "??",
ArchiveURL := "http://tinyurl.com/jdmitchell/semigroups/semigroups-2.0",
ArchiveFormats := ".tar.gz",
Persons := [
  rec( 
    LastName      := "Mitchell",
    FirstNames    := "J. D.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "jdm3@st-and.ac.uk",
    WWWHome       := "tinyurl.com/jdmitchell",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,", 
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
  ),
  
  rec( 
    LastName      := "East",
    FirstNames    := "J.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "",
    WWWHome       := "http://www.maths.usyd.edu.au/u/jamese/",
    Place         := "Sydney",
    Institution   := "University of Western Sydney"
  ),
  
  rec(
    LastName      := "Egri-Nagy",
    FirstNames    := "Attila",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "attila@egri-nagy.hu",
    WWWHome       := "http://www.egri-nagy.hu",
    PostalAddress := Concatenation( [
                       "University of Hertfordshire\n",
                       "STRI\n",
                       "College Lane\n",
                       "AL10 9AB\n",
                       "United Kingdom" ] ),
    Place         := "Hatfield, Herts",
    Institution   := "UH"
  ),
  rec( 
    LastName      := "Jonusas",
    FirstNames    := "J.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "jj252@st-and.ac.uk",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,", 
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
  ),

  rec( 
    LastName      := "Steinberg",
    FirstNames    := "B.",
    IsAuthor      := true,
    IsMaintainer  := false,
    WWWHome       := "http://www.sci.ccny.cuny.edu/~benjamin/",
  ),
  
  rec( 
    LastName      := "Smith",
    FirstNames    := "J.",
    IsAuthor      := true,
    IsMaintainer  := false,
    WWWHome       := "http://math.sci.ccny.cuny.edu/people?name=Jhevon_Smith",
  ),

  rec( 
    LastName      := "Torpey",
    FirstNames    := "M.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "mct25@st-and.ac.uk",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,", 
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
  ),
  
  rec( 
    LastName      := "Wilson",
    FirstNames    := "W.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "waw7@st-and.ac.uk",
    WWWHome       := "http://wilf-wilson.net",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,", 
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
  )],

Status := "deposited",

README_URL := 
  "http://www-groups.mcs.st-andrews.ac.uk/~jamesm/semigroups/README",
PackageInfoURL := 
  "http://www-groups.mcs.st-andrews.ac.uk/~jamesm/semigroups/PackageInfo.g",

AbstractHTML := Concatenation(
   "<p>The Semigroups package is a GAP package containing methods for",
   " semigroups (principally semigroups of of transformations, partial",
   " permutations or subsemigroups of regular Rees 0-matrix semigroups). ",
   "Semigroups contains more efficient methods than those available in the ",
   "GAP library (and in many cases more efficient than any other software)",
   "for creating semigroups, calculating their Green's classes, size,",
   "elements, ",
   "group of units, minimal ideal, small generating sets, testing membership, ",
   "finding the inverses of a regular element, factorizing elements over the ",
   "generators, and many more. It is also possible to test if a semigroup ",
   "satisfies a particular property, such as if it is regular, simple, ",
   "inverse, completely regular, and a variety of further properties.</p>",
   "<p>There are also functions to define and manipulate free inverse", 
   "semigroups and their elements.<p/>"),

PackageWWWHome := "http://www-groups.mcs.st-andrews.ac.uk/~jamesm/semigroups.php",
               
PackageDoc := rec(
  BookName  := "Semigroups",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",  
  SixFile   := "doc/manual.six",
  LongTitle := "Semigroups - Methods for semigroups",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.7.3",
  NeededOtherPackages := [["orb", ">=4.7"], ["io", ">=4.3"]],
  SuggestedOtherPackages := [["gapdoc", ">=1.5.1"], ["grape", ">=4.5"],
  ["genss", ">=1.5"]], 
  ExternalConditions := []),

  BannerString := Concatenation(
  "----------------------------------------------------------------------",
  "-------\n",
  "Loading  Semigroups ", ~.Version, " - methods for semigroups\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
        " (", ~.Persons[1].WWWHome, ")\n",
  "with contributions by:\n",
  Concatenation(Concatenation(List(~.Persons{[2..Length(~.Persons)-1]},
       p->["     ",p.FirstNames," ",p.LastName,
       RecogsFunnyNameFormatterFunction(
         RecogsFunnyWWWURLFunction(p)),",\n"]))),
  " and ",~.Persons[Length(~.Persons)].FirstNames," ",
  ~.Persons[Length(~.Persons)].LastName,
  RecogsFunnyNameFormatterFunction(
    RecogsFunnyWWWURLFunction(~.Persons[Length(~.Persons)])),".\n",
  "-----------------------------------------------------------------------",
  "------\n"
),

  AvailabilityTest := ReturnTrue, 
  Autoload := false,
  TestFile := "tst/testinstall.tst",
  Keywords := ["transformation semigroups", "partial permutations",
  "inverse semigroups", "Green's relations", "free inverse semigroup", 
  "partition monoid", "bipartitions", "Rees matrix semigroups"]
));
