{include file='Logo.tpl'}

{include file='MenuNew.tpl'}

{php} 
    global $VERSION;
    global $msf_files, $DatabaseName, $DEV_EN_COURS, $COLOR_WEB_BACKGROUD ;
    
 	if ($DEV_EN_COURS == 1)
 	{
 		$Msg= "<font size=1>msf_home=$msf_files<br> DatabaseName=$DatabaseName</font><br>";
 	}

    echo "<table width='100%'><tr><td>
	    <div align=left>
            <a title='Français' href='?lang=fr'><img src='images/fr.gif' style='border-style: none'></a>
	        <a title='English'  href='?lang=en'><img src='images/en.gif' style='border-style: none'></a>
<!--            
            <a title='Arabic'   href='?lang=ar'><img src='images/ar.gif' style='border-style: none'></a>
         <br>
            <a title='Russian'  href='?lang=ru'><img src='images/ru.gif' style='border-style: none'></a>
            <a title='Greek'    href='?lang=el'><img src='images/el.gif' style='border-style: none'></a>
            <a title='Deutch'   href='?lang=de'><img src='images/de.gif' style='border-style: none'></a>
            <a title='Spanish'  href='?lang=es'><img src='images/es.gif' style='border-style: none'></a> 
-->
	    </div> </td>
	    <td>$Msg</td>
	    <td><div align='right' style='font-size:60%;'>$VERSION</div></td></tr></table>";
 
    
	    //echo "<link href=\"/dev/css/principale_dev.css\" rel=\"stylesheet\" type=\"text/css\">";

      echo "<style type=\"text/css\">
              body {
                  font-size: 80%;
                  margin: 0px; /* Pas de marge */
                  padding: 0px; /* Pas d'espacement */
                  background-color:$COLOR_WEB_BACKGROUD; /* Couleur de fond de la page Web */

              }
            </style>";
 	
    
{/php} 
   

    
    <noscript><BR><BR><BR><BR><BR><BR>Your browser does not support script</noscript>
    
    

 
