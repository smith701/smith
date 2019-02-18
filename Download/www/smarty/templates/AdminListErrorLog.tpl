<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<title>{$web_pages_title}</title>

    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
    <link rel="stylesheet" type="text/css" href="./css/main.css">
	
</head>
<body>
<script type="text/javascript" src="scripts/Fonctions.js"></script>

{include file='menu.tpl'}
<center>

 <br>
<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>

<br>
 {if !empty($listing)}
	{if !empty($pagination)}
	   {$pagination}
   	{/if}
    <br><br>
	<FONT FACE="courier">
      <div class="grid">
	    <table border=1 align="center" class="table_res">
            <tr>
              {$header}
            </tr> 
		    {foreach from=$listing item=foo2}
            <tr>
		          {$foo2}
            </tr> 
		    {/foreach}
	    </table>
	   </div>
	</FONT> 
    {if !empty($pagination)}
    <div align=right>
       {$pagination}
    </div>
    {/if}
 {/if}
 
<br>

</body>
</html>

