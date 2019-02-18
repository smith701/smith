<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-gb">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
     <title>{$web_pages_title} - Models
     </title>
  <link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="./css/jquery-ui.css" />
  <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />

    <!-- Generic page styles -->
  <link rel="stylesheet" type="text/css" href="./css/main.css">
  <!-- Bootstrap styles for responsive website layout, supporting different screen sizes -->
  <link rel="stylesheet" type="text/css" href="./css/jquery.fileupload-ui.css">

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
     
</head>
     
<body>         
{include file='StartScripts.tpl'}
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}



<div align=left>
<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>
</div>
<center>


{if $ModeView==1}
	<form name="formulaire1" method="post" enctype="multipart/form-data" action='' >
		<div class="grid">
      <table align="center">
        <tr>
		      <td >
               <b>{#ModelName#} </b>
              <select name="ModelsName" >
                {html_options values=$ModelsNames output=$ModelsNames selected=$ModelSelected}
              </select>
              </br>
               <b>{#SelectAudio#}</b>
                <select name="type"  onChange="ShowHideFields(this.value);" >
                  {html_options values=$TypeIds output=$Type selected=$TypeSelected}
                </select>
              </br>
              
                <b>{#Language#}</b>
                    <select name="languageBN" id="LangBN" style="width:150px;display:{$ShowBN}" onChange="ChangeLanguage(this.value);">
                      {html_options values=$LanguageBNIds output=$LanguageBN selected=$LanguageSelectedBN}
                    </select>
                    <select name="languageCTS" id="LangCTS" style="width:150px;display:{$ShowCTS}"  onChange="ChangeLanguage(this.value);">
                      {html_options values=$LanguageCTSIds output=$LanguageCTS selected=$LanguageSelectedCTS}
                    </select>
                    <select name="languageLCS" id="LangLCS" style="width:150px;display:{$ShowLCS}"  onChange="ChangeLanguage(this.value);">
                      {html_options values=$LanguageLCSIds output=$LanguageLCS selected=$LanguageSelectedLCS}
                    </select>
                </br>
           
              <div Id="text_upload"  style="display: block">   
                  <b>{#UploadTextForDic#}</b>
                  </br>
{literal}                  
  <SCRIPT LANGUAGE="JavaScript">
   function ChangeLanguage(mySel)
    {
        xmlHttp = new XMLHttpRequest();
        xmlHttp.open( "GET", "./scripts/jQmemo.php?DefaultLanguage="+mySel, false );
        xmlHttp.send( null );
    }
      
   function ShowHideFields(mySel)
    {
        switch (mySel)
        {
            case 'ccs':
            case 'cts':
            {
              $('#LangBN').hide();
              $('#LangLCS').hide();
              $('#LangCTS').show();
               break;
            }
            case 'bn' : 
            {
              $('#LangCTS').hide();
              $('#LangLCS').hide();
              $('#LangBN').show();
               break;
            }
            case 'lcs' : 
            {
              $('#LangCTS').hide();
              $('#LangBN').hide();
              $('#LangLCS').show();
               break;
            }
       }
    }   

 /*jslint unparam: true */
  /*global window, $ */
  $(function () {
      'use strict';
      // Change this to the location of your server-side upload handler:
      var url = ('scripts/'),
          uploadButton = $('<button/>')
              .addClass('btn')
              .prop('disabled', true)
              .text('Processing...')
              .on('click', function () {
                  var $this = $(this),
                      data = $this.data();
                  $this
                      .off('click')
                      .text('Abort')
                      .on('click', function () {
                          $this.remove();
                          data.abort();
                      });
                  data.submit().always(function () {
                      $this.remove();
                  });
                  return false; 
              });
      $('#fileupload').fileupload({
          url: url,
          dataType: 'json',
          autoUpload: false,
          maxFileSize: 50000000, // 50 MB
          loadImageMaxFileSize: 1500000, // 1.5MB
          disableImageResize: true,
          disableImagePreview: true,
          previewMaxWidth: 100,
          previewMaxHeight: 100,
          previewCrop: true
      }).on('fileuploadadd', function (e, data) {
          data.context = $('<div/>').appendTo('#files');
          $.each(data.files, function (index, file) {
              var node = $('<p/>')
                      .append($('<span/>').text(file.name));
              if (!index) {
                  node
                      .append('</br>')
                      .append(uploadButton.clone(true).data(data));
              }
              node.appendTo(data.context);
          });
      }).on('fileuploadprocessalways', function (e, data) {
          var index = data.index,
              file = data.files[index],
              node = $(data.context.children()[index]);
          if (file.preview) {
              node
                  .prepend('</br>')
                  .prepend(file.preview);
          }
          if (file.error) {
              node
                  .append('</br>')
                  .append(file.error);
          }
          if (index + 1 === data.files.length) {
              data.context.find('button')
                  .text('Upload')
                  .prop('disabled', !!data.files.error);
          }
      }).on('fileuploadprogressall', function (e, data) {
          var progress = parseInt(data.loaded / data.total * 100, 10);
          $('#progress .bar').css(
              'width',
              progress + '%'
          );
      }).on('fileuploaddone', function (e, data) {
          $.each(data.result.files, function (index, file) 
          {
            //redirection automatique à la fin
            //window.location.replace("?uploaded="+ file.url);
            var jqxhr = $.get( "?uploaded="+ file.url, function( data ) {
                              $( ".result" ).html( data );
                              //alert( "Data Loaded: " + data );
                              $('#UploadedFileName').val(data);
                              });            
          });
      }).on('fileuploadfail', function (e, data) {
          $.each(data.result.files, function (index, file) {
              var error = $('<span/>').text(file.error);
              $(data.context.children()[index])
                  .append('</br>')
                  .append(error);
          });
      });
  });

  
  </script>

<table>
  <tr>
    <td style="width:200px">
      <!-- The fileinput-button span is used to style the file input field as button -->
      <span class="btn btn-success fileinput-button">
        <i class="icon-plus icon-white"></i>
        <span>Add file...</span>
        <!-- The file input field used as target for the file upload widget -->
        <input id="fileupload" type="file" name="files[]" multiple>
        <input type=hidden name="IdUser[]" value="{$IdUser}" required>
      </span>
    </td>
    <td style="width:300px">
      <!-- The global progress bar -->
      <div id="progress" class="progress progress-success progress-striped">
        <div class="bar"></div>
      </div>
      <!-- The container for the uploaded files -->
      <div id="files" class="files"></div>
      <br>
    </td>
  </tr>
</table>
{/literal}              
                  File uploaded : 
                  <input type="text" id="UploadedFileName" name="textfilename" size="50" value="{$UploadedFileName}" readonly>
                  <input type="hidden" name="Page" size="50" value="Dic">

              </div>
           </td>
         </tr>
         <tr >
           <td align="center">
                <button class="btn btn-info" name="TestDictionay" value="Exec" type="submit" onClick="" style="font: 16px Arial" >
                    {#MNU_TestDictionay#} & {#MNU_PronunciationDictionay#}</button>
           </td>
          </tr>
	      </table>
	      </div>  
 	</form>
                  
                 
                  
{else}
  
</center>
<div align=left>
    <INPUT class="btn btn-info" TYPE="button" onClick="window.location.replace('?Page=Dic');return true;" VALUE="{#Back#}"> 
</div>
<center>
  {if ! $JobId}
    </br>
    
    </br>
    <div class="jtable-main-container">

      <div class="jtable-title">
      <div class="jtable-title-text">{$ListTitle}</div>
      <div class="jtable-toolbar"></div>
     </div>         
      <table class="jtable" border="1">
        {foreach from=$VisuListe item=foo2}
          {$foo2}
        {/foreach}
      </table>
   </div>         
{/if}
{/if}
  
</center>

</body>
</html>