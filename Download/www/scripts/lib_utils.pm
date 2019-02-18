#!/usr/bin/perl
#   Copyright (c) 2007 by VECSYS. All rights reserved.

#   No part of this software may be used or transmitted in any form or
#   by any means without the explicit permission of the author.  In the
#   case that permission is granted to use and/or to modify this
#   software, it is mandatory that this copyright notice appear in all
#   copies. Non-compliance with these terms immediately invalidates the
#   granted permission.


# Author: S.K. Bennacef
# Description: Perl utilities
# History:
#   - version 1.0 2007-03-12

#   - version 1.1 2007-11-15
#     . add the 'Copy' function
#     . modification of the 'RotateLog' function. The old file is copied
#       instead of renamed and truncated with a seek to the beginning.

#  - version 1.2 2008-01-29
#    . add Mkdir function

# - version 1.3 2008-09-26
#    . Modify RotateLog() which returns 1 if the rotation is done


#use strict;
use warnings;

#Package
package lib_utils;

#Version number
our $VERSION = "1.3";


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Exportations
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

require Exporter;
our @ISA  = qw(Exporter);

our @EXPORT =
    qw(Log Display RotateLog
       IsProcRunning Kill Run
       PROpen FWrite Unlink RmFiles Rename Copy Mkdir FMDatetime
       UrlParse
       GetLocalTime
       Sleep HumDur
       Min Max Distance_w2w
       CheckToolsRc CheckFileRc CheckPathRc
       $VERSION $_pn $_verbose $_logmode *_LOGFS );

our @EXPORT_OK =
    qw(Log Display RotateLog
       IsProcRunning Kill Run
       PROpen FWrite Unlink RmFiles Rename Copy Mkdir FMDatetime
       UrlParse
       GetLocalTime
       Sleep HumDur
       Min Max Distance_w2w
       CheckToolsRc CheckFileRc CheckPathRc
       $VERSION $_pn $_verbose $_logmode *_LOGFS );


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Symbols
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

#Regular expressions
#URL
my $_exp_url = qr/file:\/\/([^:]+):?([^@]*)@([^\/]+)\/(.+)/;


# *************************************************************************** #
#                        Exported variables
# *************************************************************************** #

#==== Exportded variables ====#
#Program name
our $_pn = "lib_utils.pm";
#Verbose mode
our $_verbose = 2;
#Log mode
our $_logmode = 2;

#Main log file stream
#open(_LOGFS,">&=STDERR");
#2nd log file stream

#modif. SV , to avoid "Wide character in print at /people/corinat/scripts/utils.pm line 156."
#binmode STDERR, ":utf8";
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                          Prototypes
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#Print/Log messages
sub Log(@);
sub RotateLog(*$$);

#Process routines
sub IsProcRunning($);
sub Kill($);
sub Run($);
sub GetLocalTime();

#File routines
sub PROpen($);
sub FWrite($$);
sub Unlink(@);
sub RmFiles(@);
sub Rename($$);
sub Copy($$);
sub Mkdir($);
sub FMDatetime($);

#Url routines
sub UrlParse;

#Date and time routines
sub Sleep($);
sub HumDur(@);

#Computation routines
sub Min(@);        #max value of the list
sub Max(@);        #min value of the list
sub Distance_w2w;  #distance between two words

#Resource routines
sub CheckToolsRc(@);
sub CheckFileRc(@);
sub CheckPathRc(@);


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                         Utilities package
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

# *************************************************************************** #
#                       Print/Log messages
# *************************************************************************** #

# =========================================================================== #
# Log in stderr and log file with timestamp
#
# Input parameters:
#   level:   log level
#
#   string:  string to log
# or
#   format:    string format
#   arguments: arguments
#
# Returned:
#   0
#
# =========================================================================== #
sub Log(@)
{
    #---- Parameters ----#
    my $level = shift;


    return(0);
}


# =========================================================================== #
# Log in stderr and log file without timestamp
#
# Input parameters:
#   level:   log level
#
#   string:  string to log
# or
#   format:    string format
#   arguments: arguments
#   string:  string to log
#
# Returned:
#   0
#
# =========================================================================== #
sub Display(@)
{
    #---- Parameters ----#
    my $level = shift;

    #---- Variables ----#
    my $n=scalar(@_);


    #---- Print on stderr ----#
    if ($level <= $_verbose) {
	print STDERR @_ if ($n == 1);  #print without format
	printf STDERR @_ if ($n > 1);  #print with format
    }

    #---- Print in the log file ----#
    if (fileno(_LOGFS) != 2 && $level <= $_logmode) {
	print _LOGFS @_ if ($n == 1);  #print without format
	printf _LOGFS @_ if ($n > 1);  #print with format
    }

    return(0);
}

# =========================================================================== #
# Rotate log file by adding time stamp
# Returns :
#  -1 if error
#   1 if the rotation done
#   0 otherwise
# =========================================================================== #
sub RotateLog(*$$)
{
    #---- Parameters ----#
    my ($fh, $file, $maxsize) = @_;

    #---- Variables ----#
    my $newfile;


    #Check parameters
    return -1 if (fileno($fh) == fileno(STDERR) || ! $file || ! -f $file ||
		   $maxsize <= 0);

    #Use of stat() on null file returns an error
    return 0 if (-z $file);

    #Read the file size in bytes
    my $filesize = (stat($file))[7] or
	Log(0, "can't get the size of file '$file' <$!>\n"), return -1;

    #Rename the file
    if ($filesize >= $maxsize) {
	#Build the new filename
	my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = GetLocalTime();

	$file =~ /(.+)\.(.+)/;  #extract the file name and the extension
	$newfile = sprintf("%s_%04d%02d%02d_%02d%02d%02d.%s", $1,
			   $year,$month,$mday,$hour,$min,$sec, $2);

	#Rename the log file
	Log(1, "rotate '$file' ($filesize bytes) in '$newfile'\n");

	#Copy the file
	Copy($file, $newfile);

	#Truncate
	truncate($fh, 0) or Log(0, "can't truncate log file '$file' <$!>\n");

	#Seek to the beginning of the file
	seek($fh,0,SEEK_SET) or
	    Log(0, "can't seek into the file '$file' <$!>\n");

	return 1;
    }

    return 0;
}


# *************************************************************************** #
#                        Process routines
# *************************************************************************** #

# =========================================================================== #
# Check if the process is running
# =========================================================================== #
sub IsProcRunning($)
{
    #---- Parameters ----#
    my ($pidfile) = @_;

    #---- Variables ----#
    my $pid;


    #Read the pid
    if ($pidfile && -f $pidfile) {
	open(FS, $pidfile) or
	    Log(0, "can't open the file '$pidfile' <$!>\n"), return(-1);
	chop($pid = <FS>);
	close(FS);

	#Check if the process is running
	return($pid) if (getpgrp($pid) > 0);

	#The pid exist in the file but is not running
	return(0);
    }

    return(0);
}


# =========================================================================== #
# Kill process
# =========================================================================== #
sub Kill($)
{
    #---- Parameters ----#
    my ($pidfile) = @_;

    #---- Variables ----#
    my $pid;


    #Read the pid
    if ($pidfile && -f $pidfile) {
	open(FS, $pidfile) or
	    Log(0, "can't open the file '$pidfile' <$!>\n"), return(-1);
	chop($pid = <FS>);
	close(FS);

	#Send a signal INT to a process
	Log(1, "send a signal '2' to process '$pid'\n");
	kill(2, $pid);
	#sleep(1);

	#Send a signal KILL to a process
	#if (getpgrp($pid) > 0) {
	    #Log(1, "send a signal '9' to process '$pid'\n");
	    #kill(9, $pid);
	#}
	return($pid);
    }

    return(0);
}


# =========================================================================== #
# Run a command
#
# Input parameters:
#   cmd: command to run
#
# Returned:
#   0, not zero if error
#
# =========================================================================== #
sub Run($)
{
    #---- Parameters ----#
    my ($cmd) = @_;

    #---- Variables ----#
    my $status;

    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = GetLocalTime();
    my $timestamp=sprintf("%04d/%02d/%02d %02d:%02d:%02d",
			 $year,$month,$mday,$hour,$min,$sec);


    #Run the command using the shell "sh"
    Log(3,"[$timestamp]\ncommand = [$cmd]\n\n");
    $status=system($cmd);
    return(0) if ($status == 0);

    if ($status == -1) { Log(0,"command [$cmd] not found <$!>\n"); }
    elsif ($status & 127) {
	Log(0,"command [%s] killed with signal %d\n",$cmd,$status & 127);
    }
    else {
        $status = $status >> 8;
	Log(0,"command [%s] exited with status value %d\n",$cmd,$status);
    }

    return($status);
}


# *************************************************************************** #
#                            File routines
# *************************************************************************** #

# =========================================================================== #
# Run a command by creating a pipe in a read mode
#
# Input parameters:
#   cmd: command to run
#
# Returned:
#   0, -1 if error
#
# =========================================================================== #
sub PROpen($)
{
    #---- Parameters ----#
    my ($cmd) = @_;

    #---- Variables ----#
    my $line;

    Log(3,"command = [$cmd]\n");
    open(FS,"$cmd") or Log(0,"command [$cmd] not found <$!>\n"), return("");
    chop($line=<FS>);
    close(FS);
    length($line) or Log(0,"error in the command [$cmd]\n"), return("");
    Log(3,"line=[$line]\n");
    return($line);
}


# =========================================================================== #
# Write in a file
#
# Input parameters:
#   fn: filename
#   text: text to write
#
# Returned:
#   0, -1 if error
# =========================================================================== #
sub FWrite($$)
{
    #---- Parameters ----#
    my ($fn, $text) = @_;

    open(FS,"> $fn") or
	Log(0,"can't open in write mode the file '$fn' <$!>\n"), return(-1);
    print FS "$text";
    close(FS);
    return(0);
}

# =========================================================================== #
# Remove files
# =========================================================================== #
sub Unlink(@)
{
    #Remove the file
    Log(2,"remove '%s'\n",join(", ",@_));
    unlink(@_);

    #Check if the file is really removed
    foreach my $f (@_) {
	if (-f $f) {
	    Log(0,"can't remove the file '$f' <$!>\n");
	    return(-1);
	}
    }

    return(0);
}

# =========================================================================== #
# Remove files listed in the input file
# =========================================================================== #
sub RmFiles(@)
{
    #---- Parameters ---#
    my ($fn) = @_;

    #Check
    Log(0,"list file '$fn' not found\n"), return(-1) if (! -f $fn);

    #Delete all the files
    open(FS,$fn);
    while (<FS>) {
	chop();
	unlink($_) if (-f $_);
    }
    close(FS);

    return(0);
}

# =========================================================================== #
# Rename files in and between filesystems
# =========================================================================== #
sub Rename($$)
{
    #---- Parameters ---#
    my ($old, $new) = @_;


    #Rename the old file in a new file
    Log(0, "can't move file '$old' into '$new'\n"), return(-1) if
	(Run("/bin/mv $old $new"));

    #Success
    return(0);
}

# =========================================================================== #
# Copy the source file into a target file
# =========================================================================== #
sub Copy($$)
{
    #---- Parameters ---#
    my ($src, $target) = @_;


    #Copy the old file in a new file
    Log(0, "can't copy file '$src' into '$target'\n"), return(-1) if
	(Run("/bin/cp $src $target"));

    #Success
    return(0);
}

# =========================================================================== #
# Create a directory a directory
# =========================================================================== #
sub Mkdir($)
{
    #---- Parameters ---#
    my ($dir) = @_;


    #Create the directory
    Log(0, "can't create the directory '$dir' <$!>\n"), return(-1) if
	(! mkdir("$dir"));

    #Success
    return(0);
}

# =========================================================================== #
# Extract and format last file modification date
# =========================================================================== #
sub GetLocalTime()
{

    my ($sec, $min, $hour, $mday, $month, $year, $wday, $yday) = localtime();
    $year += 1900;
    $month++;
    #print STDERR "GetLocalTime = ($sec, $min, $hour, $mday, $month, $year, $wday, $yday)\n";
    return  ($sec, $min, $hour, $mday, $month, $year, $wday, $yday) ;
}

sub FMDatetime($)
{
    #---- Parameters ---#
    my ($file) = @_;


    my ($sec, $min, $hour, $mday, $month, $year, $wday, $yday) = GetGetLocalTime();

    return sprintf("%04d-%02d-%02d %02d:%02d:%02d",
		   $year, $month, $mday, $hour, $min, $sec);
}


# *************************************************************************** #
#                        URL routines
# *************************************************************************** #
sub UrlParse
{
    #---- Parameters ---#
    my ($url) = @_;

    #---- Variables ----#
    my @fields;


    #$1:login, $2: password, $3:host, $4:path
    $url =~ $_exp_url;
    @fields =
	(defined($1)?$1:'', defined($2)?$2:'', defined($3)?$3:'',
	 defined($4)?$4:'');

    return @fields;
}

# *************************************************************************** #
#                        Date and time routines
# *************************************************************************** #

# =========================================================================== #
# Sleep in milliseconds

# Input parameters:
#   duration: duration in milliseconds
#
# Returned:
#   nothing
#
# =========================================================================== #
sub Sleep($)
{
    #---- Parameters ----#
    my ($dur) = @_;

    select(undef, undef, undef, $dur/1000);
}


# =========================================================================== #
# Convert a duration from seconds or milliseconds in readable human format
#   hh:mm:ss if unit=s
#   hh:mm:ss[.ms] if unit=ms
#
# Input parameters:
#   duration: duration
#   unit: units. Seconds or milliseconds. Default is seconds.
#
# Returned:
#   hh:mm:ss if unit=s
#   hh:mm:ss.ms if unit=ms
#
# =========================================================================== #
sub HumDur(@)
{
    #---- Parameters ----#
    my ($dur, $unit) = @_;

    #---- Variables ----#
    my ($min, $sec, $msec, $hdur);
 
    #Default unit
    $unit="s" if (! defined($unit));

    #Duration in milliseconds
    if ($unit eq "ms") {
	$sec = $dur / 1000;
	$msec = $dur % 1000;
	$min = $sec % 3600;
	$hdur = sprintf("%d:%02d:%02d.%03d",
		     $sec / 3600, $min / 60, $min % 60,$msec);
    }

    #Duration in seconds
    else {
	$min = $dur % 3600;
	$hdur = sprintf("%d:%02d:%02d",
			$dur / 3600, $min / 60, $min % 60);
    }

    #Return human readable duration
    return($hdur);
}


# *************************************************************************** #
#                         Computation routines
# *************************************************************************** #

# =========================================================================== #
# Return the min value from a list of values
#
# Input parameters:
#   list of numerical values
#
# Returned:
#   0, -1 if error
#
# =========================================================================== #
sub Min(@)
{
    my $min = shift(@_);

    foreach my $v (@_) { $min = $v if $min > $v; }
    return($min);
}

# =========================================================================== #
# Return the max value from a list of values
#
# Input parameters:
#   list of numerical values
#
# Returned:
#   0, -1 if error
#
# =========================================================================== #
sub Max(@)
{
    my $max = shift(@_);

    foreach my $v (@_) { $max = $v if $max < $v; }
    return($max);
}

# =========================================================================== #
#                 Distance_w2w
#
# Distance between two words
#
# Input parameters:
#   $s   : word hyp
#   $t   : word ref
# Output :
#   @result : distance between $s and $t
# =========================================================================== #
sub Distance_w2w
{
    #---- Parameters ----#
    my ($s,$t) = @_;

    #---- Variables ----#
    my $n=length($s);
    my @result;

    if ($s eq $t) {
	return  0;
    }
    my @d;
    my $cost = 0;
    my $m=length($t);


    push @result,$m and next unless $n;
    push @result,$n and next unless $m;
    $d[0][0] = 0;

    foreach my $i (1 .. $n) {			
	$d[$i][0] = $i;
    }
    foreach my $j (1 .. $m) {
	$d[0][$j] = $j;
    }
    for my $i (1 .. $n) {
	my $s_i = substr($s,$i-1,1);
	for my $j (1 .. $m) {
	    $d[$i][$j] = Min($d[$i-1][$j] + 1,
			     $d[$i][$j-1] + 1,
			     $d[$i-1][$j-1] +
			     ($s_i eq substr($t,$j-1,1) ? 0 : 1) )
	}
    }
    return $d[$n][$m];
}


# *************************************************************************** #
#                          Resource routines
# *************************************************************************** #

# =========================================================================== #
# Check for tools resources
#
# Input parameters:
#   @_: tools list
#
# Returned:
#   0, -1 if error
#
# =========================================================================== #
sub CheckToolsRc(@)
{
    #---- Parameters ----#
    #@_

    #Check if each tool exist in executable mode
    foreach my $t (@_) {
	if (! -f $t) {
	    Log(0, "can't find the tool '$t'\n");
	    return(-1);
	}
	if (! -x $t) {
	    Log(0, "the tool is not in executable mode '$t'\n");
	    return(-1);
	}
    }
    return(0);
}


# =========================================================================== #
# Check for file resources
#
# Input parameters:
#   @_: resources files list
#
# Returned:
#   0, -1 if error
#
# =========================================================================== #
sub CheckFileRc(@)
{
    #---- Parameters ----#
    #@_

    #Check if each resource file exist
    foreach my $f (@_) {
	if (! -e $f) {
	    Log(0,"can't find the file '$f'\n");
	    return(-1);
	}
    }
    return(0);
}


# =========================================================================== #
# Check for path resources
#
# Input parameters:
#   @_: resources files list
#
# Returned:
#   0, -1 if error
#
# =========================================================================== #
sub CheckPathRc(@)
{
    #---- Parameters ----#
    #@_

    #Check if each resource file exist
    foreach my $p (@_) {
	if (! -d $p) {
	    Log(0,"can't find the path '$p'\n");
	    return(-1);
	}
    }
    return(0);
}
