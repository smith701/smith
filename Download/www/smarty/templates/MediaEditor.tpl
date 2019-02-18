<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>{$web_pages_title}</title>

  <link rel="stylesheet" type="text/css" href="./css/tableau.css">
  <link rel="stylesheet" type="text/css" href="./css/player.css">
  <link rel="stylesheet" type="text/css" href="./css/main.css">
  <link type="text/css" href="./scripts/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="./css/tooltipster.css" />
  <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="./css/panels.css">

  {literal}      
    <style type="text/css">
      .highlight{ background-color: #945710 ; color: #ffffff }
        /* Cibler les éléments <li> appartenant à un élément de classe "icone" */
        .channel {
           list-style-type: none;
           display: inline-block;
           width: 18px;
           height: 19px;
           background: url('images/Number-icon-set1.png') 0 40px;
        }
        .channel-1 { left: 0px; }
        .channel-2 { left: 18px; background: url('images/Number-icon-set1.png') -16px 40px;}
        
        .user {
           list-style-type: none;
           display: inline-block;
           width: 18px;
           height: 18px;
           background: url('images/Number-icon-set1.png') 0 142px;
        }
        .user-1 { left: 0px; }
        .user-2 { left: 17px; background: url('images/Number-icon-set1.png') -17px 142px;}
        .user-3 { left: 34px; background: url('images/Number-icon-set1.png') -34px 142px;}
        .user-4 { left: 52px; background: url('images/Number-icon-set1.png') -52px 142px;}
        .user-5 { left: 67px; background: url('images/Number-icon-set1.png') -67px 142px;}
        .user-6 { left: 84px; background: url('images/Number-icon-set1.png') -84px 142px;}
        .user-7 { left: 101px; background: url('images/Number-icon-set1.png') -101px 142px;}
        .user-8 { left: 116px; background: url('images/Number-icon-set1.png') -116px 142px;}
        .user-9 { left: 133px; background: url('images/Number-icon-set1.png') -133px 142px;}
        .user-10 { left: 150px; background: url('images/Number-icon-set1.png') -150px 142px;}
        
    </style>
  {/literal}    
      <script type="text/javascript" src="scripts/Fonctions.js"></script>

  <!-- CSS and javascript import to use JQuery API --> 
  <script type="text/javascript" src="./scripts/jquery.min.js"></script>
  <script type="text/javascript" src="./scripts/jquery.custom.min.js"></script>

  <!-- CSS and javascript import to use tooltipster API --> 
  <script type="text/javascript" src="./scripts/jquery.tooltipster.min.js"></script>

  <!-- javascript import to build the JWPlayer --> 
  <script type="text/javascript" src="./scripts/jwplayer.js"></script>
  <script type="text/javascript">jwplayer.key="1lj3vCgtr59lPqG48KTHfSJAQ1Ey8m6x4ltKew==";</script>

  <!-- javascript anc css import to manage MediaView --> 
  <script type="text/javascript" src="./scripts/mediaviews.js"></script>
  
  <script src="./scripts/jtable/jquery.jtable.js" type="text/javascript"></script>
  

</head>
<body>
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

<div align="left">
<font size=4 color=#ff0000>
    <b>{$MessageDeRetour}</b></br>
</font>
  
  <button class="btn btn-info" onClick="history.go(-1);"><span>{#Back#}</span></button>

  <div align="center">
  
    <div class="jtable-busy-message" id="busy-message" style="left:300px; display: none;">{$PleaseWait}</br></div>
    <font size=5 color=#0000ff><br>  </font> 
  
      <script>
{literal}
        function Convert()
        {
          $('#busy-message').show();
          //fait un reset du cookie qui maintient les valeurs des filtres
          var xmlHttp = null;

           xmlHttp = new XMLHttpRequest();
{/literal}           
           xmlHttp.open( "GET", "./MediaEditor.php?function=convert&jobid={$jobid}&IdUser={$IdUser}", false );
{literal}           
           xmlHttp.send( null );
           //console.log( xmlHttp.responseText);
           
           $('#busy-message').hide();
        }
        
        $(document).ready(function() 
        {
            $(".trigger").click(function(){
                    $(".panel").toggle("fast");
                    $(this).toggleClass("active");
                    ShowGraph();
            $('#InfosList').jtable('load', {
            });                    
                    return false;
            });
            
            $("#Editable").change(function()
            {
              $("#SaveModifications").toggle();
              //var Value =  this.checked;
              $('#ContentEdit').attr('contenteditable', this.checked) ;
            });           
          //Prepare jTable
          $('#InfosList').jtable({
      {/literal}    
            title: '{#InfosList#}',
      {literal}    
            paging: false,
            pageSize: 20,
            sorting: false,
            defaultSorting: '',
            columnResizable : true,
            actions: {
{/literal}
        
              listAction: './scripts/jQGraphStatsTrans.php?JobId={$jobid}&Stats=Infos&Username={$username}&DateSubmit="{$DateSubmit}"&AudioType={$ExecAudioType}&Language={$ExecLanguage}'
{literal}
                
            },
            fields: {
              Parameter: {
      {/literal}    
                title: '{#Parameter#}'
      {literal}    
              },
              Value : {
      {/literal}    
                title: '{#Value#}'
      {literal}    
              }
            },
            //Register to selectionChanged event to hanlde events
            recordsLoaded : function () {
/*              var ROWNUMBER = 2;
              var $row = $('#ProcessList').find(".jtable tbody tr:eq(" + ROWNUMBER + ")");    
              $row.css("background", "#FF0000");            */
            }
            
          });

{/literal}
          {if $DoConvert==1}
           Convert();
          {/if}
           
        });
        
      </script>
          
          
          <div align="center"><font size=4 color=#0000ff>{$AudioFileName}</font></div>
    <table>
      <tr>
        <td>
{if $DisablePlayer==1}            
    <font size=8 color=#ff0000> Player disabled &nbsp; &nbsp; &nbsp;</font>
{else}
          <div id="player" style="margin-bottom: 5px; width: 600px;" >Loading the player ...</div>
{/if}          
        </td>
        <td>
          <a class="btn btn-info"  href="download.php?jobid={$jobid}&Type=results&format=Text">{#DownloadTextFile#}</a></br></br>
          <a class="btn btn-info"  href="download.php?jobid={$jobid}&Type=results&format=Xml">{#DownloadXmlFile#}</a></br></br>
          <a class="btn btn-info"  href="download.php?jobid={$jobid}&Type=results&format=Srt">{#DownloadSrtFile#}</a></br></br>
          <a class="btn btn-info"  href="download.php?jobid={$jobid}&Type=results&format=Lex">{#DownloadLexFile#}</a></br></br>
          <a class="btn btn-info"  href="download.php?jobid={$jobid}&Type=results&format=Json">{#DownloadJsonFile#}</a></br>
        </td>
      </tr>
    </table>

{if $DisablePlayer==0}      
     
{literal}           
        <script type="text/javascript">
          var playerInstance = jwplayer("player").setup({
            flashplayer: "./scripts/jwplayer.swf",            
{/literal}
      {if $DoConvert==1}
            file: '{$MediaMp3}',
      {else}
            file: '{$Media}',
       {/if}
{literal}
            image: '',
            height: '340',
            width: '600',
            stretching: "uniform",
            events: 
            {
              onPlay: function() 
              {
                updateValues();
              }
            }                
          })
          .onError(function(event){
            console.log('onError', 'message=='+event.message+'');
            if (confirm('Error loading media, try to reencode the media ?'))
            {
              Convert();
              jwplayer("player").setup({
                  file: {/literal}'{$MediaMp3}'{literal},
                  height: '340',
                  width: '600',
                  events: 
                  {
                    onPlay: function() 
                    {
                      updateValues();
                    }
                  }                
              });

            }
            
          });


        if('contentEditable' in document.createElement('span')){
            //alert('ContentEditable is supported by your browser');
        }else{
            alert('ContentEditable is not supported by your browser');
        }               
          
        </script>
      {/literal}
{/if}
      </br>
      {if empty($ShowSpeakers)}
      <label><input type="checkbox" Id="Editable" value="Edit">{#EditTheText#} (Beta test)</label>
      {/if}
       &nbsp; &nbsp; &nbsp;
      <!-- <button onclick="window.location.href='MediaEditor2.php?jobid={$jobid}&IdUser={$IdUser}'">New player with VLC</button> -->
      </br>
    <table>
      <tr>
        <td>
      
          <ul id="ContentEdit"  contenteditable="false">
          <div spellcheck="true">
          <div id="speech2text" lang="{$Lang}" dir="{$Dir}" style="
               background-color:#222222; color: #AAA; text-align: justify; font-size:17px;  
                width: 800px;   height: 400px; margin-top:8px; margin-left:8px; margin-right:8px;
               overflow:auto; 
               border:1px solid #ccc; -moz-border-radius:6px;-webkit-border-radius : 6px" >
                <p>
                  {$SubTitles}
                </p>
            </div>
            </div>
        </ul>
        </td>
        <td>
          If colors are displayed :</br> 
          <font color=#33b506>High confidency </font></br>
          <font color=#c4c61a>Medium confidency</font></br> 
          <font color=#ff0000>Low confidency</font></br>
            </br></br></br>
        </td>
      </tr>
    </table>
    {literal}
      <script type="text/javascript">
        //on envoie les données modifiées vers MSF et elles remplaceront celles
        //de la transcription exacte
        function ValidateModifications()
        {  
          var selectors = $("#speech2text p ");
          var Result="";
           $('#busy-message-save').show();
          $.each( selectors, function( index, value )
              {
                //Result += value.className + "=" + value.innerHTML + "\n";
                Result += value.innerHTML + " ";
              });          
              //console.log( Result ); 
              
           var data = new FormData();
           data.append('function', 'ModifyText');
    {/literal}
           data.append('jobid', '{$jobid}');
           data.append('IdUser', '{$IdUser}');
    {literal}
           data.append('EditedText', Result);
           
           xmlHttp = new XMLHttpRequest();
           xmlHttp.onreadystatechange = function()
           {
              if(xmlHttp.readyState == 4)
              {
                var result = xmlHttp.responseText;      
                console.log( result);

                if ( xmlHttp.responseText === "1" )
                  alert("successfuly saved");
                else
                  alert("ERROR saving text : "+xmlHttp.responseText);
                 $('#busy-message-save').hide();
              }
           }           
           xmlHttp.open( "POST", "./MediaEditor.php", true );
           xmlHttp.send( data );
          
              
        }
       </script>
    {/literal}
    <div class="jtable-busy-message" id="busy-message-save" style="left:300px; display: none;">{#SavingInProgress#}</br></div>
    <input class="btn btn-info" id="SaveModifications" type="button" onClick="ValidateModifications();" value="{#SaveModifications#}" style="display: none">
      </br> 

   </div>


    </br>

</br></br></br></br></br> 

{literal}
      <script>
       function ShowGraph()
        {
          // Our ajax data renderer which here retrieves a text file.
          // it could contact any source and pull data, however.
          // The options argument isn't used in this renderer.
          var ajaxDataRenderer = function(url, plot, options)
          {
            var ret = null;
            $.ajax({
              // have to use synchronous here, else the function 
              // will return before the data is fetched
              async: false,
              url: url,
              dataType: "json",
              success: function(data) {
                ret = data;
              }
            });
            //alert(ret);
            return ret;
          };

          // The url for our json data
          //  var jsonurl = "./jsondata.txt";
{/literal}
          var jsonurl = "./scripts/jQGraphStatsTrans.php?JobId={$jobid}&Stats=Gender";
{literal}
          
          var PlotGender = $.jqplot('ChartGender', jsonurl, {
            title: "Gender",
            seriesDefaults:
                {
                  renderer: $.jqplot.PieRenderer,
                  shadow: true,            
                  rendererOptions: {
                    showDataLabels: true,
                    // By default, data labels show the percentage of the donut/pie.
                    // You can show the data 'value' or data 'label' instead.
                    dataLabels: 'label'                      
                  }
                },
            dataRenderer: ajaxDataRenderer,
            dataRendererOptions: {unusedOptionalUrl: jsonurl}
          });
{/literal}
          jsonurl = "./scripts/jQGraphStatsTrans.php?JobId={$jobid}&Stats=SpeachTime";
{literal}
          var PlotSpeakTime = $.jqplot('ChartSpeachTime', jsonurl, {
            title: "Speakers",
            seriesDefaults:
                {
                  renderer: $.jqplot.PieRenderer,
                  shadow: true,            
                  rendererOptions: {
                    showDataLabels: true,
                    // By default, data labels show the percentage of the donut/pie.
                    // You can show the data 'value' or data 'label' instead.
                    dataLabels: 'label'                      
                  }
                },
            dataRenderer: ajaxDataRenderer,
            dataRendererOptions: {unusedOptionalUrl: jsonurl}
          });


        }        
      </script>
{/literal}
        
    <script class="include" type="text/javascript" src="./scripts/jquery.jqplot.min.js"></script>
    <script class="include" language="javascript" type="text/javascript" src="./scripts/plugins/jqplot.json2.min.js"></script>
    <script class="include" language="javascript" type="text/javascript" src="./scripts/plugins/jqplot.dateAxisRenderer.min.js"></script>
    <script class="include" language="javascript" type="text/javascript" src="./scripts/plugins/jqplot.categoryAxisRenderer.min.js"></script>
    <script class="include" language="javascript" type="text/javascript" src="./scripts/plugins/jqplot.pointLabels.min.js"></script>
    <script type="text/javascript" src="./scripts/plugins/jqplot.pieRenderer.min.js"></script>

<div id="container">

</div>


<div class="panel">
    <b>{#PlayOption#}</b><br>
    <a class="btn btn-info"  href="?jobid={$jobid}&IdUser={$IdUser}&ShowSpeakers">{#ShowSpeakers#}</a>
    <a class="btn btn-info"  href="?jobid={$jobid}">{#HideSpeakers#}</a></br></br>
    <b>{#Statistics#}</b><br>
        <table>
            <tr>
                <td>
                    <div id="ChartGender" style="height:200px; width:200px;left:10px;" ></div>
                </td>
                <td>
                    <div id="ChartSpeachTime" style="height:200px; width:200px;left:10px;" ></div>
                </td>
            <tr>
        </table>
        <div id="InfosList" style="width:100%"></div>
        
        
</div>
<a class="trigger" href="#">{#ShowOptionnalfields#}</a>
</body>
</html>


