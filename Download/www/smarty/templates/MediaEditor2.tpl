<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>{$web_pages_title}</title>

  <link rel="stylesheet" type="text/css" href="./css/tableau.css">
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
      <script type="text/javascript" src="scripts/Fonctions.js"></script>

  {/literal}    

    <!-- Load player theme -->
    <link rel="stylesheet" href="./scripts/themes/maccaco/projekktor.style.css" type="text/css" media="screen" />

    <!-- Load jquery -->
  <!-- CSS and javascript import to use JQuery API --> 
  <script type="text/javascript" src="./scripts/jquery.min.js"></script>
  <script type="text/javascript" src="./scripts/jquery.custom.min.js"></script>

    <!-- load projekktor -->
    <script type="text/javascript" src="./scripts/projekktor-1.3.09.js"></script>
 <!-- CSS and javascript import to use tooltipster API --> 
  <script type="text/javascript" src="./scripts/jquery.tooltipster.min.js"></script>

  <!-- javascript anc css import to manage MediaView --> 
  <script type="text/javascript" src="./scripts/mediaviews2.js"></script>
  
  <script src="./scripts/jtable/jquery.jtable.js" type="text/javascript"></script>

</head>
<body>


{include file='menu.tpl'}


<div align="left">
<font size=4 color=#ff0000>
    <b>{$MessageDeRetour}</b></br>
</font>
  
  <button class="btn btn-info" onClick="history.go(-1);"><span>{#Back#}</span></button>

  <div align="center">
  
    <div class="jtable-busy-message" id="busy-message" style="left:300px; display: none;">{$PleaseWait}</br></div>
    <font size=5 color=#0000ff><br>  </font> 
    <div id="player_a" class="projekktor"></div>

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


    jQuery(document).ready(function($) {
      
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
        
              listAction: './scripts/jQGraphStatsTrans.php?JobId={$jobid}&Stats=Infos&Username={$username}&SubmitDate="{$DateSubmit}"&AudioType={$ExecAudioType}&Language={$ExecLanguage}'
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
{literal}
           
        var HighLight =  function(data) {
          console.log(data); 
          updateValues(data);
        };
        
        playerInstance = new projekktor('#player_a', {
            poster: 'http://www.projekktor.com/wp-content/manual/intro.png',
            playerFlashMP4: './scripts/jarisplayer.swf',
            playerFlashMP3: './scripts//jarisplayer.swf',        
            useYTIframeAPI: false,
            width:600,
            plugin_controlbar: {
                showCuePoints: true
            },
            platforms: ['browser', 'android', 'ios', 'vlc', 'native', 'flash'],
            ratio: 16/9,
            controls: true,
            playlist: [{0:{src: {/literal}'{$Media}'{literal}, type: "audio/wav"}
                       }]
        }, function(player) {
            player.addListener('displayReady', function(val, ref) {
                var model = ref.getModel();            
                $('#platform').html( (model=='VIDEOVLC') ? "VLC Web Plugin detected and in use." : " model " + model + " in use right now.");            
            });
            var count=0;
            $.each($p.mmap, function() {
                count++;
                $('<p/>').html(this.type + "(." + this.ext + ")").appendTo('#uglylist');
            });
            if (count>24) {
                $('#platform').html("Seems you don't have the VLC Web Plugin installed, you should."+count);
            }
        });  
        //playerInstance.addListener('time',HighLight );
        playerInstance.addListener('start',HighLight );
        playerInstance.addListener('state',HighLight );
        playerInstance.addListener('done',HighLight );
        
    });
    function JumpTo(sec) {
    playerInstance.setPlayhead(sec)
    }

 {/literal}

    </script>
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

   </div>


    </br>

</br></br></br></br></br> 


    
</body>
</html>
