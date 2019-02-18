{config_load file="`$smarty.session.lang`.txt"}


{literal}
  <SCRIPT LANGUAGE="JavaScript">
    $(document).ready(function() {
      $('#CorpusCheck').click('change',function(){
        if($('#CorpusCheck:checked').length) {
                  $("#ModelsName").show();
              } else {
                  $("#ModelsName").hide();
              }
      });
	$(".trigger").click(function(){
		$(".panel").toggle("fast");
		$(this).toggleClass("active");
		return false;
	});
      
    });

    function ShowHideFieldsFile(mySel)
    {
      switch (mySel)
      {
        case 'upload':
          {
            document.getElementById("file_upload").style.display = "inline";
            document.getElementById("file_url").style.display = "none";
            document.getElementById("file_msf").style.display = "none";
            break;
          }
        case 'url':
          {
            document.getElementById("file_upload").style.display = "none";
            document.getElementById("file_url").style.display = "inline";
            document.getElementById("file_msf").style.display = "none";
            break;
          }
        case 'msf':
          {
            document.getElementById("file_upload").style.display = "none";
            document.getElementById("file_url").style.display = "none";
            document.getElementById("file_msf").style.display = "inline";
            break;
          }

      }
    }
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
              lang=$( "#LangCCS option:selected" ).val();
               break;
            }
            case 'cts':
            {
              $('#LangBN').hide();
              $('#LangLCS').hide();
              $('#LangCCS').hide();
              $('#LangCTS').show();
              lang=$( "#LangCTS option:selected" ).val();
               break;
            }
            case 'bn' : 
            {
              $('#LangCTS').hide();
              $('#LangLCS').hide();
              $('#LangCCS').hide();
              $('#LangBN').show();
              lang=$( "#LangBN option:selected" ).val();
               break;
            }
            case 'lcs' : 
            {
              $('#LangCTS').hide();
              $('#LangBN').hide();
              $('#LangCCS').hide();
              $('#LangLCS').show();
              lang=$( "#LangLCS option:selected" ).val();
               break;
            }
       }
        xmlHttp = new XMLHttpRequest();
        xmlHttp.open( "GET", "./scripts/jQmemo.php?DefaultAudioType="+mySel+"&DefaultLanguage="+lang, false );
        xmlHttp.send( null );
    }   
  </script>
{/literal}

<td Id="cadre" style="border-left:1px solid #fff; border-top:1px solid #fff; border-right:1px solid #999; border-bottom:1px solid #999;">

    <table>
      <tr>
        <td>
          <b>{#SelectAudio#}</b>
        </td>
        <td>
            <select name="type"  onChange="ShowHideFields(this.value);" >
              {html_options values=$TypeIds output=$Type selected=$TypeSelected}
            </select>
        </td>
      </tr>
{if $Transcription eq "trans"  }
    <tr>
      <td>
          <b>{#Language#}</b>
      </td>
      <td>
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
      </td>
    </tr>
    <tr>
      <td>
          <b>{#TransQuality#} </b>
      </td>
      <td>
          <select name="TransQuality" style="width:150px">
            <option VALUE="0" >{#TransQuality1Pass#}</option>
            <option VALUE="1" >{#TransQualityMedium#}</option>
            <option VALUE="2" selected>{#TransQuality2Pass#}</option>
          </select>
     </td>
    </tr>
    <tr>
      <td>
        <b>{#ModelName#}</b>
      </td>
      <td>
        <select name="ModelsName" id="ModelsName" style="display: block">
          {html_options values=$ModelsNames output=$ModelsNames selected=$ModelSelected}
        </select>
      </td>
    </tr>
{/if}           
    </table>


       <div style=" text-align:left">
       <b>{#AudioFileSource#}</b></br>
      <fieldset style="border-left:1px solid #fff; border-top:1px solid #fff; border-right:1px solid #999; border-bottom:1px solid #999;font-size:80%;">
        <input type="radio" name="FileSource" value="upload"  onClick="ShowHideFieldsFile(this.value);" >{#CHOICE_UploadFile#}</br>
        <input type="radio" name="FileSource" value="url"   onClick="ShowHideFieldsFile(this.value);" >{#CHOICE_Ftp#}</br>
        <input type="radio" name="FileSource" value="msf"   onClick="ShowHideFieldsFile(this.value);" checked>{#CHOICE_SelectMsf#}</br>
      </fieldset>   
       </div>
      </br>
      </br>

      <div Id="file_upload"  style="display: none">   
        <b>{#MSG_Upload2#}</b>
        &nbsp;
        {include file='UploadFile.tpl'}        
        File uploaded : 
        <input type="text" id="UploadedFileName" name="UploadedFileName" size="50" value="{$UploadedFileName}" readonly>

      </div>

      <div Id="file_url"  style="display: none">   
        <b>{#MSG_ChooseWebServer#} </b><br>Syntax : http://login:pwd@ip/path.to/file OR ftp://login:pwd@ip/path.to/file 
        </br>
        <input type="text" name="UrlFilename" size="70">
        </br>
      </div>

      <div Id="file_msf"  >   
          <select id="selectaudio" multiple="multiple" name="FilenameList[]" size="10" style="width:500px">
            {html_options values=$AudioListe output=$AudioListe }
          </select>
          </br>                 
          </br>                 
          <a href="?RescanDirectory=1">{#FTP_Uploaded#}</a>
          
      </div>
</div>
</td>
