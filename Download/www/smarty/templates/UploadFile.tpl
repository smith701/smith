{config_load file="`$smarty.session.lang`.txt"}
{literal}
  
  <SCRIPT LANGUAGE="JavaScript">

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
          maxFileSize: 150000000, // 150 MB
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
           $('#UploadedFileName').val(jqxhr.responseText);
          });
      }).on('fileuploadfail', function (e, data) {
          if (data.result === undefined)
          {
              console.log(data);
          }
          else
          $.each(data.result.files, function (index, file) {
              var error = $('<span/>').text(file.error);
              $(data.context.children()[index])
                  .append('</br>')
                  .append(error);
          });
      });
  });

  
  </script>
{/literal}

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
