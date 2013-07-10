############################################################################
##
#W  bipartition.gi
#Y  Copyright (C) 2011-13                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

BindGlobal("BipartitionFamily", NewFamily("BipartitionFamily",
 IsBipartition, CanEasilySortElements, CanEasilySortElements));

BindGlobal("BipartitionType", NewType(BipartitionFamily,
 IsBipartition and IsComponentObjectRep and IsAttributeStoringRep and
 IsAssociativeElementWithAction));

#

InstallMethod(\<, "for a bipartition and bipartition", 
[IsBipartition, IsBipartition],
function(f, g)
  return f!.blocks<g!.blocks;
end);

#

InstallMethod(\=, "for a bipartition and bipartition", 
[IsBipartition, IsBipartition],
function(f, g)
  return f!.blocks=g!.blocks;
end);

#

InstallMethod(AsTransformation, "for a bipartition", [IsBipartition],
function(f)

  if not IsTransBipartition(f) then 
    Error("<f> does not define a transformation,");
    return;
  fi;
  return AsTransformationNC(f);
end);

# test me! JDM

InstallMethod(AsTransformationNC, "for a bipartition", [IsBipartition],
function(f)
  local n, blocks, nr, im, out, i;

  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  nr:=NrLeftBlocks(f);
  im:=EmptyPlist(n);

  for i in [n+1..2*n] do 
    if blocks[i]<=nr then 
      im[blocks[i]]:=i-n;
    fi;
  od;

  out:=EmptyPlist(n);
  for i in [1..n] do 
    out[i]:=im[blocks[i]];
  od;
  return TransformationNC(out);
end);

# a bipartition is a transformation if and only if the second row is a
# permutation of [1..n]

InstallMethod(IsTransBipartition, "for a bipartition",
[IsBipartition], 
function(f)
  local n, blocks, seen, i;

  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  seen:=BlistList([1..n], []);
  for i in [n+1..2*n] do 
    if blocks[i]>n or seen[blocks[i]] then 
      return false;
    fi;
    seen[blocks[i]]:=true;
  od;

  return true;
end);

#

InstallMethod(IsPermBipartition, "for a bipartition",
[IsBipartition], 
function(f)
  local n, blocks, seen, i;

  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;

  seen:=BlistList([1..n], []);
  for i in [1..n] do 
    if seen[blocks[i]] then 
      return false;
    fi;
    seen[blocks[i]]:=true;
  od;

  seen:=BlistList([1..n], []);
  for i in [n+1..2*n] do 
    if blocks[i]>n or seen[blocks[i]] then 
      return false;
    fi;
    seen[blocks[i]]:=true;
  od;

  return true;
end);

#

InstallMethod(AsBipartition, "for a permutation and pos int",
[IsPerm, IsPosInt],
function(f, n)
  return BipartitionByIntRepNC(Concatenation([1..n], ListPerm(f^-1, n)));
end);

#

InstallMethod(AsBipartition, "for a partial perm and pos int",
[IsPartialPerm, IsPosInt],
function(f, n)
  local out, g, r, i;

  g:=f^-1;
  r:=n;
  out:=EmptyPlist(2*n);

  for i in [1..n] do 
    out[i]:=i;
    if i^g<>0 then 
      out[n+i]:=i^g;
    else 
      r:=r+1;
      out[n+i]:=r;
    fi;
  od;
  return BipartitionByIntRepNC(out); 
end);

#

InstallMethod(AsBipartition, "for a transformation",
[IsTransformation],
function(f)
  local n, r, ker, out, g, i;

  n:=DegreeOfTransformation(f);
  r:=RankOfTransformation(f);;
  ker:=FlatKernelOfTransformation(f); 
  out:=ShallowCopy(ker);
  g:=List([1..n], x-> 0);

  #inverse of f
  for i in [1..n] do 
    g[i^f]:=i;
  od;

  for i in [1..n] do 
    if g[i]<>0 then 
      out[n+i]:=ker[g[i]];
    else 
      r:=r+1;
      out[n+i]:=r;
    fi;
  od;
  return BipartitionByIntRepNC(out);
end);

#

InstallMethod(BipartitionByIntRepNC, "for a list", [IsList],
function(blocks)
  local n, next, seen, nrleft, out, i;

  n:=Length(blocks)/2;
  next:=0;
  seen:=BlistList([1..2*n], []);

  for i in [1..n] do 
    if not seen[blocks[i]] then 
      next:=next+1;
      seen[blocks[i]]:=true;
    fi;
  od;
  
  nrleft:=next;
  for i in [n+1..2*n] do 
    if not seen[blocks[i]] then 
      next:=next+1;
      seen[blocks[i]]:=true;
    fi;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=blocks));

  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, nrleft);
  SetNrBlocks(out, next);
  return out;
end);

#

InstallMethod(BipartitionByIntRep, "for a list", [IsList],
function(blocks)
  local n, next, seen, nrleft, out, i;

  n:=Length(blocks);
  if not IsEvenInt(n) then 
    Error("the length of <blocks> must be an even integer,");
    return;
  fi;
  
  n:=n/2;
  if not ForAll(blocks, IsPosInt) then 
    Error("the elements of <blocks> must be positive integers,");
    return;
  fi;

  next:=0;
  seen:=BlistList([1..2*n], []);

  for i in [1..n] do 
    if not seen[blocks[i]] then 
      next:=next+1;
      if blocks[i]<>next then 
        Error("expected ", next, " but found ", blocks[i], ",");
        return;
      fi;
      seen[blocks[i]]:=true;
    fi;
  od;
  
  nrleft:=next;

  for i in [n+1..2*n] do 
    if not seen[blocks[i]] then 
      next:=next+1;
      if blocks[i]<>next then 
        Error("expected ", next, " but found ", blocks[i], ",");
        return;
      fi;
      seen[blocks[i]]:=true;
    fi;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=blocks));

  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, nrleft);
  SetNrBlocks(out, next);
  return out;
end);

# fuse <blocks> with <f>. <sign> should be true to keep track of signed and
# unsigned blocks and false not to keep track.

FuseRightBlocks:=function(blocks, f, sign)
  local n, fblocks, nrblocks, nrfblocks, fuse, fuseit, x, y, i;
  
  n:=DegreeOfBlocks(blocks);
  fblocks:=f!.blocks;
  nrblocks:=blocks[1];
  nrfblocks:=NrBlocks(f);

  fuse:=[1..nrblocks+nrfblocks];
  fuseit := function(i) 
    while fuse[i] < i do 
      i := fuse[i]; 
    od; 
    return i; 
  end;
  
  if sign then 
    sign:=EmptyPlist(nrfblocks+nrblocks);

    for i in [1..nrblocks] do
      sign[i]:=blocks[n+1+i];
    od;
    for i in [nrblocks+1..nrfblocks+nrblocks] do
      sign[i]:=0;
    od;
    
    for i in [1..n] do
      x := fuseit(blocks[i+1]);
      y := fuseit(fblocks[i]+nrblocks);
      if x <> y then
        if x < y then
          fuse[y] := x;
          if sign[y]=1 then
            sign[x]:=1;
          fi;
        else
          fuse[x] := y;
          if sign[x]=1 then
            sign[y]:=1;
          fi;
        fi;
      fi;
    od;
    return [fuseit, sign];
  else 
    for i in [1..n] do
      x := fuseit(blocks[i+1]);
      y := fuseit(fblocks[i]+nrblocks);
      if x <> y then
        if x < y then
          fuse[y] := x;
        else
          fuse[x] := y;
        fi;
      fi;
    od;
    return fuseit;
  fi;
end;

# LambdaPerm

PermLeftQuoBipartitionNC:=function(f,g)
  local n, nr, fblocks, gblocks, p, i;

  n:=DegreeOfBipartition(f);
  nr:=NrLeftBlocks(f);
  fblocks:=f!.blocks;
  gblocks:=g!.blocks;
  p:=[1..nr];

  for i in [n+1..2*n] do 
    if gblocks[i]<=nr then 
      p[gblocks[i]]:=fblocks[i];
    fi;
  od;

  return PermList(p);
end;

# LambdaConjugator: f and g have equal left blocks (rho value)
# JDM: this will be better in c...

BipartRightBlocksConj:=function(f, g)
  local n, fblocks, gblocks, nr, lookup, next, seen, src, dst, i;

  n:=DegreeOfBipartition(f);
  fblocks:=f!.blocks;     
  gblocks:=g!.blocks;
  nr:=NrLeftBlocks(f);

  lookup:=[];
  next:=0; 
  seen:=BlistList([1..n], []);
  for i in [n+1..2*n] do 
    if not seen[gblocks[i]] then 
      next:=next+1; 
      seen[gblocks[i]]:=true;
      if gblocks[i]<=nr then #connected block
        lookup[gblocks[i]]:=next;
      fi;
    fi;
  od;
  
  src:=[]; dst:=[];
  next:=0; 
  seen:=BlistList([1..n], []);
  for i in [n+1..2*n] do 
    if not seen[fblocks[i]] then 
      next:=next+1; 
      seen[fblocks[i]]:=true;
      if fblocks[i]<=nr then #connected block
        Add(src, next);
        Add(dst, lookup[fblocks[i]]);
      fi;
    fi;
  od; 

  return MappingPermListList(src, dst);
end;

# permutation of indices of signed (connected) blocks of <blocks> under the
# action of <f> which is assumed to stabilise <blocks>.

PermRightBlocks:=function(blocks, f)
  local n, nrblocks, fblocks, fuseit, signed, tab, next, x, i;

  n:=DegreeOfBlocks(blocks); # length of partition!!
  nrblocks:=blocks[1];
  fblocks:=f!.blocks;

  fuseit:=FuseRightBlocks(blocks, f, false); 
  signed:=[]; tab:=[]; next:=0;

  # JDM could stop here after reaching the maximum signed class of <blocks>
  for i in [n+1..2*n] do 
    if blocks[n+1+blocks[i-n]]=1 then 
      Add(signed, blocks[i-n]);
    fi;
    x:=fuseit(fblocks[i]+nrblocks);
    if not IsBound(tab[x]) then 
      next:=next+1;
      tab[x]:=next;
    fi;
  od;
  
  return MappingPermListList(signed, List(signed, i-> tab[fuseit(i)]));
end;

# LambdaInverse

InverseRightBlocks:=function(blocks, f)
  local n, nrblocks, fblocks, fusesign, fuse, sign, fuseit, out, junk, next, tab1, x, nrleft, tab2, i;

  n:=DegreeOfBlocks(blocks); # length of partition!!
  nrblocks:=blocks[1];
  fblocks:=f!.blocks;
  
  fusesign:=FuseRightBlocks(blocks, f, true); 
  fuseit:=fusesign[1];
  sign:=fusesign[2];

  out:=[]; junk:=0; next:=0;
  
  tab1:=[];
  for i in [1..n] do 
    x:=fuseit(fblocks[i+n]+nrblocks);
    if x>NrLeftBlocks(f) or sign[x]=0 then 
      if junk=0 then 
        next:=next+1;
        junk:=next;
      fi;
      out[i]:=junk;
    else 
      if not IsBound(tab1[x]) then 
        next:=next+1;
        tab1[x]:=next;
      fi;
      out[i]:=tab1[x];
    fi;
  od;
  nrleft:=next;
  
  tab2:=[];
  for i in [n+1..2*n] do 
    x:=blocks[i-n+1];
    if blocks[n+1+x]=1 then 
      x:=fuseit(x);
      out[i]:=tab1[x];
    else
      if not IsBound(tab2[x]) then 
        next:=next+1;
        tab2[x]:=next;
      fi;
      out[i]:=tab2[x];
    fi;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=out));

  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, nrleft);
  SetNrBlocks(out, next);
  return out;
end;

#

InstallOtherMethod(OneMutable, "for a bipartition",
[IsBipartition], x-> IdentityBipartition(DegreeOfBipartition(x)));

InstallMethod(IdentityBipartition, "for a positive integer",
[IsPosInt],
function(n)
  local blocks, out, i;
  
  blocks:=EmptyPlist(2*n);
  for i in [1..n] do 
    blocks[i]:=i;
    blocks[i+n]:=i;
  od;
  
  out:=Objectify(BipartitionType, rec(blocks:=blocks));

  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, n);
  SetNrBlocks(out, n);

  return out;
end);

#

InstallMethod(RankOfBipartition, "for a bipartition",
[IsBipartition],
function(f)
  return Number(TransverseBlocksLookup(f), x-> x=true);
end);

# c function

InstallGlobalFunction(Bipartition, 
function(classes)
  local n, copy, i, j;
 
  if not ForAll(classes, IsList) or not ForAll(classes, IsDuplicateFree) then 
    Error("<classes> must consist of duplicate-free lists,");
    return;
  fi;

  n:=Sum(List(classes, Length))/2;
  
  if not Union(classes)=Concatenation(Set(-1*[1..n]), [1..n]) then
    Error("the union of <classes> must be [-", n, "..-1,1..", n, "],");
    return;
  fi;

  copy:=StructuralCopy(classes);
  
  for i in [1..Length(copy)] do
    for j in [1..Length(copy[i])] do 
      if copy[i][j]<0 then 
        copy[i][j]:=AbsInt(copy[i][j])+n;
      fi;
    od;
  od;
  
  Perform(copy, Sort);
  Sort(copy);

  for i in [1..Length(copy)] do
    for j in [1..Length(copy[i])] do 
      if copy[i][j]>n then 
        copy[i][j]:=-copy[i][j]+n;
      fi;
    od;
  od;
  return BipartitionNC(copy);
end);

InstallGlobalFunction(BipartitionNC, 
function(classes)
  local list, n, nrker, out, i, j;

  list:=[];
  n:=Sum(List(classes, Length))/2;

  for i in [1..Length(classes)] do
    for j in classes[i] do 
      if j<0 then 
        list[AbsInt(j)+n]:=i;
      else 
        nrker:=i;
        list[j]:=i;
      fi;
    od;
  od;
  out:=Objectify(BipartitionType, rec(blocks:=list)); 
  
  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, nrker);
  SetExtRepBipartition(out, classes);
  SetNrBlocks(out, Length(classes));

  return out;
end);

# linear - attribute

# returns a blist <out> for the Left blocks so that <out[i]> is <true> if
# and only the <i>th block of <f> is a transverse block.

InstallGlobalFunction(TransverseBlocksLookup,
function(f)
  local n, k, blocks, out, i;
  
  if IsBound(f!.lookup) then 
    return f!.lookup;
  fi;

  n:=DegreeOfBipartition(f);
  k:=NrLeftBlocks(f);
  blocks:=f!.blocks;
  out:=BlistList([1..k], []);

  for i in [1..n] do 
    if blocks[i+n]<=k then 
      out[blocks[i+n]]:=true;
    fi;
  od;

  f!.lookup:=out;
  return out;
end);

# return the classes of <f> as a list of lists

InstallMethod(ExtRepBipartition, "for a bipartition",
[IsBipartition],
function(f)
  local n, blocks, ext, i;

  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  ext:=[];
  
  for i in [1..2*n] do 
    if not IsBound(ext[blocks[i]]) then 
      ext[blocks[i]]:=[];
    fi;
    if i<=n then 
      Add(ext[blocks[i]], i);
    else
      Add(ext[blocks[i]], -(i-n));
    fi;
  od;

  return ext;
end);

#JDM proper string method!

InstallMethod(PrintObj, "for a bipartition",
[IsBipartition],
function(f)
  local ext, i;

  Print("<bipartition: ");
  ext:=ExtRepBipartition(f);
  Print(ext[1]);
  for i in [2..Length(ext)] do 
    Print(", ", ext[i]);
  od;
  Print(">");
  return;
end);

# xx^* - linear - 2*degree - attribute

InstallMethod(LeftProjection, "for a bipartition", 
[IsBipartition],
function(f)
  local n, k, blocks, lookup, table, out, i;

  n:=DegreeOfBipartition(f);
  k:=NrLeftBlocks(f);
  blocks:=f!.blocks;
  lookup:=TransverseBlocksLookup(f);
  table:=[];
  out:=[];

  for i in [1..n] do 
    out[i]:=blocks[i];
    if lookup[blocks[i]] then 
      out[i+n]:=blocks[i];
    elif IsBound(table[blocks[i]]) then 
      out[i+n]:=table[blocks[i]];
    else 
      k:=k+1;
      table[blocks[i]]:=k;
      out[i+n]:=k;
    fi;
  od;
  out:=Objectify(BipartitionType, rec(blocks:=out));
  
  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, NrLeftBlocks(f));
  SetNrBlocks(out, k);
  #SetRankOfBipartition(out, RankOfBipartition(f));
  return out;
end);

# linear - 2*degree

InstallMethod(InverseOp, "for a bipartition", [IsBipartition],
function(f)
  local n, blocks, table, out, k, nrker, i;

  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  table:=[];
  out:=[];
  k:=0;

  for i in [1..n] do 
    if IsBound(table[blocks[i+n]]) then 
      out[i]:=table[blocks[i+n]];
    else
      k:=k+1;
      table[blocks[i+n]]:=k;
      out[i]:=k;
    fi;
  od;

  nrker:=k;

  for i in [1..n] do 
    if IsBound(table[blocks[i]]) then 
      out[i+n]:=table[blocks[i]];
    else
      k:=k+1;
      table[blocks[i]]:=k;
      out[i+n]:=k;
    fi;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=out));
  
  SetDegreeOfBipartition(out, Length(blocks)/2);
  SetNrLeftBlocks(out, nrker);
  SetNrBlocks(out, k);
  #SetRankOfBipartition(out, RankOfBipartition(f));
  return out;
end);  

# linear - 2*degree 

InstallMethod(RightProjection, "for a bipartition",
[IsBipartition],
function(f)
  local n, blocks, table, out, k, nrker, lookup, i;

  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  table:=[];
  out:=[];
  k:=0;

  for i in [1..n] do 
    if IsBound(table[blocks[i+n]]) then 
      out[i]:=table[blocks[i+n]];
    else
      k:=k+1;
      table[blocks[i+n]]:=k;
      out[i]:=k;
    fi;
  od;

  nrker:=k;
  table:=[];
  lookup:=TransverseBlocksLookup(f);

  for i in [1..n] do 
    if blocks[i+n]<=NrLeftBlocks(f) and lookup[blocks[i+n]] then 
      out[i+n]:=out[i];
    elif IsBound(table[blocks[i+n]]) then 
      out[i+n]:=table[blocks[i+n]];
    else
      k:=k+1;
      table[blocks[i+n]]:=k;
      out[i+n]:=k;
    fi;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=out));
  
  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, nrker);
  SetNrBlocks(out, k);
  return out;
end);

#

InstallMethod(RandomBipartition, "for a pos int",
[IsPosInt],
function(n)
  local out, nrblocks, vals, j, nrkerblocks, i;

  out:=EmptyPlist(2*n);
  nrblocks:=0;
  vals:=[1];

  for i in [1..n] do 
    j:=Random(vals);
    if j=nrblocks+1 then 
      nrblocks:=nrblocks+1;
      Add(vals, nrblocks+1);
    fi;
    out[i]:=j;
  od;

  nrkerblocks:=nrblocks;

  for i in [1..n] do 
    j:=Random(vals);
    if j=nrblocks+1 then 
      nrblocks:=nrblocks+1;
      Add(vals, nrblocks+1);
    fi;
    out[i+n]:=j;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=out));
  
  SetDegreeOfBipartition(out, n);
  SetNrLeftBlocks(out, nrkerblocks);
  SetNrBlocks(out, nrblocks);

  return out;
end);

#

InstallMethod(RightBlocks, "for a bipartition", [IsBipartition],
function(f)
  local n, blocks, tab, out, nrblocks, i;
  
  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  tab:=EmptyPlist(2*n);
  out:=[];
  nrblocks:=0;

  for i in [n+1..2*n] do 
    if not IsBound(tab[blocks[i]]) then 
      nrblocks:=nrblocks+1;
      tab[blocks[i]]:=nrblocks;
      if blocks[i]<=NrLeftBlocks(f) then 
        out[n+1+nrblocks]:=1; #signed
      else 
        out[n+1+nrblocks]:=0; #unsigned
      fi;
    fi;
    out[i-n+1]:=tab[blocks[i]];
  od;
  out[1]:=nrblocks;
  return out;
end);

# could use TransverseBlocksLookup if known here JDM

InstallMethod(LeftBlocks, "for a bipartition", [IsBipartition],
function(f)
  local n, blocks, tab, out, nrblocks, i;
  
  n:=DegreeOfBipartition(f);
  blocks:=f!.blocks;
  tab:=List([1..n], x-> false);
  out:=EmptyPlist(n+2);
  out[1]:=0;
  out[n+2]:=[];
  nrblocks:=0;

  for i in [1..n] do 
    out[i+1]:=blocks[i];
    if not tab[blocks[i]] then 
      out[1]:=out[1]+1;
      out[n+1+blocks[i]]:=0;
      tab[blocks[i]]:=true;
    fi;
  od;
  
  for i in [n+1..2*n] do 
    if blocks[i]<=out[1] then #transverse block!
      out[n+1+blocks[i]]:=1;
    fi;
  od;

  return out;
end);

# JDM use FuseRightBlocks here!

InstallGlobalFunction(OnRightBlocks, 
function(blocks, f)
  local n, nrblocks, nrfblocks, fblocks, fuse, sign, fuseit, x, y, tab, out,
   next, i;

  n:=DegreeOfBlocks(blocks); # length of partition!!
  nrblocks:=blocks[1];
  
  if nrblocks=0 then   # special case for dummy/seed 
    return RightBlocks(f);
  fi;

  nrfblocks:=NrBlocks(f); 
  fblocks:=f!.blocks;
  
  fuse:=[1..nrblocks+nrfblocks];
  sign:=EmptyPlist(nrfblocks+nrblocks);

  for i in [1..nrblocks] do 
    sign[i]:=blocks[n+1+i];
  od;
  for i in [nrblocks+1..nrfblocks+nrblocks] do 
    sign[i]:=0;
  od;

  fuseit := function(i) 
    while fuse[i] < i do 
      i := fuse[i]; 
    od; 
    return i; 
  end;
  
  for i in [1..n] do
    x := fuseit(blocks[i+1]);
    y := fuseit(fblocks[i]+nrblocks);
    if x <> y then
      if x < y then
        fuse[y] := x;
        if sign[y]=1 then 
          sign[x]:=1;
        fi;
      else
        fuse[x] := y;
        if sign[x]=1 then 
          sign[y]:=1;
        fi;
      fi;
    fi;
  od;

  tab:=0*fuse;
  out:=[];
  next:=0;
  
  for i in [n+1..2*n] do
    x := fuseit(fblocks[i]+nrblocks);
    if tab[x]=0 then
      next:=next+1;
      tab[x]:=next;
    fi;
    out[i-n+1]:=tab[x];
    out[n+1+tab[x]]:=sign[x];
  od;
  out[1]:=next;
  return out;
end);

#

InstallGlobalFunction(OnLeftBlocks, 
function(blocks, f)
  local n, nrblocks, nrfblocks, fblocks, fuse, sign, fuseit, x, y, tab, out, next, i;

  n:=DegreeOfBlocks(blocks);  # length of <blocks>
  nrblocks:=blocks[1];
  
  if nrblocks=0 then 
    return LeftBlocks(f);
  fi;

  nrfblocks:=NrBlocks(f);
  fblocks:=f!.blocks;
  
  fuse:=[1..nrfblocks+nrblocks];
  sign:=EmptyPlist(nrfblocks+nrblocks);

  for i in [1..nrfblocks] do 
    sign[i]:=0;
  od;
  for i in [1..nrblocks] do 
    sign[i+nrfblocks]:=blocks[n+1+i];
  od;

  fuseit := function(i) 
    while fuse[i] < i do 
      i := fuse[i]; 
    od; 
    return i; 
  end;
  
  for i in [1..n] do
    x := fuseit(fblocks[n+i]);
    y := fuseit(blocks[i+1]+nrfblocks);
    if x <> y then
      if x < y then
        fuse[y] := x;
        if sign[y]=1 then 
          sign[x]:=1; 
        fi;
      else
        fuse[x] := y;
        if sign[x]=1 then 
          sign[y]:=1;
        fi;
      fi;
    fi;
  od;

  tab:=0*fuse;
  out:=[];
  next:=0;
  
  for i in [1..n] do
    x := fuseit(fblocks[i]);
    if tab[x]=0 then
      next := next + 1;
      tab[x] := next;
    fi;
    out[i+1]:=tab[x];
    out[n+1+tab[x]]:=sign[x];
  od;
  out[1]:=next;
  return out;
end);

#

InstallGlobalFunction(ExtRepOfBlocks,
function(blocks)
  local n, sign, out, i;
  
  n:=DegreeOfBlocks(blocks);
  out:=EmptyPlist(n);
  for i in [1..n] do 
    out[i]:=blocks[i+1];
    if blocks[n+1+blocks[i+1]]=0 then 
      out[i]:=out[i]*-1;
    fi;
  od;
    
  return out;
end);

#

InstallGlobalFunction(BlocksByExtRep,
function(ext)
  local n, tab, out, nr, i;
  
  n:=Length(ext);
  tab:=EmptyPlist(n);
  out:=EmptyPlist(n+2);
  out[n+2]:=[];
  nr:=0;
  
  for i in [1..n] do
    if ext[i]<0 then 
      out[i+1]:=-1*ext[i];
      out[n+1+out[i+1]]:=0;
    else
      out[i+1]:=ext[i];
      out[n+1+ext[i]]:=1;
    fi;
    if not IsBound(tab[out[i+1]]) then 
      tab[out[i+1]]:=true;
      nr:=nr+1;
    fi;
  od;

  out[1]:=nr;
  return out;
end);

#

InstallGlobalFunction(RankOfBlocks, 
function(blocks)
  local n, rank, i;
  
  n:=DegreeOfBlocks(blocks);
  rank:=0;
  for i in [1..blocks[1]] do 
    if blocks[n+1+i]=1 then 
      rank:=rank+1;
    fi;
  od;
  return rank;
end);

#

InstallGlobalFunction(DegreeOfBlocks,
function(blocks)
  return Length(blocks)-blocks[1]-1;
end);

#


InstallMethod(\*, "for a bipartition and bipartition",
[IsBipartition, IsBipartition], 
function(a,b)
  local n, anr, fuse, fuseit, ablocks, bblocks, x, y, tab, cblocks, next, nrleft, c, i;
  
  n := DegreeOfBipartition(a);
  Assert(1,n = DegreeOfBipartition(b));
  anr := NrBlocks(a);
  
  fuse := [1..anr+NrBlocks(b)]; 
  
  fuseit := function(i) 
    while fuse[i] < i do 
      i := fuse[i]; 
    od; 
    return i; 
  end;
 
  ablocks:=a!.blocks;
  bblocks:=b!.blocks;

  for i in [1..n] do
    x := fuseit(ablocks[i+n]);
    y := fuseit(bblocks[i]+anr);
    if x <> y then
      if x < y then
        fuse[y] := x;
      else
        fuse[x] := y;
      fi;
    fi;
  od;
  
  tab:=0*fuse;    # A table for the old part numbers
  cblocks:=EmptyPlist(2*n);
  next:=0;
  
  for i in [1..n] do
    x := fuseit(ablocks[i]);
    if tab[x]=0 then
      next:=next+1;
      tab[x]:=next;
    fi;
    cblocks[i]:=tab[x];
  od;
  
  nrleft:=next;

  for i in [n+1..2*n] do
    x:=fuseit(bblocks[i]+anr);
    if tab[x]=0 then
      next:=next+1;
      tab[x]:=next;
    fi;
    cblocks[i]:=tab[x];
  od;
  
  c:=Objectify(BipartitionType, rec(blocks:=cblocks)); 
  SetDegreeOfBipartition(c, n);
  SetNrLeftBlocks(c, nrleft);
  SetNrBlocks(c, next);
  return c;
end);

BlocksIdempotentTester:=function(lambda, rho)
  local n, lambdanr, rhonr, fuse, fuseit, sign, x, y, seen, i;

  if DegreeOfBlocks(lambda)<>DegreeOfBlocks(rho) then 
    Error("the degrees of the blocks <lambda> and <rho> must be equal,");
    return;
  fi;

  if RankOfBlocks(lambda)<>RankOfBlocks(rho) then 
    return false;
  fi;

  n:=DegreeOfBlocks(lambda);
  lambdanr:=lambda[1]; 
  rhonr:=rho[1];

  fuse:=[1..lambdanr+rhonr];
  fuseit := function(i) 
    while fuse[i] < i do 
      i := fuse[i]; 
    od; 
    return i; 
  end;
  
  sign:=[1..lambdanr]*0;
  for i in [lambdanr+1..lambdanr+rhonr] do #copy the signs from <left>
    sign[i]:=rho[n+1+i-lambdanr]; 
  od;
  
  for i in [1..n] do
    x := fuseit(lambda[i+1]);
    y := fuseit(rho[i+1]+lambdanr);
    if x <> y then
      if x < y then
        fuse[y] := x;
        if sign[y]=1 then
          sign[x]:=1;
        fi;
      else
        fuse[x] := y;
      fi;
    fi;
  od;

  #check if we are injective on signed classes of <lambda> and that the fused
  #blocks are also signed. 

  seen:=BlistList([1..lambdanr], []);
  for i in [1..lambdanr] do 
    if lambda[n+1+i]=1 then # is block <i> a signed block?
      x:=fuseit(i);
      if seen[x] or sign[x]=0 then 
        return false;
      fi;
      seen[x]:=true;
    fi;
  od;
  return true;
end;

# assumes that BlocksIdempotentTester returns true!

BlocksIdempotentCreator:=function(lambda, rho)
  local n, lambdanr, rhonr, fuse, fuseit, x, y, tab1, tab2, out, next, i;

  n:=DegreeOfBlocks(lambda);
  lambdanr:=lambda[1]; 
  rhonr:=rho[1];

  fuse:=[1..lambdanr+rhonr];
  fuseit := function(i) 
    while fuse[i] < i do 
      i := fuse[i]; 
    od; 
    return i; 
  end;
  
  for i in [1..n] do
    x := fuseit(lambda[i+1]);
    y := fuseit(rho[i+1]+lambdanr);
    if x <> y then
      if x < y then
        fuse[y] := x;
      else
        fuse[x] := y;
      fi;
    fi;
  od;

  tab1:=EmptyPlist(lambdanr);

  #find new names for the signed blocks of rho
  for i in [1..rhonr] do 
    if rho[n+1+i]=1 then 
      tab1[fuseit(i+lambdanr)]:=i;
    fi;
  od;
  
  tab2:=EmptyPlist(lambdanr);
  out:=EmptyPlist(2*n);
  next:=rho[1];
  
  for i in [1..n] do 
    out[i]:=rho[i+1];
    if lambda[n+1+lambda[i+1]]=1 then 
      out[i+n]:=tab1[fuseit(lambda[i+1])];
    else
      if not IsBound(tab2[lambda[i+1]]) then 
        next:=next+1;
        tab2[lambda[i+1]]:=next;
      fi;
      out[i+n]:=tab2[lambda[i+1]];
    fi;
  od;

  out:=Objectify(BipartitionType, rec(blocks:=out)); 
  SetDegreeOfBipartition(out, n);
  SetRankOfBipartition(out, RankOfBlocks(rho));
  SetNrLeftBlocks(out, rho[1]);
  SetNrBlocks(out, next);
  return out;
end;

#InstallMethod(DegreeOfBipartitionCollection, "for a bipartition collection",
#[IsBipartitionCollection], 
#function(coll)
#
#  if IsBipartitionSemigroup(coll) then 
#    return DegreeOfBipartitionSemigroup(coll);
#  elif not ForAll(coll, x-> x[1]=coll[1][1]) then 
#    Error("usage: collection of bipartitions of equal degree,");
#    return;
#  fi;
#  return coll[1][1];
#end);
#
#InstallMethod(DegreeOfBipartitionSemigroup, "for a bipartition semigroup",
#[IsBipartitionSemigroup], 
# s-> Representative(s)[1]);
#
#InstallMethod(Display, "for a bipartition",
#[IsBipartition], function(f)
#  Print("BipartitionNC( ", ExtRepBipartition(f), " )");
#  return;
#end);
#
#InstallMethod(Display, "for a bipartition collection",
#[IsBipartitionCollection],
#function(coll) 
#  local i;
#
#  Print("[ ");
#  for i in [1..Length(coll)] do 
#    if not i=1 then Print(" "); fi;
#    Display(coll[i]);
#    if not i=Length(coll) then 
#      Print(",\n");
#    else
#      Print(" ]\n");
#    fi;
#  od;
#  return;
#end);
#
##JDM this does not currently work!
#
## InstallOtherMethod(IsomorphismTransformationSemigroup,
## "for a bipartiton semigroup",
## [IsBipartitionSemigroup],
## function(s)
##   local n, pts, o, t, pos, i;
## 
##   n:=DegreeOfBipartition(Generators(s)[1]);
##   pts:=EmptyPlist(2^(n/2));
## 
##   for i in [1..n/2] do
##     o:=Orb(s, [i], OnPoints); #JDM multiseed orb
##     Enumerate(o);
##     pts:=Union(pts, AsList(o));
##   od;
##   ShrinkAllocationPlist(pts);
##   t:=Semigroup(List(GeneratorsOfSemigroup(s), 
##    x-> TransformationOp(x, pts, OnPoints)));
##   pos:=List([1..n], x-> Position(pts, [x]));
## 
##   return MappingByFunction(s, t, x-> TransformationOp(x, pts, OnPoints));
## end);
#
#InstallMethod(\*, "for a bipartition and a perm",
#[IsBipartition, IsPerm],
#function(f,g)
#  return f*AsBipartition(g, DegreeOfBipartition(f)/2);
#end);
#
#InstallMethod(\*, "for a perm and a bipartition",
#[IsPerm, IsBipartition],
#function(f,g)
#  return AsBipartition(f, DegreeOfBipartition(g)/2)*g;
#end);
#

# Results:

# n=1 partitions=2 idempots=2
# n=2 partitions=15 idempots=12
# n=3 partitions=203 idempots=114
# n=4 partitions=4140 idempots=1512
# n=5 partitions=115975 idempots=25826
# n=6 partitions=4213597 idempots=541254, 33 seconds
# n=7 partitions=190899322 idempots=13479500, 1591 seconds
