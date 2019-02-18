#!/usr/bin/perl
#Package

use strict;
use warnings;

package lib_msf;


if (! defined($ENV{OPT_SCRIPTS}))
{
  use lib "/home/MSF/development/www/scripts/";
  use lib_utils;
  print STDERR "libmsf librairie chemin par défaut ->developpement\n";
}
else
{
print STDERR "opt_script=".$ENV{OPT_SCRIPTS}."\n";
  use lib $ENV{OPT_SCRIPTS};
  use lib_utils;
  print STDERR "libmsf librairie chemin VAR_ENV = $ENV{OPT_SCRIPTS}\n";
}


use DBI;
use Email::Valid; 
use MIME::Lite;
use LWP::UserAgent;
use HTTP::Cookies;
use File::Basename qw(basename);
use Crypt::SSLeay;
use XML::LibXML;



our $MSF_AUDIO_PATH   ;
our $LOCAL_AUDIO_PATH ;
our $LOCAL_RESULT_PATH;
our $DoOptimize    ;
our $MaxThread     ;
our $StreamId      ;
our $ChannelId    ;
our $ProcessEndingResultMode   ;
our $DeleteTempFiles ;
our $bStereo=0;
our $FileFrequency;
    

my ($dbh, $sth, $rv, $statement, $hash_ref); # base de données
my ($FileSize, $FileDuration);
my ($fh, $line);




# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Exportations
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

require Exporter;
our @ISA  = qw(Exporter);

our @EXPORT =
    qw(UpdateEnvironment  
        CallbackUrl 
        CallbackErrorUrl 
        CallbackResult 
        SendProcessCompletionEmail
        UpdateProcessesField 
        GetHostId
        UpdateRunningInfos
        UpdateRunningInfos2
        UpdateRunningInfos3
        UpdateAudioFileInfo
        UpdateErrorMessage 
        DB_Connect      
        DB_DisConnect    
        UpdateXmlDateStart  
        TraitementFin
        TraitementFinTraduction
        SendEmail
        UpdateAudioSpeakerDuration
        ConvertAudioFile
        BuildCommandLineArguments
        MulticastResult
        PrintDate
        GpgDecryptFile    
        GpgCryptFile
        GetExtention    
        UploadUrlFile
        GetDate
        GetRunnerName
        CopyAudioFileOnRunner
        DeleteTmpAudioFiles
        XmlGetSpeakerQuantity
        PbsQsub
        StartAudioProcessing
        XmlSPlitXmlBySpeaker
        MergeXmlFiles
        AppendRunnerFile
        DB_GetSpeakerInfo
        DB_WaitForProcessInfo
        UpdateProcessesCompletionInfos
        UpdateJobIdChildren
        $MSF_AUDIO_PATH   
        $LOCAL_AUDIO_PATH 
        $LOCAL_RESULT_PATH
        $DoOptimize    
        $MaxThread     
        $bStereo
        $StreamId
        $ChannelId
        $DeleteTempFiles
        $ProcessEndingResultMode
        $FileFrequency
        );

our @EXPORT_OK =
   qw(UpdateEnvironment  
        CallbackUrl 
        CallbackErrorUrl 
        CallbackResult 
        SendProcessCompletionEmail
        UpdateProcessesField 
        GetHostId
        UpdateRunningInfos
        UpdateRunningInfos2
        UpdateRunningInfos3
        UpdateAudioFileInfo
        UpdateErrorMessage 
        DB_Connect      
        DB_DisConnect    
        UpdateXmlDateStart
        TraitementFin
        TraitementFinTraduction  
        SendEmail
        UpdateAudioSpeakerDuration
        ConvertAudioFile
        BuildCommandLineArguments
        MulticastResult
        PrintDate
        GpgDecryptFile    
        GpgCryptFile
        GetExtention    
        UploadUrlFile
        GetDate
        GetRunnerName
        CopyAudioFileOnRunner
        DeleteTmpAudioFiles
        XmlGetSpeakerQuantity
        PbsQsub
        StartAudioProcessing
        XmlSPlitXmlBySpeaker
        MergeXmlFiles
        AppendRunnerFile
        DB_GetSpeakerInfo
        DB_WaitForProcessInfo
        UpdateProcessesCompletionInfos
        UpdateJobIdChildren
        );

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #
#                            Fonctions
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

sub UpdateEnvironment()
{
  $MSF_AUDIO_PATH      = $ENV{'PATH_AUDIOFILES'};
  $LOCAL_AUDIO_PATH    = "/Audio/";
  $LOCAL_RESULT_PATH   = $ENV{'PATH_RESULTFILES'};

  # on regarde si on va optimiser la trans en faisant un part et en trouvant le nombre
  #de locuteurs et en lançant trans avec autant de thread que de locuteurs    
  $DoOptimize          = $ENV{'DO_OPTIMIZE'};
  $MaxThread           = 1; # max 1 thread par défaut

  # si >0 on a un mode flux de données   
  $StreamId             = $ENV{'STREAMID'};
  $ChannelId            = $ENV{'CHANNELID'};
  $bStereo              = 0;
  
  $ProcessEndingResultMode  = 'Xml';
  
  #================== Variables d'environnement PBS ============
  if ($ENV{AUDIOTYPE} eq "cts" )
  {
    $ENV{'VRCTS_TMP'}     = "/usr/tmp"; 
    $ENV{'VRCTS_ROOT'}    = "/usr/local/vrcts";
    $ENV{'VRCTS_BIN'}     = $ENV{'VRCTS_ROOT'}."/bin"; 
    $ENV{'VRCTS_PART'}    = $ENV{'VRCTS_ROOT'}."/part";
    $ENV{'VRCTS_LID'}     = $ENV{'VRCTS_ROOT'}."/lid"; 
    $ENV{'VRCTS_TRANS'}   = $ENV{'VRCTS_ROOT'}."/trans";
    $ENV{'PATH'}          = $ENV{'PATH'}.":".$ENV{'VRCTS_BIN'}; 
  }
  elsif ($ENV{AUDIOTYPE} eq "ccs" )
  {
    $ENV{'VRCCS_TMP'}     = "/usr/tmp"; 
    $ENV{'VRCCS_ROOT'}    = "/usr/local/vrccs";
    $ENV{'VRCCS_BIN'}     = $ENV{'VRCCS_ROOT'}."/bin"; 
    $ENV{'VRCCS_PART'}    = $ENV{'VRCCS_ROOT'}."/part";
    $ENV{'VRCCS_LID'}     = $ENV{'VRCCS_ROOT'}."/lid"; 
    $ENV{'VRCCS_TRANS'}   = $ENV{'VRCCS_ROOT'}."/trans";
    $ENV{'PATH'}          = $ENV{'PATH'}.":".$ENV{'VRCCS_BIN'}; 
  }
  else
  {
    $ENV{'VRBS_TMP'}      = "/usr/tmp"; 
    $ENV{'VRBS_ROOT'}     = "/usr/local/vrbs";
    $ENV{'VRBS_BIN'}      = $ENV{'VRBS_ROOT'}."/bin"; 
    $ENV{'VRBS_PART'}     = $ENV{'VRBS_ROOT'}."/part";
    $ENV{'VRBS_LID'}      = $ENV{'VRBS_ROOT'}."/lid"; 
    $ENV{'VRBS_TRANS'}    = $ENV{'VRBS_ROOT'}."/trans";
    $ENV{'PATH'}          = $ENV{'PATH'}.":".$ENV{'VRBS_BIN'}; 
  }
  $DeleteTempFiles = 1;
  $ENV{'PATH'}          = $ENV{'PATH'}.":".$ENV{'PATH_PBS'}; 
  $ENV{'PATH'}          = $ENV{'PATH'}.":".$ENV{'PATH_SLURM'}; 

  # on cree le repertoire pour le client
  my $sCmd = "mkdir -p $LOCAL_AUDIO_PATH$ENV{IDUSER}";
  print STDERR "\n$sCmd" ;
  lib_utils::Run ( $sCmd );
  
  # on cree le repertoire de résultat au cas où pour le client
  $sCmd = "mkdir --mode=777 -p $LOCAL_RESULT_PATH";
  print STDERR "\n".$sCmd ;
  lib_utils::Run ( $sCmd );
  
  # on cree le repertoire audio au cas où pour le client
  $sCmd = "mkdir --mode=777 -p $MSF_AUDIO_PATH";
  print STDERR "\n".$sCmd ;
  lib_utils::Run ( $sCmd );
  
  print STDERR "\n" ;

  # on modifie le job id pour supprimer la référence à msf01.msf.lan $ENV{PBS_JOBID}
  my $JobId=$ENV{PBS_JOBID};
  my @Tmp = split(/\./, $JobId);

  $ENV{PBS_JOBID}=$Tmp[0];
  print STDERR ">>>>>> JobId=$ENV{PBS_JOBID}\n" ;

}  
  
  #******************************************************************************
  #******************************************************************************
  sub AppendRunnerFile 
  {
    my ($ResultPath, $MainJobId, $MyJobId, $RunnerName) = @_;
    my $fs_output;
    
    open($fs_output, ">>", "$ResultPath/$MainJobId.runner")
        or Log(0, "can't open output file '$ResultPath/$MainJobId.runners' <$!>\n" ), return -1;
    
    print $fs_output "$MyJobId:$RunnerName\n";
    
    close($fs_output) ;
  }

  #------------------------------------------------------------------------------
  # mise en forme de la ligne de commande du moteur de transcription
  #------------------------------------------------------------------------------
  sub BuildCommandLineArguments
  {
    my ($JobId) = @_;
    
     my $ARGS="";
    
    if ( defined($ENV{QUALITY}) )
    {
      $ARGS="-q".$ENV{QUALITY};
    }
    
    if ( defined($ENV{LANGUAGE}) )
    {
      $ARGS= $ARGS . " -l:".$ENV{LANGUAGE};
      
      #on regarde si on doit utiliser une version particulière ou un corpus spécifique
      if ( defined($ENV{CORPUS}))
      {
        $ARGS= $ARGS . "_".$ENV{CORPUS};
        
      }
      #UpdateProcessesField ($JobId, "ExecLanguage",$ENV{LANGUAGE}); #fre, eng ...
    }
    
    # ne sert que pour CTS et CCS pas BN
    if ( ( defined($ENV{CHANNEL})) && (($ENV{AUDIOTYPE} eq "cts" ) || ($ENV{AUDIOTYPE} eq "ccs" )))
    {
      $ARGS=$ARGS . " -n".$ENV{CHANNEL};
    }

    #indice de progression
    if ( defined($ENV{PATH_TMPFILES}))
    {
      my $TmpFileName = $ENV{PATH_TMPFILES}."/$JobId.ind";

      #crée le fichier .ind
      my $sCmd ="touch $TmpFileName";
      print STDERR "$sCmd\n" ;
      lib_utils::Run ( $sCmd );

      $ARGS=$ARGS . " -pf".$TmpFileName;
    }
    
    
    #test pour le chemin d'accès au logiciel
    my $TYPE;
    if ($ENV{AUDIOTYPE} eq "cts" )
    {
      $TYPE="vrcts";
    }
    elsif ($ENV{AUDIOTYPE} eq "ccs" )
    {
      $TYPE="vrccs";
    }
    else
    {
      $TYPE="vrbs";
    }  
  
    if ( defined($ENV{DURATION}) )
    {
      if ($ENV{DURATION} =~ /\p{Nd}/)
      {
        $ARGS=$ARGS . " -d".$ENV{DURATION};
      }
    }
    return ($ARGS, $TYPE);
  }  

  #******************************************************************************
  # on appelle un site web avec des arguments, sert à rendre asynchrone le 
  # fonctionnement 
  #******************************************************************************
  sub CallbackUrl
  {
    my ($JobId, $Status) = @_;
    my $sCmd ;

      # on regarde si on doit remettre dans l'ordre les résultats, si oui on n'appelle
      # pas la callback du client ici c'est CallbackStream.php qui le fera au moment voulu
      if (defined($StreamId) && ($StreamId>=0) && ($ENV{'STREAMMODE'} == 2))
      {
        $sCmd = "wget -T 15 --no-check-certificate --waitretry=5 --wait=5 -O /tmp/poub --no-check-certificate '".$ENV{'CALLBACKURLSTREAMS'}."?StreamId=$StreamId&JobId=$JobId'";
        print STDERR "$sCmd\n" ;
        lib_utils::Run ( $sCmd );
      
      }
      elsif (defined($ENV{CALLBACKURL}))
      {
        my $pos = rindex $ENV{CALLBACKURL}, "?";
        
        if ($pos == -1 )
        { #pas de paramètres dans la callback
          if (defined($StreamId) && ($StreamId>=0))
          {
            $sCmd = "wget -T 10 --no-check-certificate --waitretry=5 --wait=5  -O /tmp/poub --no-check-certificate '$ENV{'CALLBACKURL'}?StreamId=$StreamId&JobId=$JobId&Status=$Status'";
          } 
          else
          {
            $sCmd = "wget -T 10 --no-check-certificate --waitretry=5 --wait=5  -O /tmp/poub --no-check-certificate '$ENV{'CALLBACKURL'}?JobId=$JobId&Status=$Status'";
          } 
        }
        else
        {#si il y a déjà des paramètres dans la callback
          if (defined($StreamId) && ($StreamId>=0))
          {
            $sCmd = "wget -T 10 -O /tmp/poub --no-check-certificate --waitretry=5 --wait=5  --no-check-certificate '$ENV{'CALLBACKURL'}&StreamId=$StreamId&JobId=$JobId&Status=$Status'";
          } 
          else
          {
            $sCmd = "wget -T 10 -O /tmp/poub --no-check-certificate --waitretry=5 --wait=5   --no-check-certificate '$ENV{'CALLBACKURL'}&JobId=$JobId&Status=$Status'";
          } 
        }

        print STDERR "$sCmd\n" ;
        lib_utils::Run ( $sCmd );
      }
  }
  
  #******************************************************************************
  # on appelle un site web avec des arguments, sert à rendre asynchrone le 
  # fonctionnement 
  #******************************************************************************
  sub CallbackErrorUrl
  {
    my ($JobId, $Command, $ErrorCode) = @_;

      if (defined($ENV{CALLBACKURL}))
      {
        my $pos = rindex $ENV{CALLBACKURL}, "?";
        my $sCmd ;
        
        if ($pos == -1 )
        { #pas de paramètres dans la callback
          if (defined($StreamId) && ($StreamId>=0))
          {
            $sCmd = "wget -T 10 --no-check-certificate --waitretry=5 --wait=5  -O -  --no-check-certificate '$ENV{'CALLBACKURL'}?StreamId=$StreamId&JobId=$JobId&Command=$Command&ErrorCode=$ErrorCode'";
          }
          else
          {
            $sCmd = "wget -T 10 --no-check-certificate --waitretry=5 --wait=5  -O -  --no-check-certificate '$ENV{'CALLBACKURL'}?JobId=$JobId&Command=$Command&ErrorCode=$ErrorCode'";
          }
        
        }
        else
        { #si il y a déjà des paramètres dans la callback
          if (defined($StreamId) && ($StreamId>=0))
          {
            $sCmd = "wget -T 10 --no-check-certificate --waitretry=5 --wait=5  -O -  --no-check-certificate '$ENV{'CALLBACKURL'}&StreamId=$StreamId&JobId=$JobId&Command=$Command&ErrorCode=$ErrorCode'";
          }
          else
          {
            $sCmd = "wget -T 10 --no-check-certificate --waitretry=5 --wait=5  -O -  --no-check-certificate '$ENV{'CALLBACKURL'}&JobId=$JobId&Command=$Command&ErrorCode=$ErrorCode'";
          }
        }

        print STDERR "$sCmd\n" ;
        lib_utils::Run ( $sCmd );
      }
  }

  
  
  #******************************************************************************
  # envoie le résultat avec la callback que si on a un stream !
  #******************************************************************************
  sub CallbackResult
  {
    my ($JobId) = @_;

      if (defined($ENV{CALLBACKURL}))
      {
        if (defined($StreamId) && ($StreamId>=0))
        {
          my $pos = rindex $ENV{CALLBACKURL}, "?";
          my ($ua, $agent);
          my ($response);

          # si on a un flux on met à jour une ligne date du flux
          UpdateXmlDateStart($JobId);

          $agent = 'MSF';
          
          $ua = LWP::UserAgent->new(agent => $agent,
                    cookie_jar => HTTP::Cookies->new()) or
                    ((print STDERR "can't create user agent\n"));
                    
          $response = $ua->post($ENV{'CALLBACKURL'},
                  Content_Type => 'form-data',
                  Content =>
                  [
                   StreamId => $StreamId,
                   filename => ["$LOCAL_RESULT_PATH/$JobId.xml", "$JobId.xml"]
                  ]);
          print STDERR "Resultat de la callbac : \n";
          print STDERR $response->content ;          
          
          print STDERR "\nSuppression du fichier audio d'origine \n";
          
          #on supprime les données audio sur disque dans /home/MSF/Audio ...
          DeleteTmpAudioFiles($MSF_AUDIO_PATH);
        }
      }
  }

  #******************************************************************************
  # *  
  #******************************************************************************
  sub ConvertAudioFile
  {
    my ($AudioFilename, $filetype, $SplitStereo) = @_;
    
    #on regarde si on a un fichier wav  
    my $bIsWAV;

    my $bOK=1;

   #opn regarde si on a un fichier ALAW
    if (uc($filetype) eq "AL")
    {
      $FileFrequency = 8000;
      my $cmd = "/home/MSF/bin/vplay -ealaw $AudioFilename -o | /home/MSF/bin/vrecord -i -t0 -r8000 -wav $AudioFilename.wav";
      print STDERR "Commande = ".$cmd."\n";
      if (lib_utils::Run ($cmd) ==0)
      {
        print STDERR "vplay a bien fait son travail ;)\n";
        
        $AudioFilename = $AudioFilename.".wav";
        return ($bOK, $AudioFilename);
      }
      else
      {
        print STDERR "vplay ERROR \n";
        #on sort du scrypt, bizarre mais de tt façon ça décharge les scrypts appelants
        TraitementFin($ENV{PBS_JOBID}, '', '', 1018);
        exit(1018);
      }
     
    }
    elsif (uc($filetype) eq "WAV")
    {
      $bIsWAV = 1;
    }
    else
    {
      $bIsWAV = 0;
    }
       
    # on convertit le format audio en WAV, et le WAV en WAV PCM ;)
    my $cmd;

    my $MplayerOption ;
    my $Channels = 1;
    if ($SplitStereo eq 1)
    {
      $Channels = 2;
      print STDERR " $Channels à traiter\n"
    }   


    my ($counter, $Name);
    $MplayerOption = "";
    for($counter = 0; $counter < $Channels; $counter++)
    {
      if (uc($filetype) eq "RAW")
      {
        $MplayerOption = " -demuxer rawaudio -rawaudio rate=16000:samplesize=2:channels=1 "; 
      }

      print STDERR "LOOP : $counter < $Channels \n";
      if ($SplitStereo eq 1)
      {
        $MplayerOption .= " -af channels=2:1:$counter:0:0 ";
      }     
      
#ffmpeg
# -ac 1 : met sur un channel
#$cmd = "/usr/bin/ffmpeg -i $AudioFilename -vn -acodec pcm_s16le -ar 16000  -f wav -y $AudioFilename.tmp.wav";      
  #    $cmd = "/usr/bin/mplayer  -really-quiet  -nocorrect-pts -identify -vc null -vo null -ao pcm:file=$AudioFilename.tmp.wav $AudioFilename 2>&1 |";
      $cmd = "/usr/bin/mplayer $MplayerOption -identify -nocorrect-pts -benchmark -vc null -vo null -ao pcm:fast -ao pcm:file=\"$AudioFilename.tmp.wav\" \"$AudioFilename\" 2>&1 |";
      
      print STDERR "Commande = $cmd \n";
      
      my $CountSeekFailed=0;
      my $_reg_Infos;
      my $pid = open($fh, $cmd) or print STDERR " ERROR opening audio file ".$!;

      my $FileChannelQt;
      while ($line =  <$fh>) 
      { 
        # test de message d'erreur qui fait boucler mplayer en rond
        if ( grep (/Seek failed/, $line) )
        {
          $CountSeekFailed ++;
        }
        else
        {
        #AUDIO: 44100 Hz, 2 ch, s16le, 192.0 kbit
          $_reg_Infos = qr/^AUDIO: (.+) Hz, (.+) ch, (.+), (.+) kbit(.+)\n/;
          if ($line =~ $_reg_Infos) 
          {
            $FileFrequency = $1;
            $FileChannelQt = $2;
            #print STDERR ">>>>>>>>>>>>>>>>>>>>>Infos = $1 $2 $3 $4 \n";
          }

        }
        
        if ( $CountSeekFailed > 10)
        {
          print STDERR "mplayer ERROR CountSeekFailed\n";
          $bOK=0;
          last;
        }
  
        if ( grep (/Unsupported audio codec/, $line) )
        {
          print STDERR "mplayer ERROR Unsupported audio code\n";
          $bOK=0;
          last;
        }
        
        print STDERR $line;
      }
      close $fh;

print STDERR "*****************mplayer******************\n";



      if ( $bOK == 0)
      { # il y a eu un problème avec mplayer
          #on sort du scrypt, bizarre mais de tt façon ça décharge les scrypts appelants
          print STDERR "mplayer ERROR reading file\n";
          TraitementFin($ENV{PBS_JOBID}, '', '', 1018);
          exit(1018);
      }
#printf STDERR "************************************************************************\n";      
#printf STDERR " FICHIERS PAS SUPPRIMES \n";
#$DeleteTempFiles = 0;
          
      $cmd = "";
      #on rééchantillonne l'audio
      if (($ENV{AUDIOTYPE} eq "cts" ) || ($ENV{AUDIOTYPE} eq "ccs" ))
      {                                 #FOR CTS TESTS
        if (($FileFrequency != 8000) || ($FileChannelQt != 1 ))
        {
          if (!defined($ENV{AUDIOCHANNELS}))
          {
            $ENV{AUDIOCHANNELS} = 1;
          }
          if ($SplitStereo eq 1)
          {
            #toujours le canal 1 quand on fait cela
            $cmd =  "$ENV{PATH_VECSYS_TRANS}/bin/vtk_sox \"$AudioFilename.tmp.wav\" -b 16 -c 1 -r 8000 \"$AudioFilename.wav\" ";
          }
          else
          {
            if ($ENV{AUDIOCHANNELS} eq 0)
            {
              $ENV{AUDIOCHANNELS} = 1;
            }
            $cmd =  "$ENV{PATH_VECSYS_TRANS}/bin/vtk_sox \"$AudioFilename.tmp.wav\" -b 16 -c $ENV{AUDIOCHANNELS} -r 8000 \"$AudioFilename.wav\" ";
          }
        }
        else
        {
          if ($SplitStereo eq 1)
          {
            $cmd = "$ENV{PATH_VECSYS_TRANS}/bin/vtk_sox -D \"$AudioFilename.tmp.wav\" -b 16 -c 1 -r 16000 \"$AudioFilename.wav\" rate -L -v";
          }
        }
      }
      else
      {
        if (($FileFrequency != 16000) || ($FileChannelQt != 1 ))
        {
          #polyphase ne fonctionne pas du tout !!! si bitrate src = bitrate dest
          #$cmd = "sox \"$AudioFilename.tmp.wav\" -c 1 -r 16000 \"$AudioFilename.wav\" polyphase";
          #$cmd = "sox \"$AudioFilename.tmp.wav\" -c 1 -r 16000 \"$AudioFilename.wav\" resample -ql";
          #$cmd = "sox \"$AudioFilename.tmp.wav\" -c 1 -r 16000 \"$AudioFilename.wav\" resample -qs";
          #$cmd = "sox \"$AudioFilename.tmp.wav\" -c 1 -r 16000 \"$AudioFilename.wav\" ";
          $cmd = "$ENV{PATH_VECSYS_TRANS}/bin/vtk_sox -D \"$AudioFilename.tmp.wav\" -b 16 -c 1 -r 16000 \"$AudioFilename.wav\" rate -L -v";
        }
      }
      if ($cmd eq "")
      {
        print STDERR "Format audio deja bon : Freq=$FileFrequency channel=$FileChannelQt";
        rename( "$AudioFilename.tmp.wav", $AudioFilename.".wav");
      }
      else
      {
        print STDERR "Commande = ".$cmd."\n";
        my $Ret = lib_utils::Run ($cmd);
        if ($Ret == 0)
        {
          print STDERR "sox a bien fait son travail ;)\n";
          if ($SplitStereo eq 1)
          {
            print STDERR "renomme fichier sur disque $AudioFilename.wav -> ". $AudioFilename."_".$counter.".wav\n";
            rename( "$AudioFilename.wav", $AudioFilename."_".$counter.".wav");
          }
        }
        else 
        { #on a une erreur le fichier de dest n'est pas créé
          print STDERR "code ret=$Ret ARRET DU SCRIPT \n";
          TraitementFin($ENV{PBS_JOBID}, '', '', 1018);
          exit(1018);
        }
      }
      
      my $n;
     
      if ($bIsWAV == 0)
      {
        print STDERR "\n";
      }
      else
      {
        print STDERR "\nsuppr fichier tmp\n";
        $n = unlink("$AudioFilename.tmp.wav");
        if ($n != 1)
        {
          print STDERR "ERROR : delete tmp $n $AudioFilename.tmp.wav" ;
        }
      }
      
      # pour les fichiers stéréo splittés on reformera le nom de fichier après
      # a savoir $AudioFilename."_".$counter.".wav"
      if ($SplitStereo eq 0)
      {
        $AudioFilename = $AudioFilename.".wav";
      }
    }
    $cmd = "ls -l $AudioFilename* 2>&1";
    print STDERR "Commande = ".$cmd."\n";
    my $Ret = lib_utils::Run ($cmd);

    return ($bOK, $AudioFilename);
  }

    #******************************************************************************
    # copie du répertoire des frontaux vers un répertoire du runner
    #******************************************************************************
    sub CopyAudioFileOnRunner
    {
    my ($AudioFileName) = @_;
    my $TmpFileName;
    my $i;
    
      $TmpFileName = "$LOCAL_AUDIO_PATH$ENV{IDUSER}/$AudioFileName.tmp";
      lib_utils::Run ( "rm -f $TmpFileName" );
      #le fichier est en cours de copie on attends
      $i=0;
      while (-e $TmpFileName)
      {
        print STDERR "CopyAudioFileOnRunner : $TmpFileName exists !! waiting ...";
        sleep(10);
        $i++;
        if ($i gt 6)
        {
          print STDERR "ERROR : CopyAudioFileOnRunner : timeout waiting for copy completion !!";
          #on continue ! à voir si ça bug
          last;
        }
      }
      
      #on regarde si le fichier existe déjà sur le runner 
      if (! -e "$LOCAL_AUDIO_PATH$ENV{IDUSER}/$AudioFileName")
      {
        #on recopie sur le runner le fichier audio 
#        my $sCmd = "scp msfdev\@$ENV{MSF_SERVER_IP_ADDRESS}:$MSF_AUDIO_PATH$AudioFileName $TmpFileName";
        my $sCmd = "cp $MSF_AUDIO_PATH$AudioFileName $TmpFileName";
        print STDERR "\n".$sCmd."\n" ;
        lib_utils::Run ( $sCmd );
        
        #on met les droits d'écriture
        $sCmd = "chmod u+w $TmpFileName";
        print STDERR "\n$sCmd \n" ;
        lib_utils::Run ( $sCmd );
        
        rename($TmpFileName, "$LOCAL_AUDIO_PATH$ENV{IDUSER}/$AudioFileName");
        
      }      
    }

  #******************************************************************************
  # * Traitements fait en fin du script, heure de fin et mise à jour base de 
  # * données
  #******************************************************************************
  sub DeleteTmpAudioFiles  
  {
    my ($AudioPath) = @_;
    print STDERR "\nDeleteTempFiles=$DeleteTempFiles";
    if ($DeleteTempFiles == 1)
    {
  
      my $sCmd = "rm -fv $AudioPath$ENV{IDUSER}/$ENV{AUDIOFILE}*";
      print STDERR "\n $sCmd \n" ;

      my ($pipe);
      open $pipe, ("$sCmd  2>&1 | " ) or print ("pabon");
      while ($line = <$pipe>) 
      {
        print STDERR $line;
      }
      close($pipe);
    }
  }

  #******************************************************************************
  # on récupère une liste de locuteurs a:b:c et on récupère un tableau de toutes
  #leurs infos
  #******************************************************************************
  sub DB_GetSpeakerInfo
  {
    my ($UserId, $SpeakersList) = @_;
    my ($hash_ref, @ResultTable);
    
    if (! $dbh->ping() )
    {
      DB_Connect();
    }
    
    # $SpeakerList : remplace les ':' par des ','
    $SpeakersList =~ s/\:/\,/g;
    
    $statement = "SELECT * FROM $ENV{DATABASENAME}.T_SpeakerList as s, $ENV{DATABASENAME}.T_AudioFiles as a ".
                "WHERE (s.RefUser=$UserId) AND (s.RefAudioFile=a.IdAudioFile) AND (s.SpeakerIdentifier IN ($SpeakersList))";        
    
    $sth = $dbh->prepare($statement);
    $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    
   
    while ($hash_ref = $sth->fetchrow_hashref)
    {
      
     push (@ResultTable,$hash_ref);
       
    }
          
    return (@ResultTable); 
  }
  
  
  #******************************************************************************
  # * on attend que la ligne jobid soit présente dans la base de donnée
  #******************************************************************************
  sub DB_WaitForProcessInfo
  {
     my ($JobId) = @_;

    if (! defined($JobId))
    {
      $JobId = $ENV{PBS_JOBID};
    }
    my $nCpt=0;
   
    do
    {
      if (! $dbh->ping() )
      {
        DB_Connect();
      }

      $statement = "SELECT * FROM t_processes WHERE (jobid=$JobId)  ".
        " OR (jobid=(SELECT jobid FROM t_jobidchildren  WHERE jobidchild=$JobId )) ";
      #print $statement;
      #---------------------------------------------- 
      $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
      
     print STDERR "sql =$statement\n";
      print STDERR "\nDB_WaitForProcessInfo : $rv \n";
      if ($rv eq  '0E0')
      {
        print STDERR "Sleep 2s\n";
        sleep(2);
      }
      $nCpt++;
    } while (($rv eq  '0E0') && ($nCpt<30))

  }
 
  

  #******************************************************************************
  # * 
  #******************************************************************************
  sub DB_DisConnect
  {
    #fin de cnx avec la base
    $dbh->disconnect(); 
  }
  
  #******************************************************************************
  # * 
  #******************************************************************************
  sub DB_Connect
  {
    my ($JobId) = @_;

      print STDERR "DB_Connect : DBI:mysql:'.$ENV{DATABASENAME}.':'.$ENV{MYSQL_IP_ADDRESS}, $ENV{MYSQL_ADMIN_LOGIN}, xxx}\n";
      my $count=0;
      do
      {
        #on se connecte à la base en début de script
        $dbh = DBI->connect('DBI:mysql:'.$ENV{DATABASENAME}.':'.$ENV{MYSQL_IP_ADDRESS}, $ENV{MYSQL_ADMIN_LOGIN}, $ENV{MYSQL_ADMIN_PASSWORD});
        if ( ! defined($dbh))
        {
          print STDERR "Could not connect to database: $DBI::errstr retry:$count \n";
          sleep (60);
          $count ++;
        }
      }
      while ( (!defined($dbh)) && ($count<10));

      print STDERR "Connected to DB $ENV{DATABASENAME} : $ENV{MYSQL_IP_ADDRESS} \n";

      # reconnexion automatique
      $dbh->{'mysql_auto_reconnect'} = 1; 

      #timeout 1000 secondes
      $dbh->do("SET SESSION wait_timeout=3600");

      #on attend que dans la table des process la ligne du jobid soit renseignée
      if (defined($JobId))
      {
        DB_WaitForProcessInfo ($JobId);
      }
  }


  #******************************************************************************
  # on récupère le message d'erreur correspondant au code en paramètre
  #******************************************************************************
  sub GetErrorMessage
  {
    my ($CodeRetour)=@_;
    my $Message;
      $Message ="Unknow code";
      
      if ( !defined($CodeRetour) || !defined($dbh))
      {
        return;
      }
      my $statement = "SELECT * FROM T_ErrorMessages WHERE  (ErrorCode= $CodeRetour) ";
      
      if (! $dbh->ping() )
      {
        DB_Connect();
      }
      $sth = $dbh->prepare($statement);
      $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";

      #on a un résultat unique sinon on ne fait rien
      if ($rv eq 1 )
      {
        $hash_ref       = $sth->fetchrow_hashref;
        $Message        = $hash_ref->{ErrorMessage};
      }
      $sth->finish();
      return $Message;    
  }
  
  #******************************************************************************
  # * A partir d'un hostname retourne son index dans la table T_Hosts 
  #******************************************************************************
  sub GetHostId
  {
  my($HostName) = @_;
  my $return = -1;
  
  
    if (! defined($HostName))
    {
      return $return;
    }
      
    if (! $dbh->ping() )
    {
      DB_Connect();
    }

    $statement = "INSERT IGNORE INTO T_Hosts set HostName='$HostName'";
    $sth = $dbh->prepare($statement);
    $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    $sth->finish();

    $statement = "SELECT IdHostname FROM T_Hosts where Hostname=\"$HostName\"";
    $sth = $dbh->prepare($statement);
    $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    
  
    return $return; 
  }


  #******************************************************************************
  # * on récupere en base de données l'IdStream qui est aussi le channel id   
  #******************************************************************************
  sub GetChannelId
  {
    my ($JobId) = @_;
    my ($statement, $StreamId);

      $statement = "SELECT * FROM t_processes WHERE jobid=\"$JobId\" ";        
      print STDERR "\n GetChannelId : ".$statement." \n";
        
      if (! $dbh->ping() )
      {
        DB_Connect();
      }
      $sth = $dbh->prepare($statement);
      $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
      
      #on a un résultat unique on sort
      if ($rv eq 1 )
      {
        $hash_ref = $sth->fetchrow_hashref;
        $StreamId   = $hash_ref->{RefStream};
      }
      $sth->finish();
      
      return $StreamId;
  }

  #******************************************************************************
  # retourne le nom du host courant
  #******************************************************************************
  sub GetRunnerName
  {
    if (defined($ENV{SLURM_JOB_NODELIST}))
    {
      return $ENV{SLURM_JOB_NODELIST};
    }

    my $HostRunner = "??";

    if (defined($ENV{PBS_NODEFILE}))
    {
      open FILE, $ENV{PBS_NODEFILE} or die $!;
      $HostRunner = <FILE>;
      chop($HostRunner);
      close(FILE); 
    }
    print "GetRunnerName : $HostRunner\n";

    return $HostRunner;
  }




  #******************************************************************************
  # décrypte un fichier audio avec la clef gpg
  #******************************************************************************
  sub GpgDecryptFile
  {
  my ($FileName, $filetype, $GpgKey) = @_;

    if (defined($GpgKey) && ($filetype eq 'GPG'))
    { 
      my $sCmd = 'echo'." \"$GpgKey\" | gpg --batch --no-tty --passphrase-fd 0  $FileName";
      print STDERR "\n commande decryptage=$sCmd \n" ;
      my $ret=lib_utils::Run ( $sCmd );

      if ($ret != 0)
      {
        print STDERR "\n>>========= GPG error ===========\n";
        TraitementFin($ENV{PBS_JOBID}, '', '', 1019);
        exit(1019);
      }

      $ENV{AUDIOFILE} = substr($ENV{AUDIOFILE}, 0, length($ENV{AUDIOFILE})-4);
      print STDERR "\n nouveau nom de fichier : $ENV{AUDIOFILE} \n";
    }
  }

  #******************************************************************************
  # encrypte un fichier avec la clef gpg
  #******************************************************************************
  sub GpgCryptFile
  {
  my ($FileName, $GpgKey) = @_;

    if (defined($GpgKey) )
    { 
      my $sCmd = "echo \"$GpgKey\" | gpg --batch --no-tty --passphrase-fd 0 -c $FileName";
      print STDERR "\n $sCmd \n" ;
      lib_utils::Run ( $sCmd );

      #on renomme le fichier gpg en xml pour éviter de changer tout le soft
      rename( "$FileName.gpg", "$FileName");
    }
  }  

  #******************************************************************************
  # retourne l'extention du fichier passé en argument
  #******************************************************************************
  sub GetExtention
  {
  my ($FileName) = @_;

    #on récupère l'extension du fichier
    my @nn=split(/\./,$FileName);
    my $filetype;
    my $fileextention=pop(@nn);
    $filetype = uc($fileextention);
    return $filetype ;
  }

  #******************************************************************************
  # retourne la date courante au format de la base de données
  #******************************************************************************
  sub GetDate
  {
    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = lib_utils::GetLocalTime();
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year, $month, $mday, $hour, $min, $sec);
  }        


#******************************************************************************
#******************************************************************************
  sub PrintDate
  {
    my ($Text) = @_;
    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = lib_utils::GetLocalTime();
    printf  STDERR  ("\n$Text : %04d-%02d-%02d %02d:%02d:%02d\n", $year,$month,$mday,$hour,$min,$sec);
    
  }  
    
  #******************************************************************************
  # envoie le résultat avec la callback que si on a un stream !
  #******************************************************************************
  sub MulticastResult
  {
    my ($JobId) = @_;
    my ($Callback, $hash_ref, $ChannelId);
    
    # pour les STREAM on met à jour la date de début d'enregistrement dans le xml
    UpdateXmlDateStart($JobId);    

    $ChannelId = GetChannelId($JobId);
        
    $statement = "SELECT m.*,c.ChannelName FROM $ENV{DATABASENAME}.T_MulticastResults as m, ".
                " MSFREC.T_Channels as c WHERE (m.RefChannel=c.IdChannel) AND (m.RefChannel=$ChannelId)";        
    
    if (! $dbh->ping() )
    {
      DB_Connect();
    }
    $sth = $dbh->prepare($statement);
    $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    
    
    print STDERR "\n MulticastResult : ".$statement." \n";
    
    while ($hash_ref = $sth->fetchrow_hashref)
    {
        $Callback   = $hash_ref->{Callback};
        print STDERR "\n Callback =$Callback";
        
        if (defined($Callback))
        {
            my $pos = rindex $Callback, "?";
            my ($ua, $agent);
            my ($response);
    
            $agent = 'MSF';
            
            $ua = LWP::UserAgent->new(agent => $agent,
                       cookie_jar => HTTP::Cookies->new()) or
                      ((print STDERR "can't create user agent\n"));
                      
            print STDERR "\n envoie fichier $Callback";         
            $response = $ua->post($Callback,
                    Content_Type => 'form-data',
                    Content =>
                    [
                     ChannelName => $hash_ref->{ChannelName},
                     filename => ["$LOCAL_RESULT_PATH/$JobId.xml", "$JobId.xml"]
                    ]);
            print STDERR "\nResultat de la callbac : \n";
            print STDERR $response->content ;          
        }
    }
           
    print STDERR "\nSuppression du fichier audio d'origine \n";
    DeleteTmpAudioFiles($MSF_AUDIO_PATH);
  }
    

  
  
  #******************************************************************************
  #******************************************************************************
  sub MergeXmlFiles 
  {
    my ($XmlFileNamePrefix, $NbSpeaker) = @_;
    my (@channel_nodes, @speaker_nodes, @sseg_nodes, @proc_nodes,  @audio_docs);
    my ( $channel_node, $speaker_node, $sseg_node, $proc_node, $audio_doc);
    my ( $channel_id, $speaker_id , $speaker_shift) = ( 0 , 0 , 0 );
    my $input_file;
  
    #Pathes
    my $speechsegment_path  = "/AudioDoc/SegmentList/SpeechSegment";
    my $speaker_path        = "/AudioDoc/SpeakerList/Speaker";
    my $channel_path        = "/AudioDoc/ChannelList/Channel";
    my $proc_path           = "/AudioDoc/ProcList/Proc";
    my $audiodoc_path       = "/AudioDoc";
  
    #Parse each file
    for (my $i=1; $i<= $NbSpeaker; $i++) 
    {
      $input_file = $XmlFileNamePrefix."_$i.xml";
      $channel_id++;
      $speaker_shift = $#speaker_nodes + 1;
  
      #Parse XML/VRBS file
      my $doc = ParseXml($input_file,"noDTD");
  
      #--------  lit l'arbre XML  -----------------
      # <AudioDoc name="httpdirect2.yacast.frDATAARRAY3920100726548143505.wma" path="/Aud
      @audio_docs = $doc->getElementsByTagName('AudioDoc');
      $audio_doc = $audio_docs[0];

      foreach $proc_node ($doc->findnodes($proc_path)) {
        push @proc_nodes, $proc_node unless ( $#channel_nodes );
      }
  
      foreach $channel_node ($doc->findnodes($channel_path)) {
        push @channel_nodes, $channel_node;
      }
  
      foreach $speaker_node ($doc->findnodes($speaker_path)) {
        push @speaker_nodes, $speaker_node;
      }
  
      foreach $sseg_node ($doc->findnodes($speechsegment_path)) {
        push @sseg_nodes, $sseg_node;
      }
  
    }
  
    #Merge the two files
    my ( $output_doc, $printed_doc );
    my $root;
    my ( $proclist_node, $channellist_node, $speakerlist_node, $sseglist_node );
  
    $output_doc = XML::LibXML::Document->createDocument("1.0","UTF-8");
    $root = $output_doc->createElement("AudioDoc");
    $root->setAttribute('name',$audio_doc->getAttribute( "name" ));
    $root->setAttribute('path',$audio_doc->getAttribute( "path" ));

    $output_doc->setDocumentElement($root);
  
    $proclist_node = $output_doc->createElement("ProcList");
    foreach $proc_node (@proc_nodes) {
      $proclist_node->appendChild($proc_node);
    }
    $root->appendChild($proclist_node);
  
    $channellist_node = $output_doc->createElement("ChannelList");
    foreach $channel_node (@channel_nodes) {
      $channellist_node->appendChild($channel_node);
    }
    $root->appendChild($channellist_node);
  
    $speakerlist_node = $output_doc->createElement("SpeakerList");
    foreach $speaker_node (@speaker_nodes) {
      $speakerlist_node->appendChild($speaker_node);
    }
    $root->appendChild($speakerlist_node);
  
    $sseglist_node = $output_doc->createElement("SegmentList");
    foreach $sseg_node ( sort { $a->getAttribute("stime") <=>
              $b->getAttribute("stime") }
             @sseg_nodes) {
      $sseglist_node->appendChild($sseg_node);  }
    $root->appendChild($sseglist_node);
  
    #Print the document into the output file or STDOUT
    my $fs_output;
    $printed_doc = $output_doc->toString(2);
    $printed_doc =~ s/\n+/\n/g;
    $printed_doc =~ s/^\s*|\s*$//g;
    $printed_doc =~ s/(<Word .*>)\n/$1 /g;
    $printed_doc =~ s/\s+<\/Word>/ <\/Word>/g;
    $printed_doc =~ s/>[ ]+/> /g;
    $printed_doc =~ s/>\s+</>\n</g;
  
    open($fs_output, ">", "$XmlFileNamePrefix.xml")
         or Log(0, "can't open output file '$XmlFileNamePrefix.xml' <$!>\n" ), return -1;
  
    print $fs_output $printed_doc;
  
    close($fs_output);
  
    return 0;
  
  }
  
    #******************************************************************************
    # on relit le fichier de partitionnement pour rechercher les lignes <Speaker ch=...>
    #******************************************************************************
    sub PbsQsub
    {
    my ($sCommandLine) = @_;
        my $JobIdChilds ;
        my $pid = open($fh, $sCommandLine) or print $!;
        
        #on regarde l'identifiant du job qu'on vient de lancer pour en avoir une trace en base
        if ($pid)
        {
          print STDERR "\nOptimize >> pid  = $pid : $sCommandLine\n";
          
          while ($line =  <$fh>) 
          { 
            # on récupère la ligne ou il y a ecrit xxx.msfxx pour le jobid
            if ( grep (/\.msf/, $line) )
            {
              chomp $line;

              $JobIdChilds=$line; #on a besoin ici du nom entier du JobId
              #my @Tmp = split(/\./, $line);
              #$JobIdChilds=$Tmp[0];
 #             print STDERR "\nJobIdChilds=$JobIdChilds line=$line\n";
            }
            
            print STDERR ">".$line;
          }
          close $fh;
          
          return $JobIdChilds ;                   
        }
    }  

  # *************************************************************************** #
  # Parse XML
  # *************************************************************************** #
  sub ParseXml 
  {
  
    my ($xml, $dtdpath, $keepBlanks) = @_;
    my $dtd;
    my $doc;
    my ($publicId, $systemId) = ('','');
  
    #Initialization of parsing parameters
    my $parser = XML::LibXML->new();
    $parser->load_ext_dtd(1);
    $parser->validation(0);
    $parser->line_numbers(0);
    $parser->pedantic_parser(0);
  
    # keep  blank nodes or remove them
    if (defined $keepBlanks)
    {
        # 1 : don't remove blank nodes | 0 : remove blank nodes 
        $parser->keep_blanks($keepBlanks);
    }
    else {
        $parser->keep_blanks(1) #default value
    }
    $parser->recover(0);
  
    #Default value for DTD path
    $dtdpath = "./"           if ((! defined($dtdpath)) || ($dtdpath eq ''));
  
  
    #Parse and validate the xmlfile (with dtd)
    eval {
      $doc = $parser->parse_file($xml);
      if ($dtdpath ne "noDTD") {
        $dtd = $doc->internalSubset;
        $publicId = ${dtd}->publicId() if (defined ${dtd}->publicId());
        $systemId = ${dtd}->systemId() if (defined ${dtd}->systemId());
        $dtd = XML::LibXML::Dtd->new($publicId,$dtdpath."/".$systemId);
        $doc->validate($dtd);
      }
    };
    if ($@) {
      #bug with libXML
      #if ($@ ne '') 
      #todo : mettre dans fichier log temporaire
      print STDERR "Parsing problem with $xml : $@";
      return(-1);
    }
    else {
      #Converting to UTF-8 and return Tree
      $doc->setEncoding('UTF-8');
      return $doc;
    }
  }

  #******************************************************************************
  # envoie effectivement un email avec SENDMAIL
  #******************************************************************************
  sub SendEmail
  {
    my ($JobId, $send_to, $content, @filenames, $CodeRetour) = @_;
    my $Body;
    
    #print STDERR "$JobId, $send_to, $content, @filenames \n";

    $Body = "";
    
    # si on a du texte à écrire on le fait
    if (defined($content))
    {
      $Body .= $content;
    }

    $Body .=  "\n\nMediaSpeech Factory\n";
    $Body .= "Vecsys - Vecsys Research - Limsi\n\n";
    $Body .= "Please visit us at : https://mediaspeech.com \n";
    
    #ajoute l'information sur qui fait la traduction
    $Body .="\nTranslation & voice synthesis : http://www.reverso.net \n";

    if (defined($CodeRetour))
    {
      my $MessageRetour = GetErrorMessage($CodeRetour);
      $Body .= "Return Message : $MessageRetour\n";
      $Body .= "Return Code    : $CodeRetour\n";
    }
    #print STDERR $Body;

    my $msg = MIME::Lite->new(
        From    => 'no_reply@mediaspeech.com',
        To      => $send_to,
        Subject => "Your Job $JobId is done",
        Type    => 'multipart/mixed',
    );
    
    $msg->attach(
        Type     => 'TEXT',
        Data     => $Body,
    );
    
    #on attatche les différents fichiers
    if (@filenames)
    {
      foreach (@filenames) 
      {
        if ($_ ne 0)
        {
          
          my $FileName;
          $FileName = basename($_);
  
          #on extrait l'extention        
          my @nn=split(/\./,$FileName);
          my $fileextention=pop(@nn);
          
          my $Type;
          if (($fileextention eq "TXT") || ($fileextention eq "XML"))
          {
            $Type='TEXT';
          } 
          else
          { #on met le type du fichier audio
            $Type="audio/$fileextention";
          } 

          if (-e $_) 
          {
            print STDERR "Email PJ : $_ \n";
            $msg->attach(
                Type        => $Type,
                Path        => $_,
                Filename    => $FileName,
                Disposition => 'attachment'
            )  or die "Error adding $_ $!\n";
          }
        }
      }
    }
    
    $msg->send;

  }

  #******************************************************************************
  # envoie l'email de fin si nécessaire, envoie le résultat ou juste l'info de fin
  #******************************************************************************
  sub SendProcessEndingEmail
  {
  my ($JobId, $ActionType, $sEmailAddress, $CodeRetour, $content) = @_;

      
  }

    #******************************************************************************
    # on relit le fichier de partitionnement pour rechercher les lignes <Speaker ch=...>
    #******************************************************************************
    sub StartAudioProcessing
    {
    my ($Command, $ARGS, $AudioFilename, $AudioType ,$InputXml, $OutputXml) = @_;
    my $sCommandLine;
    
        if ($Command eq "part")
        { #    lancement du process partitionnement ... pas l'option -f
          $sCommandLine = "/usr/local/$AudioType/bin/$AudioType"."_"."$Command $AudioFilename  $ARGS  > $OutputXml";
        }
        #--------------------------------------------
        elsif ($Command eq "lid")
        { #    lancement du process  LID 
          $sCommandLine = "/usr/local/$AudioType/bin/$AudioType"."_"."$Command -f $AudioFilename  $ARGS  > $OutputXml";
        }
        else
        { #    lancement du process transcription avec le partitionnement en argument
          if (-e $InputXml)
          {  # le fichier xml de partitionnement existe on l'utilise
            $sCommandLine = "/usr/local/$AudioType/bin/$AudioType"."_"."$Command -f $AudioFilename  $ARGS  $InputXml > $OutputXml";
          }
          else
          {
            $sCommandLine = "/usr/local/$AudioType/bin/$AudioType"."_"."$Command -f $AudioFilename  $ARGS  > $OutputXml";
          }
        }
        PrintDate("Before RUN");
        
        
        #mise à jour de la base de données avec la ligne de commande
        my $JobId;
        if (defined($ENV{JOBID}))
        {
          $JobId = $ENV{JOBID};
        } 
        else
        {
          $JobId = $ENV{PBS_JOBID}; 
        }       
          
        UpdateProcessesField ($JobId, "CommandLine", $sCommandLine); #download

        print STDERR "\n>>$sCommandLine \n";
        my $CodeRetour = lib_utils::Run ($sCommandLine);
      
        PrintDate("After RUN : CodeRetour=$CodeRetour\n");
        return $CodeRetour;
    }

  #******************************************************************************
  # * Traitements fait en fin du script, heure de fin et mise à jour base de 
  # * données
  #******************************************************************************
  sub TraitementFin  
  {
    my ($JobId, $ActionType, $sEmailAddress, $CodeRetour, $content) = @_;
    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = lib_utils::GetLocalTime();

    print STDERR "TraitementFin : CodeRetour=$CodeRetour \n";

    UpdateErrorMessage ($JobId, $CodeRetour); 
    if ($CodeRetour ne 0)
    {
      #si on a une erreur on stocke en base de donnée et on appelle la callback
      CallbackErrorUrl($JobId, $ENV{COMMAND}, $CodeRetour);
    }
    else
    {
      my $ToWrite = "$ENV{PATH_FILES};$ENV{IDUSER};$JobId;$ENV{AUDIOTYPE};$ENV{AUDIOFILEDURATION};$ENV{LANGUAGE}";

      print STDERR "Writing billing : $ToWrite\n";
      my $Cmd="echo \"$ToWrite\" >> /home/MSF/billing.txt";
      system($Cmd);
    }
    
    #sorties de debug
    if (defined($JobId))
    {
      print STDERR "JobId=$JobId";
    }
    if (defined($ActionType))
    {
        print STDERR " ActionType=$ActionType";
    }
    if (defined($sEmailAddress))
    {
        print STDERR " sEmailAddress=$sEmailAddress";
    }
    print STDERR "\n" ;
  
    my $DateStop=sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year,$month,$mday,$hour,$min,$sec);
  
    # on lit le fichier xml pour mettre à jour la durée de parole dans la base de données
    # onne fait plus avec nouvelle structure de DB !UpdateAudioSpeakerDuration($JobId);
      
    #mise à jour de la base avec les infos qu'on a
    UpdateProcessesCompletionInfos ($JobId, "E", $DateStop, 100);
    
    CallbackUrl($JobId,"E");
    
    # ici on envoie le résultat syntaxe de la chaine de caractère
    # email://address@pouf.fr
    # sms://0612346882
    # ftp://ftp.pouf.fr/filename
    
    if ( defined($ENV{RESULTINFO}))
    {
      my ($ligne, $type, $adresse);

      $ligne   = $ENV{RESULTINFO};
      $ligne   =~/(.*):\/\/(.*)/;
      $type    = $1;
      $adresse = $2;
	  
	  my $ResFileName;
	  $ResFileName = $ENV{AUDIOFILE};
	  $ResFileName =~ s/\.[^\.]*$//g; #on supprime l'extension (on cherche un point qui n'est pas suivi d'un pount)
      
      if ($type eq "email")
      {
          #on converti le résultat en texte
         my $Cmd= "$ENV{'PATH_FILES'}/www/scripts/doTXT.pl $LOCAL_RESULT_PATH/$JobId.xml > $LOCAL_RESULT_PATH/$JobId.txt";
          print STDERR "$Cmd \n";
          system($Cmd);

          #sert à rendre inscriptible le fichier par le WEB
          system("chmod a+rw $LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.txt");
          my @Files =("$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.txt");
          
          SendEmail ($ENV{PBS_JOBID},$sEmailAddress, $content, @Files, $CodeRetour);
           
        
      }
      elsif  ($type eq "sms")
      {
        my $Cmd= "$ENV{'PATH_FILES'}/www/scripts/doTXT.pl $LOCAL_RESULT_PATH/$JobId.xml > $LOCAL_RESULT_PATH/$JobId.txt";
        print STDERR "$Cmd \n";
        system($Cmd);

        open FILE, "$LOCAL_RESULT_PATH/$JobId.txt" or die "Couldn't open file: $!"; 
        my $text = join("", <FILE>); 
        close FILE;
        
        $Cmd="wget \"http://www.leSMS.com/http.php?email=snunge\@vecsys.fr&pass=RG4XEC&numero=$adresse&message=\\\"$text\\\"\"";
        print STDERR "$Cmd \n";
        system($Cmd);
        
      }
      elsif  ($type eq "ftp")
      {
        #$ENV{RESULTINFO} contient toute l'url ftp de destination
        my $Cmd= "wput $LOCAL_RESULT_PATH/$JobId.xml ".$ENV{RESULTINFO};
        print STDERR "$Cmd \n";
        system($Cmd);
        
      }
      elsif  (($type eq "http") || ($type eq "https"))
      {
        #$ENV{RESULTINFO} contient toute l'url ftp de destination
        my $Cmd= "wget $ENV{RESULTINFO}$ResFileName.xml ";
        print STDERR "$Cmd \n";
        system($Cmd);
        
      }
      elsif  ($type eq "scp") 
      {
        #$ENV{RESULTINFO} contient toute l'url ftp de destination
        my $Cmd= "scp $LOCAL_RESULT_PATH/$JobId.xml $adresse ";
        print STDERR "$Cmd \n";
        system($Cmd);
        
      }
      elsif  ($type eq "cp") 
      {
        #$ENV{RESULTINFO} contient toute l'url ftp de destination
        my $Cmd= "cp $LOCAL_RESULT_PATH/$JobId.xml $adresse ";
        print STDERR "$Cmd \n";
        system($Cmd);
        
      }
    }
    else
    {
      #on regarde si il faut envoyer un email à la fin du traitement, et on l'envoie
      SendProcessEndingEmail($JobId, $ActionType, $sEmailAddress, $CodeRetour, $content);
    }

    #on supprime le fichier audio qu'on a copié en local et ses dérivées
    DeleteTmpAudioFiles($LOCAL_AUDIO_PATH);
    
    DB_DisConnect();      
    return;
  } 

  
  #******************************************************************************
  # * Traitements fait en fin du script, heure de fin et mise à jour base de 
  # * données
  #******************************************************************************
  sub TraitementFinTraduction
  {
    my ($JobId, $ActionType, $sEmailAddress, $CodeRetour, $content) = @_;
    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = lib_utils::GetLocalTime();
    my @Files;
    
    print STDERR "Traitement de fin $JobId, $ActionType, $sEmailAddress\n" ;
  
   
    #envoie de l'email de fin
    my $Cmd= "$ENV{'PATH_FILES'}/www/scripts/doTXT.pl $LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.xml > $LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.txt";
    print STDERR "$Cmd \n";
    system($Cmd);

    
    #******************************************************************************
    #fait la traduction
    #******************************************************************************
    #$ENV{'VOICE2MAIL_SRC_LANG'}
    #$ENV{'VOICE2MAIL_DEST_LANG'}
    #$ENV{'VOICE2MAIL_SEND_TO'}
    #$ENV{'VOICE2MAIL_SRC_TEXT'}
    #$ENV{'VOICE2MAIL_SRC_AUDIO'}
    #$ENV{'VOICE2MAIL_DEST_TEXT'}
    #$ENV{'VOICE2MAIL_DEST_AUDIO'}

    # si pas de langue spécifié on suppose que c'est du Français
    # lid du cts ne marche sur les fichiers courts des voicemails     
    if ( defined($ENV{VOICE2MAIL_SRC_LANG}))
    {
      $ENV{'TRANSLATE_SRC_LANG'}=$ENV{VOICE2MAIL_SRC_LANG};
    }
    else
    {
      print STDERR "pas de langue source par défaut, on met Francais\n";
      $ENV{'TRANSLATE_SRC_LANG'}="fra";
    }
    
    $ENV{'TRANSLATE_SRC_FILE'}="$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.txt";

    #******************************************************************************
    # traduction en anglais si on est en Français
    #******************************************************************************
    if (($ENV{'TRANSLATE_SRC_LANG'} eq 'fra') || ($ENV{'TRANSLATE_SRC_LANG'} eq 'fre'))
    {
      #ATTENTION : fra pour la traduction, fre pour la transcription !!!!! 
      $ENV{'TRANSLATE_DEST_FILE'}= "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.eng";
      $ENV{'TRANSLATE_DEST_LANG'}='eng';
      $ENV{'TRANSLATE_SRC_LANG'}="fra";
    }
    elsif ($ENV{'TRANSLATE_SRC_LANG'} eq 'eng')
    {
      #ATTENTION : fra pour la traduction, fre pour la transcription !!!!! 
      $ENV{'TRANSLATE_DEST_FILE'}= "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.fre";
      $ENV{'TRANSLATE_DEST_LANG'}='fra';
    }
    else
    {
      print STDERR "***********ERREUR dans le choix de la langue !!!!\n";      
    }
     
    $Cmd= "cd $ENV{'PATH_FILES'}/www/scripts; /usr/local/bin/php $ENV{'PATH_FILES'}/www/scripts/cmd_translate.php";
    print STDERR "$Cmd \n";
    system($Cmd);
    
    # traduction en espagnol
    $ENV{'TRANSLATE_DEST_LANG'}='spa';
    $ENV{'TRANSLATE_DEST_FILE'}= "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.spa";
    $Cmd= "cd $ENV{'PATH_FILES'}/www/scripts; /usr/local/bin/php $ENV{'PATH_FILES'}/www/scripts/cmd_translate.php";
    print STDERR "$Cmd \n";
    system($Cmd);

    # traduction en russe
    $ENV{'TRANSLATE_DEST_LANG'}='rus';
    $ENV{'TRANSLATE_DEST_FILE'}= "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.rus";
    $Cmd= "cd $ENV{'PATH_FILES'}/www/scripts; /usr/local/bin/php $ENV{'PATH_FILES'}/www/scripts/cmd_translate.php";
    print STDERR "$Cmd \n";
    system($Cmd);
    
    # traduction en allemand
    $ENV{'TRANSLATE_DEST_LANG'}='ger';
    $ENV{'TRANSLATE_DEST_FILE'}= "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.ger";
    $Cmd= "cd $ENV{'PATH_FILES'}/www/scripts; /usr/local/bin/php $ENV{'PATH_FILES'}/www/scripts/cmd_translate.php";
    print STDERR "$Cmd \n";
    system($Cmd);
    
    ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = lib_utils::GetLocalTime();
    printf  STDERR  ("\nApres traduction : %04d-%02d-%02d %02d:%02d:%02d\n", $year,$month,$mday,$hour,$min,$sec);
    
    #******************************************************************************
    # ajoute la traduction au message
    #******************************************************************************
    open FILE, "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.eng" or die "Couldn't open file: $!"; 
    $content = join("", <FILE>); 
    close FILE;

    #******************************************************************************
    #sert à rendre inscriptible le fichier par le WEB
    #******************************************************************************
    system("chmod a+rw $LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.txt");
    
    #******************************************************************************
    # émission de l'email
    #******************************************************************************
    $Files[0] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.txt";
    $Files[1] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.eng";
    $Files[2] = "$LOCAL_AUDIO_PATH$ENV{IDUSER}/$ENV{AUDIOFILE}";
    $Files[3] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.fre.mp3"; 
    $Files[4] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.spa.mp3"; 
    $Files[5] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.eng.mp3"; 
    $Files[6] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.rus.mp3"; 
    $Files[7] = "$LOCAL_RESULT_PATH/$ENV{PBS_JOBID}.ger.mp3"; 
                
    SendEmail ($ENV{PBS_JOBID},$sEmailAddress, $content, @Files , $CodeRetour);
 

    #on supprime le fichier audio qu'on a copié en local et ses dérivées
    DeleteTmpAudioFiles($LOCAL_AUDIO_PATH);
    

    my $DateStop=sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year,$month,$mday,$hour,$min,$sec);
      
    #mise à jour de la base avec les infos qu'on a
    UpdateProcessesCompletionInfos ($JobId, "E", $DateStop, 100);

    CallbackUrl($JobId,"E");

    DB_DisConnect();      

    return;
  } 

  #******************************************************************************
  #******************************************************************************
  sub UpdateJobIdChildren
  {
    my (@ChildList) = @_;

      foreach (@ChildList)
      {
          my @Tmp = split(/\./, $_);
          
          my $JobIdChilds=$Tmp[0];
              
          $statement = "INSERT INTO T_JobIdChildren SET JobId=$ENV{PBS_JOBID},JobIdChild=$JobIdChilds";
          print STDERR "$statement \n";
          #----------------------------------------------
          if (! $dbh->ping() )
          {
            DB_Connect();
          }
          $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
      }
  }
  
  #******************************************************************************
  # mise à jour des infos à la fin du traitement
  #******************************************************************************
   sub UpdateProcessesCompletionInfos
   {
      my ($JobId, $Status, $DateStop, $Progress) = @_;
        if ( defined ($Status) &&  defined ($Progress) && defined ($DateStop) && defined ($JobId))
        {

          $statement = "UPDATE t_processes SET status=\"$Status\", datestop=\"$DateStop\", progress=$Progress ".
                        "WHERE ((jobid=$JobId) AND (status <> 'C'))";

          #----------------------------------------------
          if (! $dbh->ping() )
          {
            DB_Connect();
          }
          $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
          print STDERR "\nNombre de lignes : ".$rv."-".$Status."-". $DateStop."-". $Progress."\n";
          print STDERR "sql=$statement\n";
        }

   }

  #******************************************************************************
  # mise à jour d'un champ de la table T_Processes
  #******************************************************************************
  sub UpdateProcessesField
  {
  my ($JobId, $field, $value) = @_;

    if ( defined ($field) && defined ($value) && defined ($JobId))
    {  

      $statement = "UPDATE t_processes SET $field='$value' WHERE jobid=$JobId";
      
      #---------------------------------------------- 
      if (! $dbh->ping() )
      {
        DB_Connect();
      }
      $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
      print STDERR "\nNombre de lignes : ".$rv."-".$JobId."-". $field."-". $value."\n";
      print STDERR "sql=$statement\n";
    }
  }

    
    #******************************************************************************
    # retourne la date courante au format de la base de données
    #******************************************************************************
    sub UploadUrlFile
    {
    my ($UrlFileName, $DestFileName) = @_;
	my $sCmd;
	
      UpdateProcessesField ($ENV{PBS_JOBID}, "Status", "D"); #download
      CallbackUrl($ENV{PBS_JOBID},"D");
  
	  if ( $UrlFileName =~ /\/\/www\.youtube\.com/i)
	  {
		  $sCmd = "youtube-dl '$UrlFileName' -o $DestFileName";
	  }
	  else
	  {
		  $sCmd = "wget  -T 30 --no-check-certificate --quiet \"$UrlFileName\" -O $DestFileName";
	  }
      print STDERR "\n".$sCmd ;
      my $Res= lib_utils::Run ( $sCmd );

      if ($Res > 0)
      { #pb de chargement on ne continue pas
        
        print STDERR "\n*******************************************************************";
        print STDERR "\nERROR DOWNLOADING FILE :  Result =$Res" ;
        print STDERR "\n*******************************************************************\n";
        
        TraitementFin($ENV{PBS_JOBID}, '', '', 1026);
        exit($Res);
      }
      print STDERR "\nResultat =$Res" ;
    }

    #******************************************************************************
  # * mise à jour de la table T_Processes pour y mettre a jour les info récupérées
  # * lors de l'exécution de ce script
  #******************************************************************************
  sub UpdateRunningInfos
  {
  my ($rJobId, $rCommandline, $rHostServer, $rHostRunner, $rNbThread) = @_;
   

    $statement = "UPDATE t_processes t SET ".
                 " commandline=\'$rCommandline\', hostserver='$rHostRunner', ".
                 " hostrunner='$rHostRunner' ,".
                 " execnbthread=$rNbThread WHERE (jobid=\"$rJobId\")  ";
    #print $statement;
    #---------------------------------------------- 
    if (! $dbh->ping() )
    {
      DB_Connect();
    }
    $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    print STDERR "sql =$statement";
    print STDERR "\nNombre de lignes :  ".$rv."\n";

  }
  #******************************************************************************
  # * mise à jour de la table T_Processes pour y mettre a jour les info récupérées
  # * lors de l'exécution de ce script
  #******************************************************************************
  sub UpdateRunningInfos2
  {
  my ($rJobId, $rAudioType, $rStatus, $rDate, $rCommandline, $rHostRunner, $rLanguage) = @_;


    $statement = " UPDATE t_processes SET ".
                 " Commandline=\'$rCommandline\', execaudiotype=\'$rAudioType\', status=\"$rStatus\", ".
                 " hostrunner='$rHostRunner', ".
                 " datestart=\"$rDate\", execlanguage=\"$rLanguage\" WHERE (jobid=\"$rJobId\")  ";
    #---------------------------------------------- 
    $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    print STDERR "sql =$statement \n";
    print STDERR "\nNombre de lignes :  ".$rv."\n";

  }

  #******************************************************************************
  # * mise à jour de la table T_Processes pour y mettre a jour les info récupérées
  # * lors de l'exécution de ce script
  #******************************************************************************
  sub UpdateRunningInfos3
  {
  my ($rJobId, $rAudioType, $rStatus, $rDate, $rCommandline, $rHostRunner, $rLanguage, $rCodeRetour) = @_;

    my ($sec,$min,$hour,$mday,$month,$year,$wday,$yday) = lib_utils::GetLocalTime();
    my $DateStop=sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year,$month,$mday,$hour,$min,$sec);



    $statement = " UPDATE t_processes  SET ".
                 " commandline=\'$rCommandline\', execaudiotype=\'$rAudioType\', status=\"$rStatus\", ".
                 " hostrunner='$rHostRunner', ".
                 " ErrorCode= $rCodeRetour, ".
                 " datestop=\"$DateStop\",".
                 " datestart=\"$rDate\", execlanguage=\"$rLanguage\" WHERE (jobid=\"$rJobId\")  ";
    #---------------------------------------------- 
    $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    print STDERR "sql =$statement \n";
    print STDERR "\nNombre de lignes :  ".$rv."\n";

  }

  #******************************************************************************
  # * mise à jour de la table T_AudioFiles pour y mettre a jour les infos de 
  # * taille et de durée
  #******************************************************************************
  sub UpdateAudioFileInfo
  {
  my ($AudioFilename, $filetype) = @_;
  my ($FileSize, $Duration, $cmd);
    
    $FileDuration = 0;
    $FileSize     = 0;
    
    if (! -e $AudioFilename)
    {
      print STDERR "The file $AudioFilename does not exist !! \n";
      return;
    }

    $cmd = "/home/MSF/bin/vplay -fwav:r $AudioFilename 2>&1 |";
    print STDERR "$cmd\n";
    
    open($fh, $cmd ) or print $!;
    while ($line = <$fh>)
    {
    my $_re_totalsize = qr/^total size: (.+) bytes\n/;
    my $_re_duration = qr/^duration: (.+) seconds\n/;
    
      #total size: 4868204 bytes
      #print("$line");
      if ($line =~ $_re_totalsize) 
      { 
        $FileSize =  $1; 
      }
      
      #duration: 304.260 
      if ($line =~ $_re_duration) 
      { 
        $FileDuration = $1; 
      }
    }
  
    close $fh;

    $ENV{AUDIOFILEDURATION}=$FileDuration;

    #-------------------------------------------------------
    # attention pour les fichiers cryptés l'extention n'est pas bonne dans ENV{AUDIOFILE}
    my $FileName;
    $FileName=$ENV{AUDIOFILE};
    if (uc($filetype) eq 'GPG')
    {
      $FileName = "$FileName.$filetype";
    }

    $AudioFilename = basename($AudioFilename);
    $AudioFilename =~s/\.[^\.]+$//;
 
    #partie base de données   
    $statement = "UPDATE t_audiofiles SET filesize='$FileSize',audioduration='$FileDuration' WHERE ".
                 " (refuser=$ENV{IDUSER}) AND (msffilename='$AudioFilename') ";
                 
    print STDERR "\n$statement\n";
    #---------------------------------------------- 
    if (! $dbh->ping() )
    {
      DB_Connect();
    }
    $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
    #print "Nombre de lignes : ".$rv."\n";
    
  }
  
  #******************************************************************************
  # * mise à jour de la table T_Processes pour y mettre a jour les info récupérées
  # * lors de l'exécution de ce script
  #******************************************************************************
  sub UpdateErrorMessage
  {
  my ($rJobId, $rCodeRetour) = @_;
   
    if (!defined($rCodeRetour))
    {
      $rCodeRetour = 1000;
    }

    $statement = "UPDATE t_processes SET errorcode=$rCodeRetour,status='E' WHERE (jobid=\"$rJobId\") "; 

    #avant il y avait  AND (errorcode= $rCodeRetour) en plus ! je ne sais pas pourquoi
    print STDERR "$statement\n";

    #---------------------------------------------- 
    if (! $dbh->ping() )
    {
      DB_Connect();
    }
    $rv = $dbh->do($statement) or die "\nNe peut exécuter la commande $statement: $dbh- >errstr\n";
    print STDERR "Nombre de lignes : ".$rv."\n";
    if ($rv eq  '0E0')
    { # on ecrit un code generique
      print STDERR "Error code not in database\n";
      $statement = "UPDATE t_processes SET errorcode=200,status='E' WHERE (jobid=\"$rJobId\") "; 
      print STDERR "$statement\n";

      $rv = $dbh->do($statement) or die "\nNe peut exécuter la commande $statement: $dbh- >errstr\n";
      print STDERR "Nombre de lignes : ".$rv."\n";
    }
    
  }

  #******************************************************************************
  # * on insere dans le fichier de resultat XML un champ date qui contient la
  # * date de soumission du job qu'on considère comme étant la date de 
  #******************************************************************************
  sub UpdateXmlDateStart
  {
    my ($JobId) = @_;
    my ($statement, $DateSubmit, $ChannelName);

      $statement = "SELECT t.*,c.ChannelName FROM $ENV{DATABASENAME}.T_Processes as t, MSFREC.T_Channels as c ".
                  " WHERE t.JobId=\"$JobId\" AND (t.RefStream=c.IdChannel)";        
      print STDERR "\n*******************************************\n";
      print STDERR "\nUpdateXmlDateStart : ".$statement." \n";
        
      if (! $dbh->ping() )
      {
        DB_Connect();
      }
      $sth = $dbh->prepare($statement);
      $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";

      print STDERR "\nResultat : ".$rv." \n";

      if ($rv eq 1 )
      {
        $hash_ref       = $sth->fetchrow_hashref;
        $DateSubmit     = $hash_ref->{DateStream};
        $ChannelName    = $hash_ref->{ChannelName};
      }
      elsif ($rv eq '0E0' )
      {
          #en mode multicast TV on n'a pas d'info

          $statement = "SELECT * FROM $ENV{DATABASENAME}.T_Processes as t, $ENV{DATABASENAME}.T_Streams as s ".
                        " WHERE ((t.JobId=$JobId) OR (t.JobId = (SELECT C.JobId FROM T_JobIdChildren as C  WHERE C.JobIdChild=$JobId ))) ".
                        " AND (t.RefStream=s.IdStream) ";

          print STDERR "\nUpdateXmlDateStart : ".$statement." \n";

          $sth = $dbh->prepare($statement);
          $rv  = $sth->execute() or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
          if ($rv eq 1 )
          {
            $hash_ref       = $sth->fetchrow_hashref;
            $DateSubmit     = $hash_ref->{DateStream};
            $ChannelName    = $hash_ref->{Url};
          }
      }

      #on a un résultat unique on sort
      if ($rv eq 1 )
      {

        #insere la date dans le fichier
        my ($old,$new,$bak);
        $old = "$LOCAL_RESULT_PATH/$JobId.xml";

        if (! -e $old)
        {
        print STDERR "ERROR File does not exists $old \n";
        return;
        }

        print STDERR $old." \n";

        $new = "$old.tmp.$$";
        $bak = "$old.bak";

        open(OLD, "< $old")         or die "can't open $old: $!";
        open(NEW, "> $new")         or die "can't open $new: $!";

        my $DateInfo ="<Date>$DateSubmit</Date>\n";
        my $ChannelInfo ="<ChannelName>$ChannelName</ChannelName>\n";
        # Correct typos, preserving case
        while (<OLD>)
        {
          if ($. == 3)
          {
            #on ajoute les infos de date et de chaine de TV
            print NEW $DateInfo;
            print NEW $ChannelInfo;
          }
          (print NEW $_)          or die "can't write to $new: $!";
        }

        close(OLD)                  or die "can't close $old: $!";
        close(NEW)                  or die "can't close $new: $!";

        #rename($old, $bak)          or die "can't rename $old to $bak: $!";
        unlink($old); #supprime .bak
        rename($new, $old)          or die "can't rename $new to $old: $!";


      }
      $sth->finish();

      
      return $DateSubmit;
  }
  #******************************************************************************
  # * Traitements fait en fin du script, heure de fin et mise à jour base de 
  # * données
  #******************************************************************************
  sub UpdateAudioSpeakerDuration  
  {
    my ($JobId) = @_;
    my $file;
    my $SpeakerDuration;
    my $FileName;
    
      $SpeakerDuration = 0;
      $FileName         = $LOCAL_RESULT_PATH."/$JobId.xml";
      
      if (! -e $FileName)
      {
        return;
      }
      
      print STDERR "UpdateAudioSpeakerDuration -->$FileName\n";
      
      open FILE, $FileName or die $!;
      while (<FILE>)
      {
          chomp:
          print $_;
          #<Channel num="1" sigdur="30.20" spdur="18.92" nw="60" tconf="0.92"/> 
          
          if(/<Channel[^>]+spdur=\"([^\"]+)\"[^>]+>/)
          {
            $SpeakerDuration+= $1;      
          }
      }
      close(FILE);
       
      #partie base de données
      $statement = "UPDATE T_AudioFiles,T_Processes SET T_AudioFiles.DurationSpeakers=$SpeakerDuration ". 
                    "WHERE (T_Processes.JobId=\"$JobId\") AND (T_Processes.RefAudioFile=T_AudioFiles.IdAudioFile)";

      print STDERR $statement;
      #---------------------------------------------- 
      $rv = $dbh->do($statement) or die "Ne peut exécuter la commande $statement: $dbh- >errstr\n";
  }

    #******************************************************************************
    # on relit le fichier de partitionnement pour rechercher les lignes <Speaker ch=...>
    #******************************************************************************
    sub XmlGetSpeakerQuantity
    {
    my ($XmlFileName) = @_;
      # on relit le fichier de partitionnement pour rechercher les lignes <Speaker ch=...>
      open($fh, $XmlFileName) or print $!;
  
      my $NbLocuteurs = 0;
      while ($line =  <$fh>) 
      { 
        # compte le nombre de lignes <Speaker ch=...>
        my $pos = rindex $line, "<Speaker ch=";
        
        if ($pos != -1 )
        {
          $NbLocuteurs = $NbLocuteurs + 1;
        }
        
        print STDERR $line;
      }
      close $fh;
  
      if ($NbLocuteurs eq 0)
      {
        $NbLocuteurs = 1;
      }
      return $NbLocuteurs ;
  }            

  # *************************************************************************** #
  # XmlSPlitXmlBySpeaker
  #cree les fichiers xml pour chaque speaker et retourne le nombre de speaker
  # *************************************************************************** #
  sub XmlSPlitXmlBySpeaker
  {
    my ($XmlFileName, $XmlOutputFileNamePrefix) = @_;
    my (@channel_nodes, @speaker_nodes, @sseg_nodes, @proc_nodes,  @audio_docs);
    my ( $channel_node, $speaker_node, $sseg_node, $proc_node, $audio_doc);
    
    my $speechsegment_path  = "/AudioDoc/SegmentList/SpeechSegment";
    my $speaker_path        = "/AudioDoc/SpeakerList/Speaker";
    my $channel_path        = "/AudioDoc/ChannelList/Channel";
    my $proc_path           = "/AudioDoc/ProcList/Proc";
    my $audiodoc_path       = "/AudioDoc";
    my $input_file;
    
    #--------  Parse XML/VRBS file  ------------
    my $doc = ParseXml($XmlFileName,"noDTD");

    #--------  lit l'arbre XML  -----------------
    # <AudioDoc name="httpdirect2.yacast.frDATAARRAY3920100726548143505.wma" path="/Aud
    @audio_docs = $doc->getElementsByTagName('AudioDoc');
    $audio_doc = $audio_docs[0];
    
    # <Proc name="vrbs_part" version="2.1"/>
    foreach $proc_node ($doc->findnodes($proc_path)) 
    {
      push @proc_nodes, $proc_node ;
    }

    # <Channel num="1" sigdur="298.98" spdur="278.67"/>  
    foreach $channel_node ($doc->findnodes($channel_path)) 
    {
      push @channel_nodes, $channel_node;
    }

    # <Speaker ch="1" dur="111.34" gender="1" spkid="MS3"/>
    foreach $speaker_node ($doc->findnodes($speaker_path)) 
    {
      push @speaker_nodes, $speaker_node;
    }
    
    # pas d'optimisation si plus de 15 speakers  
    if (@speaker_nodes > 15)
    {
      print STDERR "ERROR : XmlSPlitXmlBySpeaker too many speakers ******************";
      return -1;
    }

    #<SpeechSegment ch="1" sconf="1.00" stime="6.12" etime="13.06" spkid="MS1"/>
    foreach $sseg_node ($doc->findnodes($speechsegment_path)) 
    {
      push @sseg_nodes, $sseg_node;
    }
    
    my $counter=0;
    # on parcours la liste des speakers et on cree autant de fichier que 
    # de speakers, 1 fichier par speaker
    foreach $speaker_node (@speaker_nodes) 
    {
      $counter++;
      my ( $proclist_node, $channellist_node, $speakerlist_node, $sseglist_node );
      my $printed_doc;
      
#      print STDERR "speaker_node= ".$speaker_node->toString(2)."\n\n";
      
      my $output_doc = XML::LibXML::Document->createDocument("1.0","UTF-8");

      my $root = $output_doc->createElement("AudioDoc");
      $root->setAttribute('name',$audio_doc->getAttribute( "name" ));
      $root->setAttribute('path',$audio_doc->getAttribute( "path" ));

      $output_doc->setDocumentElement($root);
    
      $proclist_node = $output_doc->createElement("ProcList");
      foreach $proc_node (@proc_nodes) 
      {
        $proclist_node->appendChild($proc_node);
      }
      $root->appendChild($proclist_node);
    
      $channellist_node = $output_doc->createElement("ChannelList");
      foreach $channel_node (@channel_nodes) 
      {
        $channellist_node->appendChild($channel_node);
      }
      $root->appendChild($channellist_node);

      #n'ajoute que le speaker courant !!    
      $speakerlist_node = $output_doc->createElement("SpeakerList");
      $speakerlist_node->appendChild($speaker_node);
      $root->appendChild($speakerlist_node);
      
      #n'ajoute que les segments du speaker courant !!    
      $sseglist_node = $output_doc->createElement("SegmentList");
      foreach $sseg_node ( @sseg_nodes) 
      {
        if ($sseg_node->getAttribute( "spkid" ) eq $speaker_node->getAttribute( "spkid" ))
        {
          $sseglist_node->appendChild($sseg_node);  
        }
      }
      $root->appendChild($sseglist_node);

#      print STDERR "root =".$root->toString(2)."\n\n";
      

      #Print the document into the output file or STDOUT
      my $fs_output;
      $printed_doc = $output_doc->toString(2);
      $printed_doc =~ s/\n+/\n/g;
      $printed_doc =~ s/^\s*|\s*$//g;
      $printed_doc =~ s/(<Word .*>)\n/$1 /g;
      $printed_doc =~ s/\s+<\/Word>/ <\/Word>/g;
      $printed_doc =~ s/>[ ]+/> /g;
      $printed_doc =~ s/>\s+</>\n</g;
    
      open($fs_output, ">", $XmlOutputFileNamePrefix."_$counter.xml")
        or Log(0, "can't open output file '$XmlOutputFileNamePrefix' <$!>\n" ), return -1;
    
      print $fs_output $printed_doc;
    
      close($fs_output) ;
    }
    
    return $counter;
  }            

#******************************************************************************
#******************************************************************************
# attention 1; DOIT etre mis à la fin d'un module sinon on l'erreur
# "****.pm did not return a true value at****"
#******************************************************************************
1;