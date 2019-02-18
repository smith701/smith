#!/usr/bin/perl

#   Copyright (c) 2009 by VECSYS. All rights reserved.

#   No part of this software may be used or transmitted in any form or
#   by any means without the explicit permission of the author.  In the
#   case that permission is granted to use and/or to modify this
#   software, it is mandatory that this copyright notice appear in all
#   copies. Non-compliance with these terms immediately invalidates the
#   granted permission.


# Author: S.K. Bennacef
# Description: MSF client
#
#
# History:
# version 1.0  2009-04-10



# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                             Packages
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
use strict;
use warnings;
 
#Modules
use LWP::UserAgent;
use HTTP::Cookies;


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                             Symbols
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#Program name
my $_pn = 'client';

#---- Pre-compiled regular expression ----#
#Regular expression to extract headers and body
my $_re_header = qr/^status=(.*)\nmessage=(.*)\n/;
my $_re_body = qr/^(.|\n)*?\n\n((.|\n)*)$/m;
my $_re_jobid = qr/^jobid=(.+)\n/;

#Regular expression to extract filename from path
my $_re_file = qr/(.*\/)?(.+)/;



# ############################################################################ #
#                        Prototypes
# ############################################################################ #


# ############################################################################ #
#                        Program core
# ############################################################################ #

# **************************************************************************** #
#                   Speech processing functions
# **************************************************************************** #

# ============================================================================ #
# Login
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - login: login
#   - passwd: password
#
# Return:
#   - (status, message)
# ============================================================================ #
sub Login
{
    #---- Parameters ----#
    my ($ua, $uri, $login, $passwd) = @_;

    #---- Variables ----#
    my %params;


    #Set the POST parameters
    $params{function} = 'login';
    $params{username} = $login;
    $params{password} = $passwd;
    PrintHash(\%params);

    #HTTP request
    return SplitResponse($ua->post($uri, Content => [%params]));
}

# ============================================================================ #
# Logout
#
# Input:
#   - ua: user agent
#   - uri: resource
#
# Return:
#   - (status, message)
# ============================================================================ #
sub Logout
{
    #---- Parameters ----#
    my ($ua, $uri) = @_;


    #HTTP request
    return SplitResponse($ua->post($uri, Content => [ function => 'logout']));
}

# ============================================================================ #
# Upload local file
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - path: file path to upload
#   - filename: filename to send to the server
#
# Return:
#   - Status returned by 'SplitResponse' function
# ============================================================================ #
sub Upload
{
    #---- Parameters ----#
    my ($ua, $uri, $path, $filename) = @_;


    return SplitResponse($ua->post($uri,
				Content_Type => 'form-data',
				Content =>
				[
				 function => 'upload',
				 filename => [$path, $filename]
				]));
}

# ============================================================================ #
# Delete audio file
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - filename: filename
#
#
# Return:
#   - (status, message)
# ============================================================================ #
sub Delete
{
    #---- Parameters ----#
    my ($ua, $uri, $filename) = @_;

    #---- Variables ----#
    my %params;


    #Set the POST parameters
    $params{function} = 'delete';
    $params{filename} = $filename;
    PrintHash(\%params);

    #HTTP request
    return SplitResponse($ua->post($uri, Content => [%params]));
}

# ============================================================================ #
# Audio Transcription
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - filename: filename or URL
#   - type: audio type (cts, bn)
#   - language: (optional) default: invokes the language identification
#                          to identify the language
#   - channel: (optional) channel number 1 (left) or 2 (right), default: 1
#   - quality: (optional) 0 -> regular baseline, 1 -> fast, default: 0
#   - duration: (optional) duration to transcribe in seconds,
#                          default: all the file
#
# Return:
#   - (status, message, jobid)
# ============================================================================ #
sub Trans
{
    #---- Parameters ----#
    my ($ua, $uri,
	$filename, $type, $language, $channel, $quality, $duration) = @_;

    #---- Variables ----#
    my ($status, $msg, $jobid);
    my %params;


    #Set the POST parameters
    $params{function} = 'trans';
    $params{filename} = $filename;
    $params{type} = $type;
    $params{language} = $language if (defined($language));
    $params{channel} = $channel if (defined($channel));
    $params{quality} = $quality if (defined($quality));
    $params{duration} = $duration if (defined($duration));
    PrintHash(\%params);

    #HTTP request
    ($status, $msg, $jobid) =
	SplitResponse($ua->post($uri, Content => [%params]));

    #Extract the jobid
    $jobid = ExtractJobId($jobid);

    return ($status, $msg, $jobid);
}

# ============================================================================ #
# Audio partioner
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - filename: filename or URL
#   - type: audio type (cts, bn)
#   - channel: (optional) channel number 1 (left) or 2 (right), default: 1
#   - speakers: (optional) maximal number of speakers, default: 1
#
# Return:
#   - (status, message, jobid)
# ============================================================================ #
sub Part
{
    #---- Parameters ----#
    my ($ua, $uri, $filename, $type, $channel, $speakers) = @_;

    #---- Variables ----#
    my ($status, $msg, $jobid);
    my %params;


    #Set the POST parameters
    $params{function} = 'part';
    $params{filename} = $filename;
    $params{type} = $type;
    $params{channel} = $channel if (defined($channel));
    $params{speakers} = $speakers if (defined($speakers));
    PrintHash(\%params);


    #HTTP request
    ($status, $msg, $jobid) =
	SplitResponse($ua->post($uri, Content => [%params]));

    #Extract the jobid
    $jobid = ExtractJobId($jobid);

    return ($status, $msg, $jobid);
}

# ============================================================================ #
# Audio language identification
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - filename: filename or URL
#   - type: audio type (cts, bn)
#   - offset: (optional) offset in seconds (cts, bn)
#   - duration: (optional) duration to transcribe in seconds,
#                          default: all the file
#
# Return:
#   - (status, message, jobid)
# ============================================================================ #
sub Lid
{
    #---- Parameters ----#
    my ($ua, $uri, $filename, $type, $offset, $duration) = @_;

    #---- Variables ----#
    my ($status, $msg, $jobid);
    my %params;


    #Set the POST parameters
    $params{function} = 'lid';
    $params{filename} = $filename;
    $params{type} = $type;
    $params{offset} = $offset if (defined($offset));
    $params{duration} = $duration if (defined($duration));
    PrintHash(\%params);

    #HTTP request
    ($status, $msg, $jobid) =
	SplitResponse($ua->post($uri, Content => [%params]));

    #Extract the jobid
    $jobid = ExtractJobId($jobid);

    return ($status, $msg, $jobid);
}

# ============================================================================ #
# Cancel a job
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - jobid: job id
#
# Return:
#   - (status, message)
# ============================================================================ #
sub Cancel
{
    #---- Parameters ----#
    my ($ua, $uri, $jobid) = @_;

    #---- Variables ----#
    my %params;


    #Set the POST parameters
    $params{function} = 'cancel';
    $params{jobid} = $jobid;
    PrintHash(\%params);

    #HTTP request
    return SplitResponse($ua->post($uri, Content => [%params]));
}

# ============================================================================ #
# Get the transcription result given a jobid
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - jobid: job id
#
# Return:
#   - XML transcription
# ============================================================================ #
sub Result
{
    #---- Parameters ----#
    my ($ua, $uri, $jobid) = @_;

    #---- Variables ----#
    my %params;


    #Set the POST parameters
    $params{function} = 'result';
    $params{jobid} = $jobid;
    PrintHash(\%params);

    #HTTP request
    return SplitResponse($ua->post($uri, Content => [%params]));
}

# ============================================================================ #
# Get job status
#
# Input:
#   - ua: user agent
#   - uri: resource
#   - jobid: (optional) job identifier
#
# Return:
#   - [ [jobid, type, state, starttime, elapsedtime, progress], ...]
# ============================================================================ #
sub Status
{
    #---- Parameters ----#
    my ($ua, $uri, $jobid) = @_;

    #---- Variables ----#
    my %params;
    my ($status, $msg, $body);
    my ($line, @joblist, $i);


    #Set the POST parameters
    $params{function} = 'status';
    $params{jobid} = $jobid if (defined($jobid));
    PrintHash(\%params);

    #HTTP request
    ($status, $msg, $body) =
	SplitResponse($ua->post($uri, Content => [%params]));

    #$status = 0;
    #$msg = 'OK';
    #$body =
	#"Jobid Type State StartTime ElapsedTime Progress\n" .
	#"101.msf01 trans R 20:00:00 00:21:00 10\n";

    $i = 0;
    foreach $line (split('\n', $body)) {
	#Skip first line (field names)
	if ($i == 0) { $i = 1; next; }
	push(@joblist, [split(/\s/, $line)]);
    }

    return ($status, $msg, \@joblist);
}


# **************************************************************************** #
#            Useful functions used by speech processing functions
# **************************************************************************** #

# ============================================================================ #
# Split the HTTP response
#
# Input:
#   - response: HTTP response
#
# Return:
#   - (status, message, body)
# ============================================================================ #
sub SplitResponse
{
    #---- Parameters ----#
    my ($response) = @_;

    #---- Variables ----#
    my (@lines, $status, $msg, $body);


    #Undefined HTTP response
    return (-1, '', '') if (!defined($response));

    print STDERR 'http response = [' . $response->content . "]\n";

    $status = 0;
    $msg = $body = '';
    if ($response->is_success()) {
	#Header : status and message error
	if ($response->content =~ $_re_header) {
	    ($status, $msg) = ($1, $2);

	    #Body
	    $body = $2 if ($response->content =~ $_re_body);

	    return ($status, $msg, $body);
	}

	#Application protocol error
	return (-1, '', '');
    }

    #HTTP error
    return (-2, $response->status_line, $body); 
}

# ============================================================================ #
# Extract the jobid from the HTTP response
#
# Input:
#   - $response: HTTP body response
#
# Return:
#   - jobid or -1 if error
# ============================================================================ #
sub ExtractJobId
{
    #---- Parameters ----#
    my ($response) = @_;

    #---- Variables ----#
    my $jobid;


    if ($response =~ $_re_jobid) { $jobid = $1; }
    else { $jobid = -1; }

    return $jobid;
}

# ============================================================================ #
# Print hash (used only for debug)
#
# Input:
#   - hash: hash table
#
# Return:
#   - Nothing
# ============================================================================ #
sub PrintHash
{
    #---- Parameters ----#
    my ($hash) = @_;


    foreach my $key (keys %$hash) {
	print STDERR "$key => $hash->{$key}\n";
    }
    print STDERR "\n";
}


# **************************************************************************** #
#                       Transcription session
# **************************************************************************** #

# ============================================================================ #
# Transcription session
#
# Input:
#   - Audio filename
#
# Return:
#   - 0: success
#   - else: failed
# ============================================================================ #
sub TransSession
{
    #---- Parameters ----#
    my ($path) = @_;

    #---- Variables ----#
    my ($ua, $agent, $uri, $filename, $status, $msg, $body, $logout);
    my ($jobid, $job, $joblist, $trs);


    #Initializations
    $agent = 'transcriber_agent';
    $uri = 'http://10.0.0.1/msse/index.php';
    $logout = 1;

    binmode(STDOUT, ":encoding(utf8)");

    #Check the path format and extract the file name
    if ($path =~ $_re_file) {
	$filename = $2;
    }
    else {
	print STDERR "invalid file format '$path'\n";
	return -3;
    }


    print STDERR "URI = $uri\n";


    #Transcription block
  TRANS: {
      #Create the user agent
      $ua = LWP::UserAgent->new(
	agent => $agent,
	cookie_jar => HTTP::Cookies->new()) or
	((print STDERR "can't create user agent\n"), $logout = 0, last);

      #Authentification
      print STDERR "\n====>$_pn: login\n";
      ($status, $msg, $body) = Login($ua, $uri, 'Your Login', 'Your Password');
      print STDERR "$_pn: status=$status, message='$msg', body='$body'\n";
      $logout = 0, last if ($status);

      #Cancel
      if (0) {  #<<<<
      $jobid = '383.msf01';
      print STDERR "\n====>$_pn: cancel job '$jobid'\n";
      ($status, $msg) = Cancel($ua, $uri, $jobid);
      print STDERR "$_pn: status=$status, message='$msg'\n";
      return;
      }  #<<<<

      #Delete audio file (don't work on the server)
      if (0) {  #<<<<
      print STDERR "\n====>$_pn: delete audio file '$filename'\n";
      ($status, $msg) = Delete($ua, $uri, $filename);
      print STDERR "$_pn: status=$status, message='$msg'\n";
      return;
      }  #<<<<

      #Upload the audio file
      if (0) {  #<<<<
      print STDERR "\n====>$_pn: upload\n";
      ($status, $msg) = Upload($ua, $uri, $path, $filename);
      print STDERR "$_pn: status=$status, message='$msg'\n";
      last if ($status);
      }  #<<<<

      #Transcribe the audio file
      print STDERR "\n====>$_pn: trans\n";
      ($status, $msg, $jobid) =
	  Trans($ua, $uri, $filename, 'cts', 'fre', 1, 0, 30);
      print STDERR "$_pn: status=$status, message='$msg', job='$jobid'\n";
      last if ($status);

      #Wait for the end of transcription
      print STDERR "\n====>$_pn: wait for the end of transcription\n";
      while (1) {
	  ($status, $msg, $joblist) = Status($ua, $uri, $jobid);
	  #Error status
	  last TRANS if ($status);
	  #last if (! defined($joblist) || !defined($joblist->[0]) ||
		   #!defined($joblist->[0][2]) || ($joblist->[0][2] eq 'E'));
	  sleep 5;
      }

      #Get the result
      print STDERR "\n====>$_pn: get the transcription result\n";
      ($status, $msg, $trs) = Result($ua, $uri, $jobid);
      print STDERR "$_pn: status=$status, message='$msg'\n";
      print $trs;

    }  #end of TRANS block

    #Logout
    if ($logout) {
	print STDERR "\n====>$_pn: logout\n";
	($status, $msg) = Logout($ua, $uri);
	print STDERR "$_pn: status=$status, message='$msg'\n";
    }

    return $status;
}


#Do the transcription
my $status =
  TransSession('/projects/current/msf/audio/PKCTS05_FRE_FR_0000166489_04.wav');
