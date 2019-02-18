#!/usr/bin/perl

# History
# MLM : take account new LIMSI format 
# EB : set time Dur at 0 after print segment

use strict;

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
	$hdur = sprintf("%02d:%02d:%02d,%03d",
		     $sec / 3600, $min / 60, $min % 60,$msec);
    }

    #Duration in seconds
    else {
	$min = $dur % 3600;
	$hdur = sprintf("%02d:%02d:%02d,000",
			$dur / 3600, $min / 60, $min % 60);
    }

    #Return human readable duration
    return($hdur);
}

my $timeDur = .0;
my $content = "";
my $timeStart = 0.0;
my $timeEnd = 0.0;
my $count=1;
my $language;

while(<>)
{
    chomp:
#    print $_;
#<SpeechSegment ch="1" sconf="1.00" stime="4.71" etime="45.65" spkid="FS1" lang="fre" lconf="1.00" trs="1">
    
    if(/<SpeechSegment[^>]+lang=\"([^\"]+)\"[^>]+>/)
    {
      $language= $1;      
    }
    
    if(/<Word stime=\"([^\"]+)\" dur=\"([^\"]+)[^>]+>([^<]+)/)
    {
        $timeEnd = $1+$2;
        $timeDur=$timeEnd - $timeStart+$3;
        my $word = $3;
        $word=~s/^\s+//;
        $word=~s/\s+$//;
        if ($language eq 'ara')
        {
          $content =" $word ".$content;
        }
        else
        {
          $content.="$word ";
        }
    }
      
    if ($timeDur > 2.50)
    {
        print "$count\n";
        my @millistart = ($timeStart * 1000,"ms");
        my @milliend = ($timeEnd * 1000,"ms");
        print HumDur(@millistart)." --> ".HumDur(@milliend)."\n";
        print "$content\n\n";
        $content="";
        $timeStart=$timeEnd;
        $count++;
        $timeDur = 0;
    }
    
}
print "\n$count\n";
print HumDur($timeStart)." --> ".HumDur($timeEnd)."\n";
print "$content\n";
