<?php

require_once("../Toolbox/config.php");
require_once("../Toolbox/database.php");
require_once("../Toolbox/forum.php");
require_once("../Toolbox/divers.php");


	$smarty = DIV_InitSmarty();
   
	$Erreur = RET_ERROR;


	if(isset($_POST) && !empty($_POST['username']) && !empty($_POST['password'])) 
	{
	  extract($_POST);
  
	  $Erreur = DB_CheckLogin($username, $password); //retour 0 ou -1 si échec
	  
	  //si erreur dans la base MSF on va regarder dans la base du forum
	  if ($Erreur != 0)
	  {
	  	//$Erreur = FORUM_LoginCheck($username, $password); //1=OK !!
  		$Erreur = -1; 
	  	//echo "**".$Erreur."*$username, $password*";
	  	if (! isset($Erreur))
	  		$Erreur =-1;
	  }
	}

   	$smarty->assign("Maintenance", $MAINTENANCE_EN_COURS); //0=fonctionnel, 1=maintenance en cours
   	$smarty->assign("Erreur", $Erreur); //0=OK, -1=login failed, -2=pas de login fait
   	if ($Erreur==0)
   	{
   		echo "<br><br><br><br><br><br><center><a href=\"index.php\">Access to the webservice page</a>";
   	}
   	else
		$smarty->display('login.tpl');

?>