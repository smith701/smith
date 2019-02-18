<?php
require_once("../Toolbox/logs.php");
require_once("../Toolbox/settings.php");

$base = 'http://10.229.190.22/dev/rest/index.php';

$login = array( 'function' => "login",
                        'username'  => 'msf',
                        'password'  => CST_MYSQL_ADMIN_PASSWORD
				);

$delete = array( 'function' => "delete",
                        'jobid'  => '277'
                            );

$trans  = array( 'function' => "trans",
                        'filename' => 'test-fre.wav',
                        'type' => 'bn',
                        'language' => 'fre',
                        'channel' => '0',
                        'quality' => '0',
                        'duration' => '0',
                        'callback' => '',
                        'corpus' => '' /*,
                        'resultinfo' => 'ftp://aaa:aaaaaa@10.229.190.22/media/monfichier.xml'*/
                                    );


	
/****************************************************************************
****************************************************************************/
function DoRequest($params)
{
global $base;	
$query_string = "";

	$opts = array(
	  'http'=>array(
	    'method'=>"GET",
	    'header'=>"Accept-language: fr\r\n" .
	              "Cookie: PHPSESSID=".$_COOKIE['PHPSESSID']."\r\n"
	  )
	);
	
	$context = stream_context_create($opts);


	foreach ($params as $key => $value) 
	{
	    $query_string .= "$key=" . urlencode($value) . "&";
	}

	$url 	= "$base?$query_string";
	$output = file_get_contents($url, false, $context);
	
	return $output;
}	
/****************************************************************************
****************************************************************************/

	echo nl2br(DoRequest($login));
	echo "<br>";
	echo nl2br(DoRequest($trans));
	//echo nl2br(DoRequest($delete));

	
?>