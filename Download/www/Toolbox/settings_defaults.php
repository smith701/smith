<?php
  /* SourceGuardian:DO_NOT_ENCODE */
  namespace Toolbox;
  use Toolbox\msf_class_sched_slurm;
  use Toolbox\msf_class_sched_pbs;
  use Toolbox\msf_class_sched_proc;
  use Toolbox\msf_class_sched_activemq;
  
  require_once ("const.php");
  
  $CLUSTER_ID          = "msf"; 
  $CustomerName        = "customer name";
  
  //suffix for jobid, full job id name = 12345.msf01.msf.lan
  define('CST_MSF_PBS_JOB_SUFFIX', ".frontal1");
  
  
  $CST_MSF_IP_ADDRESS= "127.0.0.1";
  
  $Ip = getenv("MYSQL_IP_ADDRESS"); //utile sur HPCSPOT
  if ((!isset($Ip)) || (trim($Ip)==""))
  {
    //MySQL server IP address
    define('CST_MYSQL_IP_ADDRESS', $CST_MSF_IP_ADDRESS);

    //MySQL admin account to access MSF database
    define('CST_MYSQL_ADMIN_LOGIN', "root");

    //MySQL admin password 
    define('CST_MYSQL_ADMIN_PASSWORD', "msflite01");
  }
  else
  {
    define('CST_MYSQL_IP_ADDRESS',     getenv("MYSQL_IP_ADDRESS"));
    define('CST_MYSQL_ADMIN_LOGIN',    getenv("MYSQL_ADMIN_LOGIN"));
    define('CST_MYSQL_ADMIN_PASSWORD', getenv("MYSQL_ADMIN_PASSWORD"));
  }
  
  //===================================================================
  //list of DB server, (DB_type => @IP)
  global $DatabaseServerList;
  $DB1 = array( "type"    => "mysql",
                "ip"      => CST_MYSQL_IP_ADDRESS,
                "login"  => CST_MYSQL_ADMIN_LOGIN, 
                "password" => CST_MYSQL_ADMIN_PASSWORD);
  
  $DatabaseServerList = array($DB1);
  //var_dump($DatabaseServerList);
  //===================================================================
  
  
  //MSF user msf password 
  define('CST_MSF_PASSWORD', "msflite01");

  //encrypt password in database
  define('CST_CRYPT_PASSWORD', true);
  //!!!!! ---> in "/etc/pure-ftpd/pureftpd-mysql.conf" SET "MYSQLCrypt" to "md5"

  //log each login to the system
  define('CST_LOG_LOGIN', false);

  //do we log into files
  define('CST_DO_LOG', true);
  $HidePasswordInLog  = true;
  
  //define the scheduler used by MSF
  global $SchedulerType;
  //$SchedulerType = SCHED_PBS;
  //$SchedulerType = SCHED_PROC;
  $SchedulerType = SCHED_SLURM;
  //$SchedulerType = SCHED_ACTIVEMQ;

  //set to true if you want to use less cores on small files
  global $SchedulerOptimizeCores;
  $SchedulerOptimizeCores = array ("enabled"   => true, // true or false
                                   "maxlength" => 60,   // if audio duration is less than maxlength
                                   "nbcore"    => 1);   // then use only nbcore

  // access path to PBS
  global $pbs_bin;
  $pbs_bin = "/opt/pbs/default/bin"; //pbs
  //$pbs_bin = "/usr/local/bin"; //torque

  // access to activemq
  global $activemq_uri,$activemq_username, $activemq_password, $activemq_used_for_result;
  $activemq_uri               = 'tcp://127.0.0.1:61613'; //stomp 61613, si java 61616
  $activemq_username          = "system";
  $activemq_password          = "admin";
  $activemq_used_for_result   = false;    //send result to activeMQ from PHP
    
  //access to slurm
  global $slurm_bin;
  global $slurm_cluster;
  global $slurm_account;
  
  $slurm_bin = "/usr/bin/";
  $slurm_cluster = "msf";
  $slurm_account = "transcription";
  
  //langue de l'interface web de MSF
  global $msf_language;
  $msf_language = "en";
  
  $msf_home = "/home/MSF/";
  
  global $msf_vecsys_transcription_path;
  $msf_vecsys_transcription_path = "/usr/local/vecsys/trans";
  
  //runner list
  //$RunnerList="lame01:lame02:lame03";
  $RunnerList="localhost";
  
  //default time zone for dates/time
  $DefaultTimeZone = 'Europe/Paris';
  

  global $UseNfsShares;
  $UseNfsShares = true; //if false -> needs : sshpass

  //global $UseMplayer;
  //$UseMplayer = false;
  
  //use Linux Login and Password authentication
  //$UseLinuxLogin = true;
  
  //set it if tunning on a master nis, that need make -C /var/yp to be done
  //$IsTheMasterNIS = true;
  
  //to add a language
  //$LanguageAvailable["cts"]["eng"] = "English";
  
  //to add a specific script to the script list
  //$MsfScriptNames[]="script_vtk_transcription_xxx.php";
  
  //scheduler priorities
  $MsfSlurmPriority= array("pri_verylow",
                        "pri_low" ,
                        "pri_normal",
                        "pri_high" ,
                        "pri_veryhigh");
  $MsfSlurmPriorityDefault="pri_normal";

  //always keep the logs
  $KeepTranscriptionLogs = false;
  
  //keep the logs when the transcription fails
  //$KeepTranscriptionLogsOnError = true;
  
  $UseLid = false; //incompatible with $UseSid, only one at true
  $UseSid = false;//incompatible with $UseLid, only one at true
  
  //list the languages detectable with LID
  //$LidLangList =  "fre,eng,spa,ita,rus";

  //wget timeout (when downloading url files to trancribe
  //$WgetTimeout             = 30;
  
  //specific local certificate when using https
  //$WgetCertificatArguments     = "--ca-certificate=/path.to/cert.cer";
  
  //deny the access of the play button, and all links to any result
  //$DisablePlayer = 1;
  
  //transcribe files with different languages in it
  //$TranscriptionMultiLanguage=1;
