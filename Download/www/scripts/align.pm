#   Copyright (c) 2010 by VECSYS. All rights reserved.

#   No part of this software may be used or transmitted in any form or
#   by any means without the explicit permission of the author.  In the
#   case that permission is granted to use and/or to modify this
#   software, it is mandatory that this copyright notice appear in all
#   copies. Non-compliance with these terms immediately invalidates the
#   granted permission.


# Author: S. Vanni
# Description: document alignment using dynamic programming algorithm
# History :

#  version 1.0  2009-01-31
#   alignment done by sc tool (STK/Limsi)

#  version 2.0  2010-02-18
#   - alignment done by perl function
#   - apply alignment rules in this program

#  version 2.1 2010-02-25
#  author: S. Bennacef , S. Vanni
#   - modification of the code


package align;


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Exportations
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

our ( @ISA, @EXPORT, @EXPORT_OK );

BEGIN {
    use Exporter;
    @ISA = qw(Exporter);
    @EXPORT = qw(Align);
    @EXPORT_OK = qw(Align);
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Packages
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

no locale;
use strict;
use warnings;
use Algorithm::Diff;
use lib $ENV{PERL_LIB};

#Version number
our $VERSION = "2.1";


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Symbols
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#Operations codes
my ($_OK, $_SUB, $_INS, $_DEL) = (0, 1, 2, 3);


# *************************************************************************** #
#       Align between reference and hypothesis list of words
#
# Input parameters:
#   p_ref: reference list of words
#   p_hyp: hypothesis list of words
#   p_prm: optional hash parameters
#
# Output :
#   hash result containing
#   status, error, dist, path, nok, nsub, nins, ndel, ok, sub, ins, del
# *************************************************************************** #
sub Align {

  #---- Parameters ----#
  my ($p_ref, $p_hyp, %p_prm) = @_;

  #---- Variables ----#
  my $func;


  if ($p_prm{method} eq 'dp') {
    $func = \&Dp;
  }
  else {
    $func = \&Diff;
  }

  return &$func(@_);
}


# *************************************************************************** #
#       Align between reference and hypothesis list of words
#             using dynamic programming algorithm
#
# Input parameters:
#   p_ref: reference list of words
#   p_hyp: hypothesis list of words
#   p_prm: optional hash parameters
#
# Output :
#   hash result containing
#   status, error, dist, path, nok, nsub, nins, ndel, ok, sub, ins, del
# *************************************************************************** #
sub Dp {

  #---- Parameters ----#
  my ($p_ref, $p_hyp, %p_prm) = @_;

  #---- Variables ----#
  #Dynamic programming matrixes and path
  my (@matrix_cost, @matrix_op, @path);

  #Penalities and operations
  my $op;                             #operation
  my ($sub_pty, $ins_pty, $del_pty);  #penalities of operations
  my $dist;                           #distance between two words
  my ($nok, $nsub, $nins, $ndel);     #number of operations

  #Length of reference and hypothesis words lists
  my ($n, $m);

  #Indices
  my ($i, $j, $k);


  #-----------------#
  # Initializations #
  #-----------------#
  #Default penalities
  ($sub_pty, $ins_pty, $del_pty) = (1, 1, 1);

  #Parameters penalities
  $sub_pty = $p_prm{sub_pty} if (defined($p_prm{sub_pty}));
  $ins_pty = $p_prm{ins_pty} if (defined($p_prm{ins_pty}));
  $del_pty = $p_prm{del_pty} if (defined($p_prm{del_pty}));

  $n = scalar(@$p_ref);
  return { status => 1, error => 'empty reference' } if ($n == 0);
  $m = scalar(@$p_hyp);

  #----------------------------#
  # Cost matrix initialization #
  #----------------------------#
  $matrix_cost[0][0] = 0;

  foreach $j (1 .. $m) {
    $matrix_cost[0][$j] = $j * $ins_pty;
  }

  #-----------------------------------------#
  # Fill the dynamic programmic cost matrix #
  #-----------------------------------------#
  for $i (1 .. $n) {
    #Initialization. Done here to save reference iterations
    $matrix_cost[$i][0] = $i * $del_pty;

    for $j (1 .. $m) {
      #Distance between two words, equality => subsitution penality, 0 else.
      $dist = $p_ref->[$i-1] eq $p_hyp->[$j-1] ? 0 : $sub_pty;

      #Minimal local path
      ($matrix_cost[$i][$j], $matrix_op[$i-1][$j-1] ) =
	  MinCost($ins_pty  + $matrix_cost[$i][$j-1],
		  $dist + $matrix_cost[$i-1][$j-1],
		  $del_pty  + $matrix_cost[$i-1][$j],
		  $dist);
    }
  }

  #------------------------#
  # Build the optimal path #
  #------------------------#
  $i = $n - 1;
  $j = $m - 1;
  $k = 0;

  while ($i >= 0 && $j >= 0) {
    $op = $matrix_op[$i][$j];
    $path[$k++] = $op;

    if ($op == $_OK) { $i--; $j--; $nok++; }
    elsif ($op == $_SUB) { $i--; $j--; $nsub++; }
    elsif ($op == $_INS) { $j--; $nins++; }
    elsif ($op == $_DEL) { $i--; $ndel++; }
  }

  while ($i >= 0) { $ndel++; $path[$k++] = $_DEL; $i--; }
  while ($j >= 0) { $nins++; $path[$k++] = $_INS; $j--; }

  #Reverse the path
  @path = reverse @path;

  #------------------#
  # Alignment result #
  #------------------#
  return
    {
      status => 0,
      error  => '',
      dist   => $matrix_cost[$n][$m] / ($n+$m),

      path   => \@path,

      nok    => $nok  ? sprintf("%.1f", ($nok  * 100) / $n) : 0,
      nsub   => $nsub ? sprintf("%.1f", ($nsub * 100) / $n) : 0,
      nins   => $nins ? sprintf("%.1f", ($nins * 100) / $n) : 0,
      ndel   => $ndel ? sprintf("%.1f", ($ndel * 100) / $n) : 0,

      ok     => $_OK,
      sub    => $_SUB,
      ins    => $_INS,
      del    => $_DEL
    };
}


# *************************************************************************** #
#                     Compute the minimal cost
# Search of the minimum from three values and return the operation type
# In equality case, the priority order is arg3 >> arg2 >> arg1
# *************************************************************************** #
sub MinCost
{
  #---- Parameters ----#
  my ($p_ins, $p_sub, $p_del, $p_dist) = @_;

  #for $p_sub >> $p_del >> $p_ins
  return
    ($p_ins < $p_sub) ?
      (($p_ins < $p_del) ? ($p_ins, $_INS) : ($p_del, $_DEL)) :
   	(($p_sub < $p_del) ? ($p_sub, (($p_dist == 0) ? $_OK : $_SUB)) : ($p_del, $_DEL));
}


# *************************************************************************** #
#       Align between reference and hypothesis list of words
#       using the Longest Common Subsequence algorithm (LCS)
#
# Reference :
#  * A Fast Algorithm for Computing Longest Common Subsequences,
#    CACM, vol.20, no.5, pp.350-353, May 1977
#
#  * A New Efficient Algorithm for Computing the Longest Common Subsequence
#
# Input parameters:
#   p_ref: reference list of words
#   p_hyp: hypothesis list of words
#   p_prm: optional hash parameters
#
# Output :
#   hash result containing
#   status, error, dist, path, nok, nsub, nins, ndel, ok, sub, ins, del
# *************************************************************************** #
sub Diff
{
  #---- Parameters ----#
  my ($p_ref, $p_hyp, %p_prm) = @_;

  #---- Variables ----#
  my $sdiff;                       #sdiff result
  my ($op, $item, @path);          #operations and path
  my ($nok, $nsub, $nins, $ndel);  #number of operations


  #Length of reference and hypothesis words lists
  my ($n, $m);


  #-----------------#
  # Initializations #
  #-----------------#
  $n = scalar(@$p_ref);
  return { status => 1, error => 'empty reference' } if ($n == 0);
  $m = scalar(@$p_hyp);

  #----------------#
  # Apply the diff #
  #----------------#
  $sdiff = Algorithm::Diff::sdiff($p_ref, $p_hyp);

  #----------------#
  # Build the path #
  #----------------#
  foreach $item (@$sdiff) {
    $op = $item->[0];
    if ($op eq 'u') {
      push(@path, $_OK);
      $nok++;
    }
    elsif ($op eq 'c') {
      push(@path, $_SUB);
      $nsub++;
    }
    elsif ($op eq '+') {
      push(@path, $_INS);
      $nins++;
    }
    elsif ($op eq '-') {
      push(@path, $_DEL);
      $ndel++;
    }
  }

  #----------------------#
  # Compute the distance #
  #----------------------#

  #-------------#
  # Diff result #
  #-------------#
  return
    {
      status => 0,
      error  => '',
      dist   => 0,

      path   => \@path,

      nok    => $nok  ? sprintf("%.1f", ($nok  * 100) / $n) : 0,
      nsub   => $nsub ? sprintf("%.1f", ($nsub * 100) / $n) : 0,
      nins   => $nins ? sprintf("%.1f", ($nins * 100) / $n) : 0,
      ndel   => $ndel ? sprintf("%.1f", ($ndel * 100) / $n) : 0,

      ok     => $_OK,
      sub    => $_SUB,
      ins    => $_INS,
      del    => $_DEL
    };
}
