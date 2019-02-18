<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>{$web_pages_title}</title>
</head>
<body>
{include file='menu.tpl'}
<link rel="stylesheet" type="text/css" href="css/login.css">

<center>
{$error}

<br>

<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>
</center>

{if $ShowUpdate}
  <font size=4 color=#ff0000>
      This page MUST be displayed by your MSF at the address :</br></br>
  <font size=5 color=#0000FF>
  <blink>https://your_IP_address/Administration.php?Action=DoUpdate </blink></br></br>
  </font>
      An update file will be downloaded and will auto install to your home system.</br>
      It can be MSF Lite, MSF Factory or MSF embedded in a virtual machine.</br>
  </font>
{/if} 

    <br><br>

	<form id="loginform" method='post' width="300px">
	  <input type="hidden" name="Action" value="DoUpdate">
	  <input type="hidden" name="Check" value="1">
	<fieldset style="display: block;border-left:2px solid #ACCEE2; border-top:2px solid #ACCEE2; border-right:2px solid #2F38DE; border-bottom:2px solid #2F38DE;background-color:#EDFCFF;">

	<legend>Account information on Vecsys mediaspeech.com web site</legend>
	
	<table align="center" border="0">
	  <tr>
	    <td>Login<br>
	    <input type="text" name="username" maxlength="250"></td>
	  </tr>
	  <tr>
	    <td>Password<br>
	    <input type="password" name="password" maxlength="20"></td>
	  </tr>
	  <tr>
	    <td colspan="2" align="center"><input name="StartAction" type="submit" value="Check updates"></td>
	  </tr>
	</table>
  </fieldset>
	 

{if $ShowUpdate}

    <br><br>
    {if !empty($listing)}
        {if !empty($pagination)}
           {$pagination}
        {/if}
        <FONT FACE="courier">
          <div class="grid">
            <table border=1 align="center" class="table_res">
                <tr>
                  {$header}
                </tr> 
                  {foreach from=$listing item=foo2}
                        {$foo2}
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

{/if} 
	</form> 


</body>
</html>
