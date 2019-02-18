<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>{$web_pages_title}</title>
</head>
<body>
{include file='menu.tpl'}

{if $Erreur == 0}
    <br><br><br>
    <center>
    Logout successful<br>
    <a href="login.php">click here to login again</a>
{else}

    Logout failed !! sorry :(<br>
{/if}

</body>
</html>
