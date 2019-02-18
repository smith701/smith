<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
	<title>{$web_pages_title} - Models</title>
	
</head>
<body>         
{include file='StartScripts.tpl'}
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}


<br>
<div align=left>
<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>

<font size=4 color=#0000FF>
<center></font>

{if $JobId}
{#JobIdSubmission#} <br><b> 
    {section name=nIndex loop=$JobId}
        <a href="StatusAndResults.php">{#ViewStatus#} {$JobId[nIndex]}</a><br>
    {/section}
    </b>
{/if}

{if $ModeView==1}
	<form name="formulaire" method="post" enctype="multipart/form-data" action='' >
		
      <center>
      <button name="StartAction" value="Exec" type="submit" onClick="" style="font: 16px Arial" >{#MNU_StartModel#}</button>
	    
	  <div  class="raised" text-align='center'>
	  <b class="top" text-align='center'>  <b class="b1">  </b>  <b class="b2">  </b>  <b class="b3">  </b>  <b class="b4">  </b>
	    
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
              </tr>
              
              <tr>
		      <td >
		        <fieldset>
		           <div Id="language" style="display: block">
		            <b>{#Language#}</b>
		            <select name="language" >
		                <option VALUE="fre" >French</option>
		                <option VALUE="eng" >English</option>
		                <option VALUE="spa" >Spanish</option>
		            </select>
		            <br>
		            <br>
		           </div>
               {#SelectAudio#}
		            </br>

              <select name="type"  onChange="ShowHideFields(this.value);">
                  <option VALUE="bn"  >{#BN#}</option>
<!--                  <option VALUE="cts" >{#CTS#}</option>
                  <option VALUE="ccs" >{#CCS#}</option> -->
              </select>
           
              <div Id="text_upload"  style="display: block">   
                  <b>{#UploadTextForModel#}</b>
                  <br>
                     <input type="hidden" name="MAX_FILE_SIZE" >
                     <input type="file" name="textfilename" size="50"> ( .txt, .zip )
                  <br>
                  <br>
              </div>
            </tr>
	        </table>
	      </div>  
	    </td>
	    </tr>
	  </table>
      </div>
      <b class="bottom"><b class="b4b"></b><b class="b3b"></b><b class="b2b"></b><b class="b1b"></b></b>
      </div>

      <button name="StartAction" value="Exec" type="submit" onClick="" style="font: 16px Arial" >{#MNU_StartModel#}</button>

   	</form>

{/if}


</body>
</html>


