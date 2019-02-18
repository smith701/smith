#!/usr/bin/php
<?php
  /* SourceGuardian:DO_NOT_ENCODE */
    /*
      Add to settings.php
      =========================
      //to add a specific script to the script list
      $MsfScriptNames[]="script_vtk_transcription_cacib.php";

     *  */
    
    $OPT_SCRIPTS = getenv("OPT_SCRIPTS");
    $PATH_FILES = getenv("PATH_FILES");

    if (!isset($OPT_SCRIPTS) && (trim($OPT_SCRIPTS) == "") || ($OPT_SCRIPTS === false))
    {
        $OPT_SCRIPTS = "/home/MSF/www/scripts/";
        if (!isset($PATH_FILES) || (trim($PATH_FILES) == "") || ($PATH_FILES === false))
            $PATH_FILES = "/home/MSF/";
        putenv("PATH_FILES=$PATH_FILES");
    }

    set_include_path(get_include_path() . PATH_SEPARATOR . "$OPT_SCRIPTS");
    set_include_path(get_include_path() . PATH_SEPARATOR . "$PATH_FILES/www/Toolbox");
    echo "Lib : $OPT_SCRIPTS\n";

    echo get_include_path();

    $PATH_FILES = getenv("PATH_FILES");
    require_once("$PATH_FILES/www/Toolbox/config.php");
    require_once("divers.php");
    require_once("logs.php");
    require_once("database.php");
    require_once("lib_scripts.php");

    $AUDIOFILE          = getenv("AUDIOFILE");
    $IDUSER             = getenv("IDUSER");
    $JOBID              = getenv("IDPROCESS");
    $user_working_path  = "$msf_user/$IDUSER/" . CST_DIR_WORKING . "/";
    $MSF_AUDIO_PATH     = getenv("PATH_AUDIOFILES");     // ->    /users/Id/media    (NFS)
    $LOCAL_RESULT_PATH = getenv("PATH_RESULTFILES");
    $OPT_MSF_TMP       = getenv("OPT_MSF_TMP");
    
    $MSF_SERVER_IP_ADDRESS = getenv("MSF_SERVER_IP_ADDRESS");
    if (trim($MSF_SERVER_IP_ADDRESS)!="")
      $CST_MSF_IP_ADDRESS = $MSF_SERVER_IP_ADDRESS;
    
    
    $SshPort = getenv("SSH_PORT");
    if (trim($SshPort) != "")
    {
        $PortOpt = "-p $SshPort";
    }
    else
        $PortOpt = "";
    
    $RsyncUsername = getenv("RSYNCUSERNAME");
    
    $CodeRetour = 1;
    $Pwd = CST_MSF_PASSWORD;

    $KEEP_RESULT = getenv("KEEP_RESULT");
    if ($KEEP_RESULT == 0)
        $KEEP_RESULT_WAS_SET = 0;

//we must keep the result to access the local result xml file
    putenv("KEEP_RESULT=1");
    
    $sCmd = "$OPT_SCRIPTS/script_vtk_transcription.php 2>&1";
    echo "\n------------- command ----------------------------------\n";
    echo date('H:i:s') . " : $sCmd\n";
    echo "--------------------------------------------------------\n";
    LOG_Write($sCmd );
 $CodeRetourTrans=0;
 $output="";
    exec($sCmd, $output, $CodeRetourTrans);
echo "CodeRetourTrans=$CodeRetourTrans\n";
    echo "\n";
    foreach ($output as $value)
    {
        echo "$value\n";
	if (strpos($value, 'TRANS_CodeRetour')!==false)
	{
	   $Tmp= explode("=",$value);
           $CodeRetourTrans=$Tmp[1]; 
	}
    }
    echo "\n";

    echo "\n********************************************************************\n";
    echo date('H:i:s') . " : CodeRetourTrans=$CodeRetourTrans\n";
    echo "********************************************************************\n";
    LOG_Write("CodeRetour=$CodeRetourTrans\n");

/*    if (($CodeRetourTrans!=0) && ($CodeRetourTrans!=302)) //302 : no speeck detected
    {
        $LogText = "error;transcription failed, no mail sent, code=$CodeRetourTrans, message=".DB_GetErrorMessage($CodeRetourTrans)."\n ";
        echo $LogText;
        LOG_Write($LogText, false, "stats.log");  
        return RET_ERROR;
    }*/
    $body = "";
    
    //*************************************************
    $path_parts = pathinfo($AUDIOFILE);
    $ResFileName = $path_parts ['filename'];

    //copie du json du frontal dans /users/id/media/nom_audio.json vers la machine de traitement
    CopyRemoteFileToLocal($CST_MSF_IP_ADDRESS, $RsyncUsername, "", $PortOpt, "$MSF_AUDIO_PATH$ResFileName.json", "$user_working_path/$ResFileName.json");

    
    $MetadataToPrint="";
    $JsonFileName = "$user_working_path/$ResFileName.json";
    if (file_exists($JsonFileName))
    {
        $JsonFile = file_get_contents($JsonFileName);
        $Data = json_decode($JsonFile, true);
        
        //à la demande de Lamiae le 22/06/2017 on supprime l'@ IP du recorder
        if (isset($Data["recorder_ip"]))
            unset($Data["recorder_ip"]);
        
        //on réécrit le json avec le cham en moins
        $JsonFile = json_encode($Data);
        file_put_contents($JsonFileName, $JsonFile);
        
        $Value = $Data["field"];
        foreach ($Data as $key => $value)
        {
            print_r($value);
            if (is_array($value))
            {
                foreach ($value as $value2)
                    if (is_array($value2))
                        foreach ($value2 as $key3 => $value3)
                            $MetadataToPrint .= "$key3:$value3<br/>";

            }
            else
                $MetadataToPrint .= "$key:$value<br/>";
        }        
    }
    else
    {
        $JsonFile="";
        $body = "<b><font color=\"red\">ERROR</font> : missing json file on MSF, it's a bug, please contact the support ($JsonFileName)</b><br><br><br><br>";
    }

    //initialisation des champs à retourner
    $Confidency['Sum']  = 0;
    $Confidency['Qt']   = 0;
    $QtSpeakers         = 0;
    $SpkWords           = "";
    $QtWords            = 0;
    $SpkConfidency      = "";
    $SpeechDuration     = 0;
    $ConfidencyScore    = 0;
    $SpeechDensity      = 0;
    $RT                 = 0;
    
    //que si on a la transcription qui a bien fonctionné
    if ($CodeRetourTrans==0)
    {
        
        //*******************************
        //on va ajouter le json dans le xml de résultat dans une balise metadata
        echo "Add the json into the xml result file\n";
        $Xml    = file_get_contents("$user_working_path/$JOBID.xml");
        $XmlNew = str_replace("</AudioDoc>", "<call_metadata>\n$JsonFile\n</call_metadata>\n</AudioDoc>",$Xml);
        //echo "\n$XmlNew\n";
        file_put_contents("$user_working_path/$JOBID.xml", $XmlNew);

        //on recopie vers le frontal le xml
        CopyLocalFileToRemote($CST_MSF_IP_ADDRESS, $RsyncUsername, "", $PortOpt, "$user_working_path/$JOBID.xml", "$LOCAL_RESULT_PATH/$ResFileName.xml");
        CopyLocalFileToRemote($CST_MSF_IP_ADDRESS, $RsyncUsername, "", $PortOpt, "$user_working_path/$JOBID.xml*", "$user_working_path/");

    /*    echo "*****************************************************************\n";
        echo "1 : analyse du xml\n";
        var_dump($XmlNew);*/

        foreach (explode("\n", $XmlNew) as $Line)
        {
            //echo ">$Line\n";
            if (strstr($Line, "<Speaker ")!==false)
            {
                $ret = preg_match_all('/<Speaker ch=\"([^\"]+)\" dur=\"([^\"]+)\" gender=\"([^\"]+)\" spkid=\"([^\"]+)\" lang=\"([^\"]+)\" lconf=\"([^\"]+)\" nw=\"([^\"]+)\" tconf=\"([^\"]+)\"(\sdensity=\"([^\"]+)\")?\/>/', $Line, $Temp);
    //            DIV_Dump($ret);
    //            DIV_Dump($Temp);
                $QtSpeakers++;
                if ($ret !== false)
                {
                    $Language[$Temp[5][0]]=true; //table de hash
                    $SpkWords .= $Temp[4][0]."=".$Temp[7][0]." ";
                    $SpkConfidency .= $Temp[4][0]."=".$Temp[8][0]." ";
                }
            }

            if (strstr($Line, "<Channel ")!==false)
            {
                //<Channel num=\"([^\"]+)\"" sigdur=\"([^\"]+)\" spdur=\"([^\"]+)\" nw=\"([^\"]+)\" tconf=\"([^\"]+)\"/>
                $ret = preg_match_all("/<Channel num=\"([^\"]+)\" sigdur=\"([^\"]+)\" spdur=\"([^\"]+)\" nw=\"([^\"]+)\" tconf=\"([^\"]+)\"(\sdensity=\"([^\"]+)\")?\/>/", $Line, $Temp);
                DIV_Dump($ret);

                if ($ret !== false)
                {
                    var_dump($Temp);
                    $Confidency['Sum']  += $Temp[5][0];
                    $SpeechDensity      += $Temp[6][0];
                    $Confidency['Qt']   += 1;
                    $SpeechDuration     += $Temp[3][0];
                    $QtWords            += $Temp[4][0];
                }

            }        

        }

        if ($Confidency['Qt'] == 0)
            $ConfidencyScore =0;
        else
            $ConfidencyScore = $Confidency['Sum'] / $Confidency['Qt'];

        echo "*****************************************************************\n";
        echo date('H:i:s') . " : résultats analyse\n";
        var_dump($Confidency);
        var_dump($Language);
        echo "*****************************************************************\n";
        //*******************************

        //envoi email à Symantec

        $UserInfos   = DB_GetUserInformations($IDUSER);
        //$To = "ale@amisw.com";
        $To          = $UserInfos ["info_emailaddress"];

        $Subject     = "S".sprintf("%03d", ($ConfidencyScore*100))."_VOTTEX_Transcription_Duration_".$SpeechDuration."_NTR".$Data["ntr_id"]."_".$Data['ntr_user_id']."_CALL".$Data["cvs_key"]."";

        if ($CodeRetourTrans==302)
        {
            $HtmlText    = "No speech detected";
        }
        else
        {
            $HtmlText    = DIV_Xml2Html("$user_working_path/$JOBID.xml");
        }
        $LangList    = "";

        foreach ($Language as $key => $value)
        {
            $LangList .= "$key ";
        }

        //le $RT est lu dans le fichier de log
        /*$Cmd = "grep \"state=end\" $OPT_MSF_TMP/$JOBID.log | grep \"RT=\"";
        $tmp = system($Cmd, $ret);
        $RT = 0;
        if ($ret == 0)
        {
            if (strlen($tmp) > 3)
            {
                $RT = substr($tmp, strpos($tmp, "RT=") + 3);
            }
        }*/
        
        $DataJob = DB_GetJobStatusFull($IDUSER, $JOBID);
        var_dump($DataJob);
        $RT = (strtotime($DataJob["datestop"]) - strtotime($DataJob["datestart"]))/$DataJob["audiodurationseconds"];
        echo "from DB :  RT=$RT\n";


        $body        = "<br/>Language:$LangList<br/>";
        //$body       .= "<br/>$MetadataToPrint<br/>";
        $body       .= "Text: <br/>".$HtmlText['text']."<br/>";

        //$url_player = "http://localhost:8000/dev/MediaEditor.php?jobid=" . $JOBID . "&NoCheckUser=1&UriAudio=" . $MSF_AUDIO_PATH . $AUDIOFILE . "&UriXml=" . $MSF_RESULT_PATH . "/" . $JOBID . xml . "&IdUser=1";
        $body       .= "<br><br>Please find the transcription and Metadata attached.<br><br>";

        DIV_Xml2Txt("$user_working_path/$JOBID.xml", "$user_working_path/$ResFileName.txt");

        $attachement[] = "$user_working_path/$ResFileName.txt";
        $attachement[] = "$user_working_path/$ResFileName.json";
        copy("$user_working_path/$JOBID.xml", "$user_working_path/$ResFileName.xml");
        $attachement[] = "$user_working_path/$ResFileName.xml";


        $HeadersMail  = "to:$To\n";
        $HeadersMail .= "from:msf@mediaspeech.com\n";
        $HeadersMail .= "subject:$Subject\n";

        function FillHeader($Field, $value)
        {
            $Prefix="X-Kvs-";
            //$Prefix="";
            
            if (isset($value))
            {
                return "$Prefix$Field:$value\n";
            }
            else
            {
                return "$Prefix$Field:<empty>\n";
            }
        }
        $Headers  = "";
        $Headers .= FillHeader("MessageType",           "Hermes");
        $Headers .= FillHeader("firstname",             $Data["user_firstname"]);
        $Headers .= FillHeader("lastname",              $Data["user_lastname"]);
        $Headers .= FillHeader("phone_number_calling",  $Data["phone_number_calling"]);
        $Headers .= FillHeader("phone_number_called",   $Data["phone_number_called"]);
        $Headers .= FillHeader("call_direction",        $Data["call_direction"]);
        $Headers .= FillHeader("call_start_time",       $Data["call_start"]);
        $Headers .= FillHeader("call_end_time",         $Data["call_end"]);
        $Headers .= FillHeader("call_utc_start_time",   $Data["call_start_utc"]);
        $Headers .= FillHeader("call_utc_end_time",     $Data["call_end_utc"]);
        //ajouté le 08/06/17
        $Headers .= FillHeader("call_start_milli",      $Data["call_start_milli"]);
        $Headers .= FillHeader("call_end_milli",        $Data["call_end_milli"]);
        $Headers .= FillHeader("cdr_or_vox",            $Data["call_type"]);
        $Headers .= FillHeader("ntr_id",                $Data["recorder"]);
        $Headers .= FillHeader("UT_CODE",               $Data["user"]); //code UT
        $Headers .= FillHeader("NTR_User_ID",           $Data["user_id"]); //code UT
        $Headers .= FillHeader("_id",                   $Data["_id"]);
        $Headers .= FillHeader("recorder_channel",      $Data["channel_id"]);
        $Headers .= FillHeader("call_duration",         date('H:i:s', mktime(0,0,$Data["call_duration"]))); //format H:M:S
        $Headers .= FillHeader("ntr_call_id",           $Data["cvs_key"]);
        $Headers .= FillHeader("file",                  $Data["file"]);
        $Headers .= FillHeader("audio_nas_location",    $Data["audio_nas_location"]);
        $Headers .= FillHeader("nas_audio_location",    $Data["nas_audio_location"]);
        $Headers .= FillHeader("language",              $LangList);
        $Headers .= FillHeader("confidence",            $ConfidencyScore);
        $Headers .= FillHeader("speech_density",        $SpeechDensity);
        $Headers .= FillHeader("QtSpeakers",            $QtSpeakers);
        $Headers .= FillHeader("QtWords",               $QtWords);
        $Headers .= FillHeader("SpeakerConfidence",     $SpkConfidency);
        $Headers .= FillHeader("SpeakerWords",          $SpkWords);
        $Headers .= FillHeader("archive_retention_date",$Data["retention_date"]);

        //ajouté le 07/06/17
        $Headers .= FillHeader("nas_location",          $Data["nas_location"]);

        //ajouté le 12/09/17
        $Headers .= FillHeader("SpeechDuration",          $SpeechDuration);
        $Headers .= FillHeader("RT",                      $RT);
        
        echo "HEADER:\n$Headers\n";
        //echo "BODY:\n$body\n";
        if (file_exists("/usr/bin/mutt"))
        {
            $Attached  ="";
            if (count($attachement)>0)
            {
                foreach ($attachement as $value)
                {
                    if (file_exists($value))
                        $Attached .= " -a $value ";
                }
            }
            $HeaderFileName = tempnam("/tmp", "mutt_");
            file_put_contents($HeaderFileName, $HeadersMail.$Headers);

            $BodyFileName = tempnam("/tmp", "mutt_");

            $body = str_replace("\n", "<br/>", $Headers).$body;
            $body = $body;
            file_put_contents($BodyFileName, "<html><head><meta charset=\"UTF-8\"> </head><body>$body</body></html>");

            echo "--------------------------------------------------------------\n";
            echo "Sending an email : \n";
            $sCmd = "mutt -e \"set content_type=text/html charset=utf-8 config_charset=utf-8 locale=en_US.UTF-8 config_charset=utf-8\" -H $HeaderFileName $Attached < $BodyFileName";
            echo "$sCmd\n";
            LOG_Write($sCmd);

            $output="";
            exec($sCmd, $output, $CodeRetourMail);
            if ($CodeRetourMail != 0)
            {
                    $log_msg = "error;email failed, code=$CodeRetourTrans";
                    LOG_Write($log_msg);
            }
            echo "ret code = $CodeRetourMail\n";
            var_dump($output);
            echo "penser à supprimer les fichiers tmp !!\n";


            // Suppression des transcriptions dans le log <job_id>.log
            $sCmd = "sed -i '/^ifile_SPK/d' $OPT_MSF_TMP/$JOBID.log";
            exec($sCmd, $output, $CodeRetourDelTransLog);
        }
        else
        {
            $Tmp= "!!!!!!!!!!!!!!!!!! MUTT not installed cannot send email with P2 header !!!!!!!!!!!!! ";
            echo "$Tmp\n";
            LOG_Write($Tmp);
            DIV_SendAnEmailWithAttachement($To, $Subject." : Mutt not install, no P2 header used", $HeadersMail.$Headers."\n".$body, $attachement);
        }
    }//if ($CodeRetourTrans==0)
    
    //*************************************************************************
    //écriture dans un fichier de log à envoyer par email tous les jours
    $AllFields =$JOBID.";".
		$Data["user_firstname"].";".
                $Data["user_lastname"].";".
                $Data["phone_number_calling"].";".
                $Data["phone_number_called"].";".
                $Data["call_direction"].";".
                $Data["call_start"].";".
                $Data["call_end"].";".
                $Data["call_start_utc"].";".
                $Data["call_end_utc"].";".
                $Data["call_start_milli"].";".
                $Data["call_end_milli"].";".
                $Data["call_type"].";".
                $Data["ntr_id"].";".
                $Data["user"].";". //code UT
                $Data["user_id"].";". //code UT
                $Data["_id"].";".
                $Data["channel_id"].";".
                date('H:i:s',mktime(0,0,$Data["call_duration"])).";".
                $Data["cvs_key"].";".
                $Data["file"].";".
                $Data["audio_nas_location"].";".
                $Data["nas_audio_location"].";".
                $LangList.";".
                $ConfidencyScore.";".
                $SpeechDensity.";".
                $Data["nas_location"].";".
		$QtWords.";".
		$QtSpeakers.";".
		$SpkConfidency.";".
		$SpkWords.";".
		$SpeechDuration.";".
                $RT.";"         ;

    if ($CodeRetourTrans != 0)
    {
	$LogText =  ";error;".
                $AllFields.
		DB_GetErrorMessage($CodeRetourTrans).";";
    }
    else
    {
        $LogText =  ";success;".
                $AllFields;
    }
 		
    LOG_Write($LogText, false, "stats.log");  
    //chaque jour un script renomme le fichier et l'envoie par email à Cacib
    //*************************************************************************

    /*
      $Cmd = "cd $MSF_RESULT_PATH; wput --timeout=30 $ResFileName.xml \"$RESULTINFO\"";
      echo "$Cmd \n";
      $tmp = system($Cmd, $ret);
     */

    if (isset($KeepTranscriptionLogs)&& ($KeepTranscriptionLogs))
        $KEEP_RESULT_WAS_SET = 1;
    
    //erase the results if it was asked
    if (!$UseNfsShares && ($KEEP_RESULT_WAS_SET != 1))
    {
        $sCmd = "rm -f $user_working_path/$ResFileName.* $LOCAL_RESULT_PATH/$ResFileName.* $MSF_AUDIO_PATH$AUDIOFILE $user_working_path/$JOBID.xml";
        echo "$sCmd\n";
        exec($sCmd, $output, $CodeRetourSuppRes);
	if ($CodeRetourSuppRes != 0)
        {
        	$log_msg = "error;erase result failed, jobid=$JOBID, code=$CodeRetourSuppRes";
                LOG_Write($log_msg);
        }

        //supprime répertoire de log
        if (($CodeRetourTrans == 0) || (($CodeRetourTrans != 0) && (!isset($KeepTranscriptionLogsOnError) || ($KeepTranscriptionLogsOnError==false))))
        {
            $sCmd = "rm -rf $OPT_MSF_TMP/$JOBID";
            echo "$sCmd\n";
            exec($sCmd, $output, $CodeRetourSuppLog);
        }
        
	if ($CodeRetourSuppLog != 0)
        {
                $log_msg = "error;delete log directory failed, jobid=$JOBID, code=$CodeRetourSuppLog";
                LOG_Write($log_msg);
        }

        //supprime et pièce jointes du mail
        foreach ($attachement as $value)
        {
            unlink($value);
        }
        
        //supprimer le contenu du mail, boday et header
        unlink($HeaderFileName);
        unlink($BodyFileName);
    }

    exit($CodeRetourTrans);
    