<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <title>{$web_pages_title}</title>
    
    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
</head>
<body>
{include file='menu.tpl'}



	 <form method="post" enctype="multipart/form-data" action="">
	    <input type="hidden" name="function" value="upload license file">
	<p>
	    <input type="file" name="filename" size="80">
	    <input type="submit" name="BtnUpload" value="Exec">
	</p>
	Un fichier de license doit contenir un ou plusieurs groupes de données ayant la forme ci-dessous :<br>   
System signature: 85:61:2b:48:6f:4e:0c:51 create file /etc/stk_license containing the following lines:<br>
STK 65:a6:33:68:a6:8b:2b:9d EXEC 01-Jan-2010 VR 70:c7:b2:29:78:d4:ad:03 CPARTX 1 01-Jan-2010 VR c2:cc:70:9e:a4:91:93:78 CLIDXX 1 01-Jan-2010 VR 0d:96:28:cc:36:1e:8d:28 CTFRXX 1 01-Jan-2010 VR 6f:0f:3a:bd:49:f5:c7:94 CTENUS 1 01-Jan-2010<br>
<br>    
<br>    
<br>    
	</form>
        <table border=1 align="center">
            <tr>
              {$SignatureHeader}
            </tr> 
            {foreach from=$Signature item=foo2}
                <tr>
                  {$foo2}
                </tr> 
            {/foreach}
        </table>

<center><H2> Fichier de licence : <b>{$FileName}</b></H2>

 {if !empty($listing)}
    {if !empty($pagination)}
       {$pagination}
    {/if}
    <br><br>
    <FONT FACE="courier">
        <table border=1 align="center">
            <tr>
              {$header}
            </tr> 
            {foreach from=$listing item=foo2}
                <tr>
                  {$foo2}
                </tr> 
            {/foreach}
        </table>
    </FONT> 
    {if !empty($pagination)}
    <div align=right>
       {$pagination}
    </div>
    {/if}
 {/if}



</body>
</html>
