<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>{$web_pages_title} - transcription</title>

  <link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="./css/tableau.css">
  <link rel="stylesheet" type="text/css" href="./css/jquery.multiselect.css" />
  <link rel="stylesheet" type="text/css" href="./css/multiselect/style.css" />
  <link rel="stylesheet" type="text/css" href="./css/multiselect/prettify.css" />
  <link rel="stylesheet" type="text/css" href="./css/jquery-ui.css" />
  <!-- Generic page styles -->
  <link rel="stylesheet" type="text/css" href="./css/main.css">
  <!-- Bootstrap styles for responsive website layout, supporting different screen sizes -->
  <link rel="stylesheet" type="text/css" href="./css/jquery.fileupload-ui.css">
  <link rel="stylesheet" type="text/css" href="./css/panels.css">

  <script src="scripts/load-image.min.js"></script>

  <script src="scripts/jquery.min.js"></script>
  <script src="scripts/jquery-ui.min.js"></script>
  <!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
  <script src="scripts/vendor/jquery.ui.widget.js"></script>
  <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
  <script src="scripts/jquery.iframe-transport.js"></script>
  <!-- The basic File Upload plugin -->
  <script src="scripts/jquery.fileupload.js"></script>
  <!-- The File Upload processing plugin -->
  <script src="scripts/jquery.fileupload-process.js"></script>
  <!-- The File Upload audio preview plugin -->
  <script src="scripts/jquery.fileupload-audio.js"></script>
  <!-- The File Upload video preview plugin -->
  <script src="scripts/jquery.fileupload-video.js"></script>
  <!-- The File Upload validation plugin -->
  <script src="scripts/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="scripts/prettify.js"></script>
<script type="text/javascript" src="scripts/jquery.multiselect.js"></script>
	
</head>
<body>         
{include file='StartScripts.tpl'}
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}


{literal}
<script type="text/javascript">
$(function(){
	$("#selectaudio").multiselect({
{/literal}
    noneSelectedText:"{#MSG_SelectMsf#}",
{literal}
    height:450});

    var $Button   = $("#StartAction"), 
        $window    = $(window),
        offset     = $Button.offset(),
        topPadding = 80;

    $window.scroll(function() {
        if ($window.scrollTop() > offset.top) 
        {
            $Button.stop().animate({
                marginTop: $window.scrollTop() - offset.top + topPadding
            });
        } 
        else 
        {
            $Button.stop().animate({
                marginTop: 80
            });
        }
    });

});

</script>
{/literal}



{if $JobId}
    <div align="center">
    {#JobIdSubmission#} 
    <br><br>
    <b> 
    {section name=nIndex loop=$JobId}
        <a href="StatusAndResults.php">{#ViewStatus#} {$JobId[nIndex]}</a><br>
    {/section}
      </b>
    </div>
{/if}
<br>
<div align=left>
<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>


{literal}

</head>

<body>


{/literal}

{if $ModeView==1}
    <form name="formulaire" method="get" enctype="multipart/form-data" action='' >
        <input type="hidden" name="function" value="transcription">
	<input type="hidden" name="jobid" value="{$JobId}">
        <button class="btn btn-info" style="float:left;display:inline;margin-left:100px;margin-right:30px" name="StartAction"  id="StartAction" value="Exec" type="submit" onClick="" style="font: 16px Arial" >{#BTN_StartTranscription#}</button>
	    
	  <div  class="panel-trans" id="PanelTrans">
                <div class="grid">
{include file='StartSourceAudio.tpl'}
                </div>
          </div>
    </form>

<div id="container">

</div>

<div class="panel">
    <b>{#CallbackURL#}</b><br>
    <font size=1>
            http://your.address/callback[?param1=value1...]<br> []=optionnal<br>
    </font>
    <input type="text" name="callbackurl" size="40" value="">
    <br>
    <br>
    <div Id="gpgkey" style="font-size:80%;">
        {#MSG_PgpKey#}
        <input type="text" name="gpgkey" size="40" maxlength="1024"></td>
    </div>

</div>
<a class="trigger" href="#">{#ShowOptionnalfields#}</a>
{/if}

</br></br></br>
</br></br></br>
</br></br></br>
</br></br></br>
</br></br></br>
</br></br></br>
</br></br></br>

</body>
</html>


