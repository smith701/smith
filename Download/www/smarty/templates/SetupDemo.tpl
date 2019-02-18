<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <title>{$web_pages_title}</title>

    {literal}
      <link rel="stylesheet" type="text/css" href="./css/tableau.css">
      <!-- Bootstrap CSS Toolkit styles -->
      <link rel="stylesheet" href="css/bootstrap.min.css">

      <!-- Bootstrap styles for responsive website layout, supporting different screen sizes -->
      <link rel="stylesheet" href="css/bootstrap-responsive.min.css">

      <!-- Bootstrap Image Gallery styles -->
      <link rel="stylesheet" href="css/bootstrap-image-gallery.min.css">
      <!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
      <link rel="stylesheet" href="css/jquery.fileupload-ui.css">

      <script src="scripts/jquery.min.js"></script>
      <script src="scripts/vendor/jquery.ui.widget.js"></script>
{/literal}
    
</head>
<body>         
{include file='StartScripts.tpl'}
{include file='menu.tpl'}

<br>
<div align=left>
<font size=4 color=#0000ff>
<b>{$MessageDeRetour}</b>
</font>
<br>


<font size=4 color=#0000FF>
<center></font>

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
    {if !empty($pagination)}
    <div align=right>
       {$pagination}
    </div>
    {/if}

</center>    
<br><br><br><br>
 <form name="formulaire" method="get" enctype="multipart/form-data" action='' >

  <table border=1 align="center" class="table_res">
  <tr>
    <td>

      <div Id="InfosAudio"  style="display: block">

       <select name="SelectedUser" >
          {html_options values=$UserIds output=$Usernames selected=$UserSelected}
       </select>

       <br>
       <b>list the language to pupulate : ex : fre,eng  </b><br>
       <input type="text" name="languages" size="10" value="">
       <br>
       <br>

       <button class="btn btn-info"  name="Action" value="FillAcount" type="submit" onClick="" style="font: 16px Arial" >Fill user account</button>

    </td>
  </tr>
  </table>
 </form>

</body>
</html>


