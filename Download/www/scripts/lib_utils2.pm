# -*- perl-indent-level: 2 -*-
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


# version 1.8 2011-10-11
#   - Add the function Popen

# version 1.7 2011-04-20
#   - Add the functions Exec and GetCurrentPid

# version 1.6 2010-11-18
#   - Add the function Link

# version 1.5 2009-10-08

# version 1.4 2009-09-24
#   - Add the option -f to the command mv in Rename()

# version 1.3 2008-09-26
#   - Modify RotateLog() which returns 1 if the rotation is done

# version 1.2 2008-01-29
#   - add Mkdir function

# version 1.1 2007-11-15
#   - add the 'Copy' function
#   - modification of the 'RotateLog' function. The old file is copied
#       instead of renamed and truncated with a seek to the beginning.

# version 1.0 2007-03-12


use strict;
use warnings;


#Package
package lib_utils2;



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Exportations
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

#Version number
our $VERSION = '1.8';

require Exporter;
our @ISA  = qw(Exporter);

our @EXPORT =
    qw(SetUtilsLog Log Display RotateLog
       Trim
       IsProcRunning Kill Run Exec GetCurrentPid Popen
       PROpen FWrite Unlink RmFiles Rename Copy Link Mkdir
       FMDatetime ClosePipe
       UrlParse
       Sleep HumDur Time2Sec Sec2Time
       Min Max Distance_w2w
       CheckToolsRc CheckFileRc CheckPathRc);

our @EXPORT_OK =
    qw(SetUtilsLog Log Display RotateLog
       Trim
       IsProcRunning Kill Run Exec GetCurrentPid ForkPipe Popen
       PROpen FWrite Unlink RmFiles Rename Copy Link Mkdir
       FMDatetime ClosePipe
       UrlParse
       Sleep HumDur Time2Sec Sec2Time
       Min Max Distance_w2w
       CheckToolsRc CheckFileRc CheckPathRc);


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Symbols
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

#Regular expressions
#URL
my $_exp_url = qr/file:\/\/([^:]+):?([^@]*)@([^\/]+)\/(.+)/;
#Trim leading and trailing separators
my $_exp_trim = qr/^\s*(.*?)\s*$/;


#Program name
my $_pn = '';
#Verbose mode
my $_verbose = 2;
#Log mode
my $_logmode = 2;
#Timestamp mode
my $_timestamp = 1;
#Log file streams
my ($_fslog, $_fslog2);

#modif. SV , to avoid "Wide character in print at /people/corinat/scripts/utils.pm line 156."
#binmode STDERR, ":utf8";
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                          Prototypes
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#GetVersion
sub GetVersion { return $VERSION; }

#Set configuration
sub SetConf;

#Print/Log messages
sub SetUtilsLog;
sub Log(@);
sub RotateLog($$$);

#String routines
sub Trim;

#Process routines
sub IsProcRunning($);
sub Kill($);
sub Run;

#File routines
sub PROpen($);
sub FWrite($$);
sub Unlink(@);
sub RmFiles(@);
sub Rename($$);
sub Copy($$);
sub Mkdir($);
sub FMDatetime($);
sub ClosePipe;

#Url routines
sub UrlParse;

#Date and time routines
sub Sleep($);
sub HumDur(@);
sub Time2Sec($);
sub Sec2Time($);
#Computation routines
sub Min(@);        #max value of the list
sub Max(@);        #min value of the list
sub Distance_w2w;  #distance between two words

#Resource routines
sub CheckToolsRc(@);
sub CheckFileRc(@);
sub CheckPathRc(@);

#Current PID from Fork() function
my $_current_pid = -1;


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                         Utilities package
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

# *************************************************************************** #
#                       Set configuration
# *************************************************************************** #
sub SetConf
{
  #---- Parameters ----#
  my (%conf) = @_;


  foreach my $key (keys(%conf)) {
    if ($key eq 'pn') { $_pn = $conf{pn}; }
    elsif ($key eq 'verbose') { $_verbose = $conf{verbose}; }
    elsif ($key eq 'logmode') { $_logmode = $conf{logmode}; }
    elsif ($key eq 'timestamp') { $_timestamp = $conf{timestamp}; }
    elsif ($key eq 'fslog') { $_fslog = $conf{fslog}; }
    elsif ($key eq 'fslog2') { $_fslog2 = $conf{fslog2}; }
  }
}


# *************************************************************************** #
#                       Print/Log messages
# *************************************************************************** #

# =========================================================================== #
# Set the log parameters
#
# Input parameters:
#   program name
#   verbose mode
#   logmode
#   first log file
#   second log file
#
# Returned:
#   0
#
# =========================================================================== #
sub SetUtilsLog
{
  #---- Parameters ----#
  my ($pn, $verbose, $logmode, $fslog, $fslog2) = @_;


  $_pn = $pn if (defined($pn));
  $_verbose = $verbose if (defined($verbose));
  $_logmode = $logmode if (defined($logmode));
  $_fslog = $fslog if (defined($fslog));
  $_fslog2 = $fslog2 if (defined($fslog2));

  return 0;
}

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

  #---- Variables ----#
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime();
  my $timestamp = sprintf('%04d-%02d-%02d %02d:%02d:%02d',
			  $year+1900,$mon+1,$mday,$hour,$min,$sec)
      if ($_timestamp);
  #Get the number of parameters
  my $n=scalar(@_);

  #Old file handler for file flush
  my $oldfh;


  #---- Print on stderr ----#
  if ($level <= $_verbose) {
    #stderr is flushed by default

    #print STDERR "[$_pn $timestamp] ";
    print STDERR "[$timestamp] " if ($_timestamp);  #print the timestamp
    print STDERR 'error: ' if ($level == 0);
    print STDERR @_ if ($n == 1);  #print without format
    printf STDERR @_ if ($n > 1);  #print with format
  }

  #---- Print in the main log file ----#
  if (defined($_fslog) && $level <= $_logmode) {
    #Flush the log file
    $oldfh = select($_fslog);
    $| = 1;

    #print $_fslog "[$_pn $timestamp] ";
    print "[$timestamp] " if ($_timestamp);  #print the timestamp
    print 'error: ' if ($level == 0);
    print @_ if ($n == 1);  #print without format
    printf @_ if ($n > 1);  #print with format

    #Restore the initial file handler
    select($oldfh);
  }

  #---- Print in the 2nd log file ----#
  if (defined($_fslog2) && fileno($_fslog2) != 2 && $level <= $_logmode) {
    #Flush the log file
    $oldfh = select($_fslog2);
    $| = 1;

    #print $_fslog2 "[$_pn $timestamp] ";
    print "[$timestamp] " if ($_timestamp);  #print the timestamp
    print 'error: ' if ($level == 0);
    print @_ if ($n == 1);  #print without format
    printf @_ if ($n > 1);  #print with format

    #Restore the initial file handler
    select($oldfh);
  }

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
  if (fileno($_fslog) != 2 && $level <= $_logmode) {
    print $_fslog @_ if ($n == 1);  #print without format
    printf $_fslog @_ if ($n > 1);  #print with format
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
sub RotateLog($$$)
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
    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = localtime();

    $file =~ /(.+)\.(.+)/;  #extract the file name and the extension
    $newfile = sprintf('%s_%04d%02d%02d_%02d%02d%02d.%s', $1,
		       $year+1900,$month+1,$mday,$hour,$min,$sec, $2);

    #Rename the log file
    Log(1, "rotate '$file' ($filesize bytes) in '$newfile'\n");

    #Copy the file
    Copy($file, $newfile);

    #Truncate
    truncate($fh, 0) or Log(0, "can't truncate log file '$file' <$!>\n");

    #Seek to the beginning of the file SEEK_SET
    seek($fh, 0, 0) or
	Log(0, "can't seek into the file '$file' <$!>\n");

    return 1;
  }

  return 0;
}


# *************************************************************************** #
#                        String routines
# *************************************************************************** #

# =========================================================================== #
# Trim leading and trailing separators
# Input parameters:
#   text: $_ is used if no argument
#
# Returned: the trimed text
# =========================================================================== #
sub Trim
{
  #---- Parameters ----#
  my ($text) = @_;

  if (! defined($text)) {
    return if (! defined($_));
    $text = $_;
  }

  $text =~ $_exp_trim;
  return $1;
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
  my ($pid, $fs);


  #Read the pid
  if ($pidfile && -f $pidfile) {
    open($fs, $pidfile) or
	Log(0, "can't open the file '$pidfile' <$!>\n"), return(-1);
    chop($pid = <$fs>);
    close($fs);

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
  my ($pid, $fs);


  #Read the pid
  if ($pidfile && -f $pidfile) {
    open($fs, $pidfile) or
	Log(0, "can't open the file '$pidfile' <$!>\n"), return(-1);
    chop($pid = <$fs>);
    close($fs);

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
#   level: optional error level which determines if the command error is
#          logged or no. This parameter is used in Log() function.
#
# Returned:
#   0, not zero if error
#
# =========================================================================== #
sub Run
{
  #---- Parameters ----#
  my ($cmd, $level) = @_;

  #---- Variables ----#
  my $status;

  my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = localtime();
  my $timestamp=sprintf('%04d/%02d/%02d %02d:%02d:%02d',
			$year+1900,$month+1,$mday,$hour,$min,$sec);


  #Run the command using the shell "sh" if the command contains shell
  #characters, otherwise the process is directly forked by Perl
  Log(3, "command = [$cmd]\n\n");
  $status=system($cmd);
  return(0) if ($status == 0);

  if ($status == -1) { Log(0, "command [$cmd] not found <$!>\n"); }
  elsif ($status & 127) {
    Log(0, "command [%s] killed with signal %d\n",$cmd,$status & 127);
  }
  else {
    $status >>= 8;
    Log((defined($level)?$level:0),
	'command [%s] exited with status value %d%s', $cmd, $status, "\n");
  }

  return($status);
}

# =========================================================================== #
# "Exec" a system command and never returns
#
# Input parameters:
#   cmd: command to run
#   out: file attached with stderr from child process
#   err: file attached with stdout from child process
#   in:  file attached with stdin from child process
#
# Returned:
#   status returned by child process, -1 if error
#
# I ame not sure if this function is very usefull
# =========================================================================== #
sub Exec
{
  #---- Parameters ----#
  my ($cmd, $out, $err, $in) = @_;

  my ($ofh, $efh, $ifh, $ofd, $efd, $ifd);
  my $status;

  $ifd = $ofd = $efd = -1;

  #Open files to map to stdout/stderr
  if (defined($out)) {
    open($ofh, "$out") or Log(0,"can't open output file\n"), return(-1);
    $ofd = fileno($ofh);
  }

  if (defined($err)) {
    if ($err eq $out) {
      $efd = $ofd;
    }
    else {
      open($efh, "$err") or Log(0,"can't open error file\n"), return(-1);
      $efd = fileno($efh);
    }
  }

  if (defined($in)) {
    open($ifh, "$in") or Log(0,"can't open input file\n"), return(-1);
    $ifd = fileno($ifh);
  }

  #Fork
  $_current_pid = fork();

  #Parent
  if ($_current_pid) {
    wait();
    #Log(0,"child terminated\n");
    $status = $?;
    $_current_pid = -1;
  }
  else {
    #Log(1,"$cmd\n");
    if ($ofd != -1) {
      open(STDOUT, ">&=$ofd") or
	  Log(0,"can't attach stdout file\n"), return(-1);
    }
    if ($efd != -1) {
      open(STDERR, ">&=$efd") or
	  Log(0,"can't attach stderr file\n"), return(-1);
    }
    if ($ifd != -1) {
      open(STDIN, "<&=$ifd") or
	  Log(0,"can't attach stdin file\n"), return(-1);
    }
    exec(split(' ', $cmd));
  }

  return(0) if ($status == 0);

  # SV : As the perldoc says :
  # $status & 127 is OK , $?=128+'n' with 'n' the killing signal number
  if ($status & 127) {
    Log(0, 'command [%s] killed with signal %d%s', $cmd, $status & 127, "\n");
  } else {
    $status >>= 8;
    if ($status == 255) { Log(0, "command [$cmd] not found <$!>\n") }
    else {
      Log(0,'command [%s] exited with status value %d%s', $cmd, $status, "\n");
    }
  }

  return($status);
}

# =========================================================================== #
# Get the current pid
#
# Input parameters:
#
# Returned:
#   -1 if there's no child running, pid otherwise
#
# =========================================================================== #
sub GetCurrentPid {
  return($_current_pid);
}

# =========================================================================== #
# Fork a process and map the 1st returned pipe to it's STDIN and the 2nd
# returned map to it's STDOUT
#
# Input parameters:
#   command line
#
# Returned:
#  (pid, parent write pipe (child STDIN), parent read pipe (child STDOUT))
#  if success
#
#  undef otherwise
#
# =========================================================================== #
sub Popen
{
  #---- Parameters ----#
  my ($cmd) = @_;

  #---- Variables ----#  
  my ($pipe_read_parent, $pipe_write_parent);
  my ($pipe_read_child, $pipe_write_child, $pid);
  my ($prevfh);

  #Open two pipes
  pipe($pipe_read_child, $pipe_write_parent) or
      (print STDERR "can't open the pipe <$!>\n"), return undef;

  pipe($pipe_read_parent, $pipe_write_child) or
      (print STDERR "can't open the pipe <$!>\n"), return undef;

  #Make the parent write pipe in autoflush mode
  $prevfh = select($pipe_write_parent);
  $| = 1;
  #Restore the initial file handler
  select($prevfh);

  #Fork
  $pid = fork();
  if (! defined($pid)) {
    (print STDERR "can't fork <$!>\n"), return undef;
  }

  #Parent
  if ($pid) {
    #Close child's unused pipes
    close($pipe_read_child);
    close($pipe_write_child);
  }
  #Child
  else {
    #Close parent's unused pipes
    close($pipe_write_parent);
    close($pipe_read_parent);

    #Map the read pipe to STDIN
    open(STDIN, '<&=' . fileno($pipe_read_child)) or
	(print STDERR "can't map pipe to STDIN <$!>\n"), return undef;

    #Map the write pipe to STDOUT
    open(STDOUT, '>&=' . fileno($pipe_write_child)) or
    (print STDERR "can't map STDOUT <$!>\n"), return undef;

    #Overlay the current process by a new process
    exec(split(' ', $cmd));
    #This statement is accessible only if the exec command fail
    #Log(0, "can't execute command '$cmd' <$!>\n");
    exit(1);
  }

  return ($pid, $pipe_write_parent, $pipe_read_parent);
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
  my ($line, $pipe);

  Log(3, "command = [$cmd]\n");
  open($pipe, $cmd) or Log(0, "command [$cmd] not found <$!>\n"), return('');
  chop($line = $pipe);
  close($pipe);
  length($line) or Log(0,"error in the command [$cmd]\n"), return('');
  Log(3, "line=[$line]\n");
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

  #---- Variables ----#
  my $fs;

  open($fs, "> $fn") or
      Log(0,"can't open in write mode the file '$fn' <$!>\n"), return(-1);
  print $fs "$text";
  close($fs);
  return(0);
}

# =========================================================================== #
# Remove files
# =========================================================================== #
sub Unlink(@)
{
  #Remove the file
  unlink(@_);

  #Check if the file is really removed
  foreach my $f (@_) {
    if (-f $f) {
      Log(0,"can't remove the file '$f' <$!>\n");
      return(-1);
    }
  }
  Log(3, 'remove \'%s\'%s', join(", ",@_), "\n");

  return(0);
}

# =========================================================================== #
# Remove files listed in the input file
# =========================================================================== #
sub RmFiles(@)
{
  #---- Parameters ---#
  my ($fn) = @_;

  #---- Variables ----#
  my $fs;


  #Check
  Log(0,"list file '$fn' not found\n"), return(-1) if (! -f $fn);

  #Delete all the files
  open($fs, $fn);
  while (<$fs>) {
    chop();
    unlink($_), Log(3, "remove '$_'\n") if (-f $_);
  }
  close($fs);

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
      (Run("/bin/mv -f $old $new"));
  Log(3, "rename $old $new\n");

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


  #Copy the source file in a target file
  Log(0, "can't copy file '$src' into '$target'\n"), return(-1) if
      (Run("/bin/cp $src $target"));
  Log(3, "copy $src $target\n");

  #Success
  return(0);
}

# =========================================================================== #
# Link the source file into a target link
# =========================================================================== #
sub Link($$)
{
  #---- Parameters ---#
  my ($src, $target) = @_;


  #Link the source file in a target link
  Log(0, "can't link file '$src' into '$target'\n"), return(-1) if
      (Run("/bin/ln -s $src $target"));
  Log(3, "link $src $target\n");

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
      (! mkdir($dir));

  #Success
  return(0);
}

# =========================================================================== #
# Extract and format last file modification date
# =========================================================================== #
sub FMDatetime($)
{
  #---- Parameters ---#
  my ($file) = @_;


  my ($sec, $min, $hour, $mday, $month, $year, $wday, $yday) =
      localtime((stat($file))[9]);
  $year += 1900;
  $month++;

  return sprintf('%04d-%02d-%02d %02d:%02d:%02d',
		 $year, $month, $mday, $hour, $min, $sec);
}

# =========================================================================== #
# Close a pipe with timeout if the pipe is blocked
# Returned:
#    0  success
#   -1  error
#   -2  timeout expired
# =========================================================================== #
sub ClosePipe
{
  #---- Parameters ---#
  my ($p_pipe, $p_timeout) = @_;


  if (defined($p_timeout) && $p_timeout > 0) {
    use POSIX ':signal_h';

    #---- Variables ----#
    my ($mask, $action, $oldaction);


    #Signals to mask in the handler
    $mask = POSIX::SigSet->new(SIGALRM);
    $action = POSIX::SigAction->new(sub {die "timeout expired\n"}, $mask);
    $oldaction = POSIX::SigAction->new();
    sigaction(SIGALRM, $action, $oldaction );
    eval {
      alarm($p_timeout); # seconds before time out
      close($p_pipe);
      alarm(0); # cancel alarm (if connect worked fast)
    };

    alarm(0);    # cancel alarm (if eval failed)
    sigaction(SIGALRM, $oldaction);  # restore original signal handler

    if ($@) { Log(0, "ClosePipe() timeout expired\n"); return -2 }
    return 0;
  }

  else {
    close($p_pipe) or return -1;
    return 0;
  }
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
  return if (! defined($dur));

  #---- Variables ----#
  my ($min, $sec, $msec, $hdur);
 

  #Default unit
  $unit="s" if (! defined($unit));

  #Duration in milliseconds
  if ($unit eq "ms") {
    $sec = $dur / 1000;
    $msec = $dur % 1000;
    $min = $sec % 3600;
    $hdur = sprintf('%d:%02d:%02d.%03d',
		    $sec / 3600, $min / 60, $min % 60,$msec);
  }

  #Duration in seconds
  else {
    $min = $dur % 3600;
    $hdur = sprintf('%d:%02d:%02d',
		    $dur / 3600, $min / 60, $min % 60);
  }

  #Return human readable duration
  return($hdur);
}
# =========================================================================== #
# Convert a duration from seconds or milliseconds in readable human format
#   xxxx[.xxx] to hh:mm:ss[.ms]
#
# Input parameters:
#   duration: duration in seconds
#
# Returned:
#   hh:mm:ss
#   hh:mm:ss.ms
#
# =========================================================================== #
sub Sec2Time($)
{
  #---- Parameters ----#
  my ($dur) = @_;
  return if (! defined($dur));
  return if ( $dur < 0);
  use POSIX qw(ceil);

  #---- Variables ----#
  my ($min, $sec, $msec, $hdur);

  #Compute Duration
  $msec = ceil((($dur - int($dur)) * 1000));
  $min  = $dur % 3600;
  $hdur = ($msec > 0)
      ? sprintf('%d:%02d:%02d.%03d',
		$dur / 3600, $min / 60, $min % 60, $msec)
      : sprintf('%d:%02d:%02d',
		$dur / 3600, $min / 60, $min % 60);

  #Return human readable duration
  return($hdur);
}

# =========================================================================== #
# Convert a readable human format duration to seconds or milliseconds
#   hh:mm:ss or hh:mm:ss[.ms] xxxx or xxxx.xxx
#
# Input parameters:
#   duration: duration
#   unit: units. Seconds or milliseconds. Default is seconds.
#
# Returned:
# xxxx or xxxx.xxx
#
# =========================================================================== #
sub Time2Sec($)
{
  #---- Parameters ----#
  my ($hdur) = @_;
  return if (! defined($hdur));

  #---- Variables ----#
  my ($hour, $min, $sec);

  #Compute Human read string
  ($hour, $min, $sec) = split /:/, $hdur;  #for emacs/

  $sec += $hour * 3600 + $min * 60;
  $sec  = sprintf('%.3f', $sec);

  #Return seconds
  return($sec);
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

1
