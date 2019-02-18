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


{literal}

<SCRIPT LANGUAGE="JavaScript">
    function selectAllAudio(x) 
    {
        document.formulaire.sAll.checked != document.formulaire.sAll.checked
        for(var i=0,l=x.form.length; i<l; i++)
        {

          if (x.form[i].type == 'checkbox' && x.form[i].name != 'sAll')
          {
              x.form[i].checked=document.formulaire.sAll.checked
          }
        }
    }
    
   function ConfirmMessage() 
   {
{/literal}
       return (confirm("{#MSG_Delete#}")); 
{literal}
   }
</script>
{/literal}

Message : {$MessageDeRetour}<br>

<form method="post" name="formulaire" action="" onSubmit="return ConfirmMessage()" >
    <input type="hidden" name="function" value="delete">
    <br>
    <center>
      <button class="btn btn-danger" name="DeleteOldFiles" value="Exec" type="submit" ">{#DeleteOldFile#}</button>
      <br>
      <br>
      <button class="btn btn-danger" name="StartAction" value="Exec" type="submit" " >{#DeleteSelectedFiles#}</button>
      <br>
      <a href="FileDeleteResults.php"> {#LinkToDeleteResultFiles#}</a>



      <div class="boxcontent"text-align='center' >
      <table Id="cadre">
        <tr>
        <td Id="cadre">
	     <fieldset>
           <div align="left" style="display: block;border-left:1px solid #fff; border-top:1px solid #fff; border-right:1px solid #999; border-bottom:1px solid #999;">
	      
           {section name=nIndex loop=$AudioListe}
                  <input type="checkbox" name="filename[]" value="{$AudioListe[nIndex]}" > {$AudioListe[nIndex]}<br>
            {/section}
            <br>
            <b><input type="checkbox" name="sAll" onclick="selectAllAudio(this)" /> {#MSG_selectAllAudio#}<br /></b>                 
	      
	      </div>
	     </fieldset>
        </td>
        </tr>
      </table>
    <br>
	<button class="btn btn-danger"  name="StartAction" value="Exec" type="submit" >{#DeleteSelectedFiles#}</button>
</form>

</body>
</html>


