<?php

/* pour tester on peut faire 
 * https://10.0.0.3/rest/?function=login&username=msf&password=xxx
 * https://10.0.0.3/rest/?function=trans&filename=PhilippePelletierObama.wav&type=bn&language=fre
 * https://10.0.0.3/rest/index2.php?function=trans&filename=PhilippePelletierObama.wav&type=bn&language=fre
 * https://10.0.0.3/rest/?function=result&jobid=400348.msf01
 * http://10.229.190.20/dev/rest/index.php?function=transcacib&filename=test-eng.wav&type=bn&language=eng&meta=http://10.229.190.20/tmp/pp.json
 * */

require_once("../Toolbox/config.php");
require_once("../Toolbox/database.php");
require_once("../Toolbox/divers.php");
require_once("../Toolbox/logs.php");
require_once("../Toolbox/transcription.php");
require_once("../Toolbox/msf_class.php");


global $ExtensionsAccepted;
global $_SESSION;

/* * ****************************************************************************
 * **************************************************************************** */

function ReturnedStatus($ErrorCode, $ExitCode=true)
{
    $Message = DB_GetErrorMessage($ErrorCode);
    echo "status=$ErrorCode\n";
    echo "message=$Message\n";
    echo "\n";
    if ($ExitCode)
        exit;
}

/* * ****************************************************************************
 * **************************************************************************** */
$result = "";
$ErrorCode = RET_ERROR;
$Fct = DIV_ReadParams(array('function'));


if ($MAINTENANCE_EN_COURS == 1)
{
    ReturnedStatus(RET_MAINTENANCE_IN_PROGRESS);
}

//on vérifie qu'on est bien en cours de session
if ($Fct[0] != "login")
{
    LOG_Write("Acces rest : " . $_SESSION['login'] . $Fct[0]);
    if (!DIV_SessionOK(NULL, NULL))
    {
        ReturnedStatus(RET_LOGIN_NEEDED, false);
        if (isset($Fct[0]))
        {
            echo "\nfunction=" . $Fct[0] . "\n";
        }

        echo "<br><a href=\"/download.php?file=MSF_SpecificationsInterfaceHttp.pdf\" class=\"piwik_download\">Download Specifications</a><br>";
        echo "<a href=\"exemple.java\" >Example in Java</a><br>";
        echo "<br><br>Below is a simple example using wget<br>";
        echo "wget --cookies=on --no-check-certificate --keep-session-cookies --save-cookies=cookie.txt --post-data 'username=UUU&password=PPP'   https://mediaspeech.com/rest/?function=login -O ./res.txt <br>";
        echo "wget --cookies=on --no-check-certificate  --load-cookies=cookie.txt --keep-session-cookies --save-cookies=cookie.txt https://mediaspeech.com/rest/?function=trans\&type=bn\&filename=audio.mp3\&language=fre\&quality=2 -O ./res.txt<br>";
        echo "wget --cookies=on --no-check-certificate  --load-cookies=cookie.txt --keep-session-cookies --save-cookies=cookie.txt https://mediaspeech.com/rest/?function=status\&jobid=III -O res.xml<br>";
        echo "wget --cookies=on --no-check-certificate  --load-cookies=cookie.txt --keep-session-cookies --save-cookies=cookie.txt https://mediaspeech.com/rest/?function=result\&jobid=III\&format=xml -O ./res.xml         <br>";
        exit;
    }
}

$MSF = new msf_class();
$MSF->SetSource(CST_SRC_REST);

//on regarde la fonction demandée
switch ($Fct[0])
{
    //-----------------------------
    case "login" :
        {
            $Args = DIV_ReadParams(array('username', 'password'));
            $ErrorCode = $MSF->login($Args[0], $Args[1]);
            break;
        }
    //-----------------------------
    case "cancel" :
        {
            //on lit le job id passé en paramètre
            $Args = DIV_ReadParams(array("jobid"));
            $ErrorCode = $MSF->cancel($Args[0]);
            break;
        }
    case "delete" :
        {
            //on lit le job id passé en paramètre  le nom du fichier audio sélectionné
            $Args = DIV_ReadParams(array("filename", "jobid"));
            if (isset($Args[0]))
                $ErrorCode = $MSF->delete($Args[0]);
            else if (isset($Args[1]))
                $ErrorCode = $MSF->delete($Args[1]);
            
            break;
        }
    //-----------------------------
    case "logout" :
        {
            $ErrorCode = $MSF->logout();
            break;
        }
    //-----------------------------
    case "result" :
        {
            //on lit le job id passé en paramètre
            $Args = DIV_ReadParams(array("jobid", "format"));
            //DIV_Dump($Args);
            $ErrorCode = $MSF->result($Args[0], $Args[1], $liste);
            //var_dump($liste);
            break;
        }
    //-----------------------------
    case "waitandgetresult" :
        {
            //on lit le job id passé en paramètre
            $Args = DIV_ReadParams(array("jobid", "format"));
            //DIV_Dump($Args);
            $ErrorCode = $MSF->waitandgetresult($Args[0], $Args[1], $liste);
            break;
        }
    //-----------------------------
    case "status" :
        {
            //on lit le job id passé en paramètre ! OPTIONNEL !
            $Args = DIV_ReadParams(array("jobid"));
            $ErrorCode = $MSF->status($Args[0], $liste);
            break;
        }
    //-----------------------------
    case "trans" :
        {
            $Args = DIV_ReadParams(array("filename", "type", "language", "channel", "quality", "duration", "callback", "corpus", "resultinfo"));
            $ErrorCode = $MSF->trans($Args[0], $Args[1], $Args[2], $Args[3], $Args[4], $Args[5], $Args[7], $JobId, $Args[6], "",$Args[8]);
            break;
        }
    //-----------------------------
    case "transwithmeta" :
        { //10.229.190.20/dev/rest/index.php?function=transwithmeta&meta=http://10.229.190.20/tmp/pp.json
            $Args = DIV_ReadParams(array("filename", "type", "language", "channel", "quality", "duration", "callback", "corpus", "resultinfo", "meta"));
            LOG_Write("transwithmeta");
            LOG_Write($Args);
            if (isset($Args[0]))
            {
                global $WgetCertificatArguments;
                 $FileName=DIV_ConvertUrlFileName($Args[0]);
                 $FileName=DIV_ReplaceExtension ($FileName, "json");
                 LOG_Write($FileName);

                $FileName= "/users/".$_SESSION['IdUser']."/media/$FileName"; 

                //$sCmd = "wget  -T 30 --no-check-certificate --quiet \"".$Args[9]."\" -O $FileName";
                $sCmd = "wget  -T $WgetTimeout $WgetCertificatArguments  \"".$Args[9]."\" -O $FileName";
                LOG_Write ($sCmd);
                exec($sCmd, $out, $Res);
		LOG_Write($Res);
		LOG_Write($out);
            }

            $ErrorCode = $MSF->trans($Args[0], $Args[1], $Args[2], $Args[3], $Args[4], $Args[5], $Args[7], $JobId, $Args[6], "",$Args[8]);
            break;
        }
    //-----------------------------
    case "lid" :
        {
            $Args = DIV_ReadParams(array("filename", "offset", "duration", "quality"));
            $ErrorCode = $MSF->lid($Args[0], $Args[1], $Args[2], $Args[3], $JobId);
            break;
        }
    //-----------------------------
    case "part" :
        {
            $Args = DIV_ReadParams(array("filename", "type", "channel", "speaker"));
            $ErrorCode = $MSF->part($Args[0], $Args[1], $Args[2], $Args[3], $JobId);
            break;
        }
    //-----------------------------
    case "alignment" :
        {
            $Args = DIV_ReadParams(array("filename", "type", "language", "textfiletoalign", "callback"));
            $ErrorCode = $MSF->alignment($Args[0], $Args[1], $Args[2], $Args[3], $Args[4]);
            break;
        }
    //-----------------------------
    case "upload" :
        {
            $ExtensionsAccepted2 = $ExtensionsAccepted;
            $ExtensionsAccepted2[] = 'xml';
            $ErrorCode = DIV_HandleUploadedFile($_SESSION['IdUser'], $_FILES['filename'], $ExtensionsAccepted2);
            break;
        }
    //-----------------------------
    default:
        {
            $ErrorCode = RET_FCT_NOT_IMPLEMENTED;
        }
}
//-----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------


$Message = DB_GetErrorMessage($ErrorCode);

ReturnedStatus($ErrorCode, false);

//on affiche éventuellement le JobId
if (isset($JobId))
    echo "jobid=$JobId\n";

if (isset($liste))
{
    foreach ($liste as $Line)
    {
        echo $Line;
    }
}
LOG_Write(__FUNCTION__ . $Fct[0] . " ret=" . $ErrorCode);


