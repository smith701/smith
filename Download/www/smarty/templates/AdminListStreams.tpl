<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <title>{$web_pages_title}</title>
    
    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
</head>
<body>
{include file='menu.tpl'}

<center><H3> Etat des flux de MSF</H3>
<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>
<center><H2> Etat des flux en cours</H2>

 {if !empty($listing)}
    {if !empty($pagination)}
       {$pagination}
    {/if}
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
