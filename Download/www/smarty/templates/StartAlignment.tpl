<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en-gb">
 <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
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
    {/literal}
      {include file='menu.tpl'}
    </head>
  
  <body>
    {include file='StartScripts.tpl'}
    {config_load file="`$smarty.session.lang`.txt"}

    {literal}
      <script type="text/javascript">
        function RunAlignment()
        {  //si c'est uploadé il y a un lien sur la page, on parcoure les liens pour trouver ceux des fichiers
          var aels = document.getElementsByTagName && document.getElementsByTagName('A');
          var Files;

          for (var i = 0; i < aels.length; i++)
          {
            var v2 = aels[i].getAttribute("download") //attribut spécifique aux fichiers uploades
            if (null != v2)
            {
              if (null == Files)
                Files = v2;
              else
                Files += "," + v2;
              //document.write(v2);
            }
          }
          if (null == Files)
          {
            alert("no file uploaded !!");
            return false;
          }
          else
          {
            document.getElementById('uploadedfilenames').value = Files;
          }
          return true;
        }

      </script>      
    {/literal}


    <div align=left>
      <font size=4 color=#ff0000>
        <b>{$MessageDeRetour}</b>
      </font>
    </div>
    <center>


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


      {if $ModeView==1}


        <div class="grid">
          <table >
            <tr>
              <td >
                  {#UploadAlignementtext#}
                  {literal}
                    <div class="container">
                      <!-- The file upload form used as target for the file upload widget -->
                      <form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
                        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
                        <div class="row fileupload-buttonbar">
                          <div class="span7">
                            <!-- The fileinput-button span is used to style the file input field as button -->
                          {/literal}
                          <span class="btn btn-success fileinput-button">
                            <i class="icon-plus icon-white"></i>
                            <span>{#BTN_AddFile#}</span>
                            <input type="file" name="files[]" multiple ">
                        </span>
                        <button type="submit" class="btn btn-primary start">
                          <i class="icon-upload icon-white"></i>
                          <span>{#BTN_StartUpload#}</span>
                        </button>
                        <button type="button" class="btn btn-danger delete">
                          <i class="icon-trash icon-white"></i>
                          <span>{#BTN_Delete#}</span>
                        </button>
                        {literal}
                          <input type="checkbox" class="toggle">
                            <!-- The loading indicator is shown during file processing -->
                            <span class="fileupload-loading"></span>
                        </div>
                        <!-- The global progress information -->
                        <div class="span5 fileupload-progress fade">
                          <!-- The global progress bar -->
                          <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                            <div class="bar" style="width:0%;"></div>
                          </div>
                          <!-- The extended global progress information -->
                          <div class="progress-extended">&nbsp;</div>
                        </div>
                      </div>
                      <!-- The table listing the files available for upload/download -->
                      <table role="presentation" class="table table-striped"><tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody></table>
                    </form>
                    <br>
                  </div>
                  <!-- modal-gallery is the modal dialog used for the image gallery -->
                  <div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd" tabindex="-1">
                    <div class="modal-header">
                      <a class="close" data-dismiss="modal">&times;</a>
                      <h3 class="modal-title"></h3>
                    </div>
                    <div class="modal-body"><div class="modal-image"></div></div>
                    <div class="modal-footer">
                      <a class="btn modal-download" target="_blank">
                        <i class="icon-download"></i>
                        <span>Download</span>
                      </a>
                      <a class="btn btn-success modal-play modal-slideshow" data-slideshow="5000">
                        <i class="icon-play icon-white"></i>
                        <span>Slideshow</span>
                      </a>
                      <a class="btn btn-info modal-prev">
                        <i class="icon-arrow-left icon-white"></i>
                        <span>Previous</span>
                      </a>
                      <a class="btn btn-primary modal-next">
                        <span>Next</span>
                        <i class="icon-arrow-right icon-white"></i>
                      </a>
                    </div>
                  </div>
                  <!-- The template to display files available for upload -->
                  <script id="template-upload" type="text/x-tmpl">
                    {% for (var i=0, file; file=o.files[i]; i++) { %}
                    <tr class="template-upload fade">
                    <td>
                    <span class="preview"></span>
                    </td>
                    <td>
                    <p class="name">{%=file.name%}</p>
                    {% if (file.error) { %}
                    <div><span class="label label-important">Error</span> {%=file.error%}</div>
                    {% } %}
                    </td>
                    <td>
                    <p class="size">{%=o.formatFileSize(file.size)%}</p>
                    {% if (!o.files.error) { %}
                    <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>
                    {% } %}
                    </td>
                    <td>
                    {% if (!o.files.error && !i && !o.options.autoUpload) { %}
                    <button class="btn btn-primary start">
                    <i class="icon-upload icon-white"></i>
                    <span>Start</span>
                    </button>
                    {% } %}
                    {% if (!i) { %}
                    <button class="btn btn-warning cancel">
                    <i class="icon-ban-circle icon-white"></i>
                    <span>Cancel</span>
                    </button>
                    {% } %}
                    </td>
                    </tr>
                    {% } %}
                  </script>
                  <!-- The template to display files available for download -->
                  <script id="template-download" type="text/x-tmpl">
                    {% for (var i=0, file; file=o.files[i]; i++) { %}
                    <tr class="template-download fade">
                    <td>
                    <span class="preview">
                    {% if (file.thumbnail_url) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" data-gallery="gallery" download="{%=file.name%}"><img src="{%=file.thumbnail_url%}"></a>
                    {% } %}
                    </span>
                    </td>
                    <td>
                    <p class="name"  id="uploaded">
                    <a href="{%=file.url%}" title="{%=file.name%}" data-gallery="{%=file.thumbnail_url&&'gallery'%}" download="{%=file.name%}">{%=file.name%}</a>
                    </p>
                    {% if (file.error) { %}
                    <div><span class="label label-important">Error</span> {%=file.error%}</div>
                    {% } %}
                    </td>
                    <td>
                    <span class="size">{%=o.formatFileSize(file.size)%}</span>
                    </td>
                    <td>
                    <button class="btn btn-danger delete" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}"{% if (file.delete_with_credentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="icon-trash icon-white"></i>
                    <span>Delete</span>
                    </button>
                    <input type="checkbox" name="delete" value="1" class="toggle">
                    </td>
                    </tr>
                    {% } %}

                  </script>
                  
                  <script src="scripts/load-image.min.js"></script>
                  
                  <script src="scripts/jquery.min.js"></script>
                  <!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
                  <script src="scripts/vendor/jquery.ui.widget.js"></script>
                  <!-- The Templates plugin is included to render the upload/download listings -->
                  <script src="scripts/tmpl.min.js"></script>
                  <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
                  <script src="scripts/jquery.iframe-transport.js"></script>
                  <!-- The basic File Upload plugin -->
                  <script src="scripts/jquery.fileupload.js"></script>
                  <!-- The File Upload processing plugin -->
                  <script src="scripts/jquery.fileupload-process.js"></script>
                  <!-- The File Upload image preview & resize plugin -->
                  <script src="scripts/jquery.fileupload-image.js"></script>
                  <!-- The File Upload audio preview plugin -->
                  <script src="scripts/jquery.fileupload-audio.js"></script>
                  <!-- The File Upload video preview plugin -->
                  <script src="scripts/jquery.fileupload-video.js"></script>
                  <!-- The File Upload validation plugin -->
                  <script src="scripts/jquery.fileupload-validate.js"></script>
                  <!-- The File Upload user interface plugin -->
                  <script src="scripts/jquery.fileupload-ui.js"></script>
                  <!-- The main application script -->
                  <script src="scripts/main.js"></script>
                  <!-- The XDomainRequest Transport is included for cross-domain file deletion for IE8+ -->
                  <!--[if gte IE 8]><script src="scripts/cors/jquery.xdr-transport.js"></script><![endif]-->
                {/literal}

                <!--form name="formulaire2" method="post" enctype="multipart/form-data" action='' onsubmit="return RunBuilder();"-->
                <form name="formulaire" method="post" enctype="multipart/form-data" action='' onsubmit="return RunAlignment();">
                  <input type="hidden" name="function" value="alignment">
                  <input type="hidden" name="jobid" value="{$JobId}">
                  <input type="hidden" name="alignmode" value="0">
                  <input type="hidden" name="uploadedfilenames" Id="uploadedfilenames" value="xxx">
                    <table>
                      <tr>
                        <td >
                            <div Id="language" style="display: block">
                              <b>{#Language#}</b>
                              <select name="languageBN"  style="width:100px">
                                <option VALUE="eng" >English</option>
                                <option VALUE="fre" >Français</option>
                              </select>
                              </br>
                            </div>
                            <b>{#SelectAudio#}</b>

                            <select name="type"  onChange="ShowHideFields(this.value);">
                              <option VALUE="bn"  >{#BN#}</option>
            <!--                  <option VALUE="cts" >{#CTS#}</option>
                              <option VALUE="ccs" >{#CCS#}</option> -->
                            </select>

                        </td>
                      </tr>
                    </table>
                    <center>
                    <button class="btn btn-info" name="StartAction" value="Exec" type="submit" onClick="" style="font: 16px Arial" >{#BTN_StartAlignment#}</button>
                </form>
            </td>
          </tr>
        </table>                  
      </div>  
{/if}


</body>
</html>


