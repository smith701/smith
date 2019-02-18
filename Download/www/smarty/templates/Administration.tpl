<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>{$web_pages_title}</title>
</head>
<body>
{include file='menu.tpl'}

<center>
{$error}

<br>
<H1>Administration</H1>
<br>
<br>


<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>

    <table border=1>
    {foreach from=$VisuListe item=foo2}
      <tr> {$foo2}</tr>
    {/foreach}
    </table>


</body>
</html>
