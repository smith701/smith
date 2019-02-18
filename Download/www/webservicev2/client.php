<?php

require_once("../Toolbox/WebserviceMSFv2.php");
require_once("../Toolbox/logs.php");
require_once("../Toolbox/settings.php");

/* * **************************************************************************
 * affiche le résultat renvoyé par le serveur
 * ************************************************************************** */

function DisplayResult($fct, $res)
{
    echo '<br>----------------------------------<br>';
    echo '<H2>Command : <b>' . $fct . " </b></H2><br>";

    if (isset($res))
    {
        $res = str_replace(">", ">\n", $res);
        $res = nl2br(htmlentities($res));
        echo $res;
    }
}

/* * **************************************************************************
 * sert à appeler les objets directement car avec SOAP impossible de debogger 
 * ************************************************************************** */

function Test()
{
    global $_SESSION;
    $_SESSION['IdUser'] = 1;
    $_SESSION['Role'] = 'U';

echo"WebserviceMSFv2 Test<br>";
    $MSF = new WebserviceMSFv2();
    $MSF::$Source = CST_SRC_SOAP;
    DIV_Dump($MSF->login('msf', CST_MYSQL_ADMIN_PASSWORD));
    DIV_Dump($MSF->status('2839796'));
    
    
    //DIV_Dump( $MSF->result('1436820', 'srt'));
    //DIV_Dump($MSF->delete('1191105.msf01'));
    //DIV_Dump($MSF->senddata( "email://mlemeur@vecsys.fr", " Il  fait  beau  aujourd&apos;hui"));
    //DIV_Dump($MSF->senddata( "sms://0645140781", " Il  fait  beau  aujourd&apos;hui"));
    //DIV_Dump($MSF->speakeridaddspeaker ('007', 'speaker soap','audio_spkctrn.wav','commentaire soap','fre'  ));
    //DIV_Dump($MSF->speakerid("audio_spka.wav", "cts", "fre", "55:7", "", NULL));
    //DIV_Dump($MSF->speakeridremovespeaker('7' ));
    //DIV_Dump( $MSF->alignment('audio_spkatrn.wav', 'bn', 'eng', 'testalign.txt', ''));


    //DIV_Dump( $MSF->translate('252900.msf01', 'eng'));
    /*    var_dump($MSF->streamregister('rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=100004',
      'https://10.0.0.3/dev/CallbackStreams.php',
      'fre',
      '1'));*/

    //DIV_Dump( $MSF->trans('audio_spkbtrn.wav.tmp.wav', 'bn', 'fre', '0', '0', '0','','',''));
    //DIV_Dump( $MSF->callmining('edfpart_h5_fre_200129137406277249.wav',  'fre', 'edfpart_h5_fre_200129137406277249.thales.xml', ''));
    //DIV_Dump( $MSF->lid('audio_spkbtrn.wav', 'cts', '0', '0'));
    //DIV_Dump( $MSF->part('audio_spkbtrn.wav', 'cts', 0, 0));
    //var_dump( $MSF->status('27420.msf01'));
    //var_dump( $MSF->result('27420.msf01'));
    //DIV_Dump( $MSF->waitandgetresult('696913.msf01'));

    //$f = file_get_contents("/tmp/aa.wav");
    //var_dump( $MSF->upload('aa.wav', $f));

    //echo '************************************<br><br>';
}

/* * **************************************************************************
 * ************************************************************************** */
Test();
exit;

    // On désactive la mise en cache du wsdl (pour le test)
    ini_set('soap.wsdl_cache_enabled', 0);

echo "ppp";
    try
    {
        if ($DEV_EN_COURS == 1)
        {
            $Url = 'https://10.0.0.3/dev/webservice/serverdev.wsdl';
            echo "DEV<br>";
        }
        else
        {
            /*                  ATTENTION
             * pour tester en mode non dev, il faut que client.php et autres
             * soient en local sur un PC et pas sur le serveur
             * Sur le serveur ça ne marche pas à cause de routes qui entrent et sortent
             * pour cette adresse.
             * 
             * On obtient un message du type :
             * ===============================
             * *https://88.168.148.91/webservice/server.wsdl*
             * SoapFault exception: [WSDL] SOAP-ERROR: Parsing WSDL: Couldn't load from 'https://88.168.148.91/webservice/server.wsdl' : 
             * failed to load external entity "https://88.168.148.91/webservice/server.wsdl" in /home/MSF/www/webservice/client.php:72 
             * Stack trace: #0 /home/MSF/www/webservice/client.php(72): SoapClient->SoapClient('https://88.168....', Array) #1 {main}
             * 
             * 
             * 
             * */
            $Url = 'https://mediaspeech.com/webservicev2/server.wsdl';
        }

        echo "*$Url*<br>";
        // Instanciation du client SOAP
        $client = new SoapClient(
                $Url,
                array(
                    //'proxy_host'=>'http://monproxy.net', // si vous utilisez un proxy...
                    //'proxy_port'=>8080, // si vous utilisez un proxy...
                    'trace' => 1,
                    'exceptions' => 0, //evite de s'arreter pour voir ce qui ne va pas !
                    'soap_version' => SOAP_1_1
                )
        );

        echo "<br>";
/*         $retour_ws =  $client ->__soapCall('getHelloWorld',array());
        print_r('hello='.$retour_ws.'<br>');
        var_dump($retour_ws);*/

        $retour_ws = $client->__call('login', array('username' => 'msf', 'password' => CST_MSF_PASSWORD));
    
        DisplayResult('login', $retour_ws);

        //----------------------------------
        if (0)
        {
            $filename = "/tmp/pyvrbs_smorin@madpc097_07aeda2a-eb1e-11df-8d3f-001d09848283.mp4"; //chemin complet sur serveur
            $f = file_get_contents($filename);


            $retour_ws = $client->__call('upload', array('filename' => $filename,
                    'fileContent' => base64_encode($f)));
            DisplayResult('upload', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('translation', array(
                    'jobid' => '697075.msf01',
                    'destlang' => 'eng'));
            DisplayResult('translation', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('callmining', array(
                    'filename' => 'edfpart_h5_fre_200129137406277249.wav',
                    'language' => 'fre',
                    'xmlfile' => 'edfpart_h5_fre_200129137406277249.thales.xml'));

            DisplayResult('callmining', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('result', array(
                    'jobid' => '263555.msf01',
                    'format' => 'txt'));
            DisplayResult('result', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            echo "attente";
            $retour_ws = $client->__call('waitandgetresult', array(
                    'jobid' => '697276.msf01',
                    'format' => 'txt'));
            DisplayResult('waitandgetresult', $retour_ws);
            echo "fin attente";
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('multicasttrans', array(
                    'filename' => 'TF1_11196585_20090801_11_00_00-20090801_11_25_00_30sec.mp3',
                    'type' => 'bn',
                    'language' => 'fre',
                    'channel' => '0',
                    'quality' => '0',
                    'duration' => '0',
                    'channelid' => '1',
                    'daterecord' => '0000-00-00 00:00:00')
            );
            DisplayResult('result', $retour_ws);
        }

        //----------------------------------
        if (0)
        {

            $retour_ws = $client->__call('trans', array(
                    'filename' => 'pyvrbs_smorin@madpc097_07aeda2a-eb1e-11df-8d3f-001d09848283.mp4',
                    'type' => 'bn',
                    'language' => 'fre',
                    'channel' => '0',
                    'quality' => '0',
                    'duration' => '0',
                    'duration' => '0',
                    'corpus' => '',
                    'callback' => 'http://10.0.0.3/dev/callback.php')
            );
            DisplayResult('trans', $retour_ws);
        }

        //----------------------------------
        if (0)
        {

            $retour_ws = $client->__call('part', array(
                    'filename' => 'PKBN_FRE_FR_20071112_2000_FRANCE2_NEWS.wav',
                    'type' => 'bn',
                    'channel' => '0',
                    'speaker' => '0')
            );
            DisplayResult('part', $retour_ws);
        }

        //----------------------------------
        if (1)
        {
            //$retour_ws =  $client -> __call('status',array('jobid'=>'1848.msf01'));
            $retour_ws = $client->__call('status', array('jobid' => '1862507'));
            DisplayResult('status', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('senddata', array(
                    'destination' => 'sms://0645140781',
                    'text' => "coucou test d'sms"));
            DisplayResult('senddata', $retour_ws);
            //echo '<br />Requete SOAP : '.htmlspecialchars($client->__getLastRequest()).'<br />';
            //echo '<br />Reponse SOAP : '.htmlspecialchars($client->__getLastResponse()).'<br />';
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('cancel', array('jobid' => '1877.msf01'));
            DisplayResult('cancel', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('result', array('jobid' => '1101289.msf01'));
            DisplayResult('result', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            /*            $retour_ws =  $client -> __call('delete',array('filename'=>'pyvrbs_smorin@madpc097_07aeda2a-eb1e-11df-8d3f-001d09848283.mp4'));

              DisplayResult('delete', $retour_ws);
             */

            $retour_ws = $client->__call('delete', array('filename' => '1191105.msf01'));
            DisplayResult('delete', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('streamregister', array(
                    'StreamName' => 'rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=100004',
                    'Callback' => 'https://10.0.0.3/dev/CallbackStreams.php',
                    'Language' => 'fre',
                    'Mode' => '1')
            );

            DisplayResult('streamregister', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('streamunregister', array(
                    'StreamId' => '9')
            );

            DisplayResult('streamunregister', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('speakeridaddspeaker', array(
                    'speakeridentifier' => '7',
                    'speakername' => 'speaker soap',
                    'audiofilename' => 'audio_spkctrn.wav',
                    'speakercomment' => 'commentaire soap',
                    'language' => 'fre')
            );

            DisplayResult('speakeridaddspeaker', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('speakerid', array(
                    'filename' => 'audio_spka.wav',
                    'type' => 'cts',
                    'language' => 'fre',
                    'SpeakerIdList' => '55:7',
                    'ResultInfo' => '',
                    'callback' => '')
            );


            DisplayResult('speakerid', $retour_ws);
        }

        //----------------------------------
        if (0)
        {
            $retour_ws = $client->__call('speakeridremovespeaker', array(
                    'speakeridentifier' => '7')
            );

            DisplayResult('speakeridremovespeaker', $retour_ws);
        }


        //----------------------------------
        $retour_ws = $client->__call('logout', array());
        DisplayResult('logout', $retour_ws);

        //----------------------------------
        /*    	// Affichage des requêtes et réponses SOAP (pour debug)
          echo '<br />Requete SOAP : '.htmlspecialchars($client->__getLastRequest()).'<br />';
          echo '<br />Reponse SOAP : '.htmlspecialchars($client->__getLastResponse()).'<br />';

          // Affichage du résultat
          print_r($retour_ws); */
    }
    catch (Exception $e)
    {
        //TODO  Traitement en cas d'exception, pour l'instant on l'affiche tel quel...
        echo $e;
    }
?>