<?php
require_once("../Toolbox/logs.php");
require_once("../Toolbox/config.php");
require_once("../Toolbox/divers.php");

//	LOG_Write("Acces Soap");

    // On désactive la mise en cache du wsdl (pour le test)
    ini_set('soap.wsdl_cache_enabled', 0);
    
    // Inclusion de la classe contenant l'implémentation des fonctions du Service Web
    include('../Toolbox/WebserviceMSF.php');
    
    // Tentative d'instanciation du serveur SOAP
    try 
    {
		if ($DEV_EN_COURS == 1)
		{
    		$server = new SoapServer('serverdev.wsdl',  array('trace' => 1, 'soap_version' => SOAP_1_1));
		}   
		else  
		{
    		$server = new SoapServer('server.wsdl',  array('trace' => 1, 'soap_version' => SOAP_1_1));
		}   

        $server->setclass('WebserviceMSF');     
        $server->setPersistence(SOAP_PERSISTENCE_SESSION);
    }
    catch (Exception $e) 
    {
        //TODO  Traitement en cas d'exception, pour l'instant on l'affiche tel quel...
        echo $e;
        exit();	  
    }
    
    // Appel du Service Web (requête POST uniquement autorisée)  
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
        // Prise en charge de la requête
    	@ $server -> handle();	     
    }
    // Sinon, on affiche la liste des fonctions du serveur SOAP et un lien vers le WSDL
    else 
    {
		$smarty 		 = DIV_InitSmarty();

	   	/***************************************************************************
	      SESSIONS
	   	***************************************************************************/
		if (!DIV_SessionOK($smarty, "login"))
			exit;

        foreach($server -> getFunctions() as $func) 
        {        
            if (strpos($func, 'Hello')==0)
                $List[]= $func;
        }
        
        $smarty->assign("List", $List);
		$smarty->display('webservice.tpl');

        
    }  
?>
