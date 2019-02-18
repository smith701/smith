<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en-gb">
 <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    {literal}
      <link rel="stylesheet" type="text/css" href="./css/tableau.css">
      <!-- Bootstrap CSS Toolkit styles -->
      <link rel="stylesheet" href="css/bootstrap.min.css">
      <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />

      <!-- Bootstrap styles for responsive website layout, supporting different screen sizes -->
      <link rel="stylesheet" href="css/bootstrap-responsive.min.css">

      <!-- Bootstrap Image Gallery styles -->
      <link rel="stylesheet" href="css/bootstrap-image-gallery.min.css">
      <!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
      <link rel="stylesheet" href="css/jquery.fileupload-ui.css">
    {/literal}
      {include file='menu.tpl'}
    <script type="text/javascript" src="./scripts/jquery.min.js">         </script>
    <script type="text/javascript" src="./scripts/jquery.validate.js" >   </script>
    <script type="text/javascript" src="./scripts/additional-methods.js"> </script>
    <script type="text/javascript" src="./scripts/jquery.mockjax.js">     </script>

    {literal}

      <style type="text/css">
        form.cmxform { width: 50em; }
        em.error {
          background:url("./images/unchecked.gif") no-repeat 0px 0px;
          padding-left: 16px;
        }
        em.success {
          background:url("./images/checked.gif") no-repeat 0px 0px;
          padding-left: 16px;
        }

        form.cmxform label.error {
          margin-left: auto;
          width: 250px;
        }
        em.error { color: black; }
        #warning { display: none; }
      </style>
    {/literal}
      
</head>
  
<body>
    {include file='StartScripts.tpl'}
    {config_load file="`$smarty.session.lang`.txt"}

    {literal}
      <script type="text/javascript">
        function RunBuilder()
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
        }

        function handleSubmit(action)
        {
          return confirm('Are you really sure you want to ' + action + ' the model into the blades ?');
        }
        function CopySelection()
        {
          var e = document.getElementById("IdModelsNameList");
          var strUser = e.options[e.selectedIndex].text;

          var f = document.getElementById("IdModelsName");
          f.value = strUser;
          //alert(strUser);
        }
      </script>      
    {/literal}
{literal}
    <script type="text/javascript">
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
            {
              $('#LangBN').hide();
              $('#LangLCS').hide();
              $('#LangCTS').hide();
              $('#LangCCS').show();
               break;
            }
            case 'cts':
            {
              $('#LangBN').hide();
              $('#LangLCS').hide();
              $('#LangCCS').hide();
              $('#LangCTS').show();
               break;
            }
            case 'bn' : 
            {
              $('#LangCTS').hide();
              $('#LangLCS').hide();
              $('#LangCCS').hide();
              $('#LangBN').show();
               break;
            }
            case 'lcs' : 
            {
              $('#LangCTS').hide();
              $('#LangBN').hide();
              $('#LangCCS').hide();
              $('#LangLCS').show();
               break;
            }
       }
    }   
        
      $().ready(function() {
        var validator = $("#FormModel").bind("invalid-form.validate", function() {
          $("#summary").html("Your form contains " + validator.numberOfInvalids() + " errors, see details below.");
        })
        .validate(
        {
          debug: true,
          errorElement: "em",
          //errorContainer: $("#warning, #summary"),
          errorPlacement: function(error, element) 
          {
            error.appendTo( element.parent("td").next("td") );
          },
          submitHandler: function(form) 
          {
            $("div.error").hide();
            //alert("fin");
            RunBuilder();
            form.submit();
          },              
          success: function(label) 
          {
            label.text("ok!").addClass("success");
          },
          rules: 
          {
            ModelsName: 
            {
              required:true,
              nowhitespace:true,
              minlength:3,
              maxlength:20
            }
          }
        });
      
      });
    </script>
 {/literal}


    <div align=left>
      <font size=4 color=#ff0000>
        <b>{$MessageDeRetour}</b>
      </font>
    </div>
    <h2 id="summary"></h2>
    
  <a href="./download.php?file=MSF_WebQuickStartAndModelUpdate.pdf&Type=pdf" >{#LinkModelDoc#}</a><br>

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


<center>
    <div class="jtable-main-container" style="width:600px">
    <div class="jtable-busy-panel-background jtable-busy-panel-background-invisible" style="display: none; width: 600px; height: 139px;"></div>
    <div class="jtable-busy-message" style="display: none;"></div>

    <div class="jtable-title">
    <div class="jtable-title-text">{#MNU_BuildModel#}</div>
    <div class="jtable-toolbar"></div>
    </div>                

    <table  class="jtable"  style="width:800px">
      <tr>
        <td>
            {#UploadVdictext#}
              <div class="container">
                <!-- The file upload form used as target for the file upload widget -->
                
                
                <form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
                     <!-- Redirect browsers with JavaScript disabled to the origin page -->
                     <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
                     <div class="row fileupload-buttonbar" style="margin-left: 20px;">
                         <div class="col-lg-7">
                             <!-- The fileinput-button span is used to style the file input field as button -->
                             <span class="btn btn-success fileinput-button">
                                 <i class="glyphicon glyphicon-plus"></i>
                                 <span>{#BTN_AddFile#}</span>
                                 <input type="file" name="files[]" multiple>
                             </span>
                             <button type="submit" class="btn btn-primary start">
                                 <i class="glyphicon glyphicon-upload"></i>
                                 <span>{#BTN_StartUpload#}</span>
                             </button>
                             <button type="button" class="btn btn-danger delete">
                                 <i class="glyphicon glyphicon-trash"></i>
                                 <span>{#BTN_Delete#}</span>
                             </button>
                             <input type="checkbox" class="toggle">
                             <!-- The global file processing state -->
                             <span class="fileupload-process"></span>
                         </div>
                         <!-- The global progress state -->
                         <div class="col-lg-5 fileupload-progress fade">
                             <!-- The global progress bar -->
                             <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                                 <div class="progress-bar progress-bar-success" style="width:0%;"></div>
                             </div>
                             <!-- The extended global progress state -->
                             <div class="progress-extended">&nbsp;</div>
                         </div>
                     </div>
                     <!-- The table listing the files available for upload/download -->
                     <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
                 </form>
            </div>
            <!-- modal-gallery is the modal dialog used for the image gallery -->
            <div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd" tabindex="-1" >
              <div class="modal-header" >
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
            {literal}
            
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

          <form  class="cmxform" name="formulaire2" id="FormModel" method="post" enctype="multipart/form-data" action='' >
            <input type="hidden" name="Page" value="Builder">
            <input type="hidden" name="uploadedfilenames" Id="uploadedfilenames" value="">
              <table>
                <tr>
                  <td >
                    <b>{#ModelName#}</b>
                    <input id="IdModelsName" type="text" name="ModelsName" size="15" title="name : 3->15 chars without space char" required value="{$ModelsNameInput}" >
                    
                    <button type= "button" name="Copy" onClick="CopySelection();" style="font: 16px Arial" > <-- </button>
                    <select id="IdModelsNameList" name="ModelsNameList" multiple="multiple">
                        {html_options values=$ModelsNames output=$ModelsNames selected=$ModelSelected}
                    </select>
                   </td>
                   <td>
                   </td>
                </tr>
                <tr>
                  <td colspan="2">
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
                    <select name="languageCCS" id="LangCCS" style="width:150px;display:{$ShowCCS}"  onChange="ChangeLanguage(this.value);">
                      {html_options values=$LanguageCCSIds output=$LanguageCCS selected=$LanguageSelectedCCS}
                    </select>
                    <select name="languageLCS" id="LangLCS" style="width:150px;display:{$ShowLCS}"  onChange="ChangeLanguage(this.value);">
                      {html_options values=$LanguageLCSIds output=$LanguageLCS selected=$LanguageSelectedLCS}
                    </select>
                </br>

                  </td>
                </tr>
                <tr>
                  <th width="600px">
                    <button class="btn btn-info" name="TestBuildModel" value="Exec" type="submit" onClick="" style="font: 16px Arial" >
                      {#MNU_TestBuildModel#}</button>
                    </br>
                    <button class="btn btn-danger" name="BuildModel" value="Exec" type="submit" onClick="" style="font: 16px Arial" >
                      {#MNU_BuildModel#}</button>
                  </th>
                </tr>
              </table>
          </form>
      </td>
    </tr>
  </table>                  
    </div>                


<hr>
  <form name="formulaire3" method="post" enctype="multipart/form-data" action='' onsubmit="return handleSubmit('copy');">
    <input type="hidden" name="Page" value="Builder">
    </br>
    <font size=4 color=#FF0000>
      {#MSG_CopyOnBlade#}
    </font>
    </br>
    </br>
    <b>{#ModelName#}</b> 
    <select name="ModelsName" >
      {html_options values=$ModelsNames output=$ModelsNames selected=$ModelSelected}
    </select>
    </br>
    </br>
    <button class="btn btn-danger" name="DeployModel" value="Exec" type="submit" onClick="" style="font: 16px Arial" >
      {#MNU_DeployModel#}
    </button>
  </form>
  </br>
  </br>
  <hr>
    <form name="formulaire5" method="post" enctype="multipart/form-data" action='' >
    <input type="hidden" name="Page" value="Builder">
      {#MSG_CheckModelOnBlade#}
      </br>
      <button class="btn btn-info" name="CheckModels" value="Exec" type="submit" onClick="" style="font: 16px Arial" >
        {#MNU_CheckModels#}
      </button>
    </form>
    </br>
    </br>

    <hr>
      <form name="formulaire4" method="post" enctype="multipart/form-data" action='' onsubmit="return handleSubmit('delete');">
    <input type="hidden" name="Page" value="Builder">
        </br>
        <font size=4 color=#FF0000>
          {#MSG_DeleteModel#}
        </font>
        </br>
        </br>
        <b>{#ModelName#}</b>
        <select name="ModelsName" >
          {html_options values=$ModelsNames output=$ModelsNames selected=$ModelSelected}
        </select>
        </br>
        </br>
        <button class="btn btn-danger" name="DeleteModel" value="Exec" type="submit" onClick="" style="font: 16px Arial" >
          {#MNU_DeleteModel#}
        </button>
      </form>
      </br>
      </br>



  {else}

    <div align=left>
        <button class="btn btn-info" onClick="window.location.replace('?'); return true;"><span>{#Back#}</span></button>
    </div>
    <center>
    {if ! $JobId}
      </br>
      {$ListTitle}
      </br>
      </br>
      <div style="background-color: #FFFFFF" align="left"> 
        <ul>
          {foreach from=$VisuListe item=foo2}
            {$foo2}
          {/foreach}
          <ul>
            </div> 
          {/if}
        {/if}

    </center>


</body>
</html>
                  