<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<title>{$web_pages_title}</title>
  <!-- Bootstrap CSS Toolkit styles -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
    
</head>
<body>
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

<script language="JavaScript">
{literal}
   function ConfirmMessage() 
   {
       {/literal}
       return (confirm("{#MSG_Delete#}")); 
       {literal}
   }
{/literal}
</script>

</br>
</br>
</br>
</br>

<div style="text-align:center">
<font size=4 color=#0000ff>
<b>{$MessageDeRetour}</b>
</font>
</div>

{if $MessageDeRetour==""}
<form method="post" name="formulaire" action="" onSubmit="return ConfirmMessage()" >
    <input type="hidden" name="function" value="delete">
    <center>
	<font size=4 color=#ff0000>
	<b>
    {#DoDeleteResultFiles#}
    </b>
	</font>    
    <br>
    <br>
    <button class="btn btn-danger" name="DeleteFiles" value="Exec" type="submit" ">{#DeleteResultFiles#}</button>
    <br>
</form>
{/if}
</body>
</html>


