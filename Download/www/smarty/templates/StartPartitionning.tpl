<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
	<title>{$web_pages_title} - partitionning</title>
</head>
<body>
{include file='menu.tpl'}
{include file='StartScripts.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

{literal}
  <SCRIPT LANGUAGE="JavaScript">
    function ShowHideFields(mySel)
    {
        switch (mySel)
        {
            case 'cts': 
            {
               document.getElementById("ShowOptions").style.display   = "inline";
               document.getElementById("attention_cts").style.display = "inline";
               document.getElementById("cadreoptions").style.display  = "inline";
               break;
            }
            case 'bn' : 
            {
               document.getElementById("ShowOptions").style.display   = "none";
               document.getElementById("attention_cts").style.display = "none";
               document.getElementById("cadreoptions").style.display  = "none";
               break;
            }
       }
    }   
  </script>
{/literal}


{if $JobId}
{#JobIdSubmission#} <br><b> 
    {section name=nIndex loop=$JobId}
        <a href="StatusAndResults.php">{#ViewStatus#} {$JobId[nIndex]}</a><br>
    {/section}
    </b>
{/if}
<br>
<div align=left>
<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>

{if $ModeView==1}

<form name="formulaire" method="post" enctype="multipart/form-data" action='' >
   <input type="hidden" name="function" value="partitionning">
   <input type="hidden" name="jobid" value="{$JobId}">
   
    <center>
    <button name="StartAction" value="Exec" type="submit" onClick=""  style="font: 16px Arial">{#BTN_StartPartitionning#}</button>

      <div class="boxcontent"text-align='center' ><br/><br/>
      <table >
        <tr>
        <td >
		  <div class="grid">
            <table align="center">
              <tr >
               <th width="600px">
                <H2 align="center">{#Mandatoryfields#}</H2>
               </th>
               
               <th width="300px">
               <H2 align="center">
                   <input type="checkbox" Id="ShowOptions" style="display: inline" onChange="ShowOptionsFields(this);">{#ShowOptionnalfields#}
                </H2>
               </th>
              </tr>
                   
              <tr>
              
 {include file='StartSourceAudio.tpl'}

                <td Id="cadreoptions" align="left" style="display: none">
                 <fieldset>
					    <br>
                        <b>{#AudioChannel#}</b><br>
		                    <select name="channel">
		                        <option VALUE="mono" >mono</option>
		                        <option VALUE="1" >{#Channel1#}</option>
		                        <option VALUE="2" >{#Channel2#}</option>
		                    </select>
                        <br>
                        <br>
                        <b>{#SpeakerQuantity#}</b><br>
					      <input type="text" name="speaker" size="10" value="">
					    <br>
                  </fieldset>
        
               </td>
               </tr>
            </table>
            </div>
        </td>
        </tr>
      </table>
      </div>
    <button name="StartAction" value="Exec" type="submit" onClick=""  style="font: 16px Arial">{#BTN_StartPartitionning#}</button>

</form>
{/if}
</body>
</html>


