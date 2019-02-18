<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
{config_load file="`$smarty.session.lang`.txt"}

    <title>{$web_pages_title}</title>

      <link rel="stylesheet" href="css/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="./css/main.css" />
      <link href="./scripts/themes/redmond/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
      <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />
      <link class="include" rel="stylesheet" type="text/css" href="./scripts/jquery.jqplot.min.css" />
      <link rel="stylesheet" media="all" type="text/css" href="./scripts/jquery-ui-timepicker-addon.css" />

      {literal}    
      <script src="./scripts/jquery.min.js" type="text/javascript"></script>
      <script src="./scripts/jquery-ui.min.js" type="text/javascript"></script>
      <script src="./scripts/jtable/jquery.jtable.js" type="text/javascript"></script>
      <script src="./scripts/jquery-ui-timepicker-addon.js" type="text/javascript" ></script>

    </head>
    <body>
      <script type="text/javascript" src="scripts/Fonctions.js"></script>
      <script type="text/javascript">

        $(document).ready(function() {

          //Prepare jTable
          $('#SearchResult').jtable({
            title: 'Search result',
            paging: true,
            pageSize: 20,
            sorting: true,
            defaultSorting: 'UserId ASC',
            actions: {
              listAction: './scripts/jQSearch.php?action=list'
              },
            fields: {
              jobid: {
                title: 'JobId',
                width: '10%'
              },
              datesubmit:{
                title: 'Submit date'
              },
              username: {
                title: 'Username'
              },
              filename: {
                title: 'File name'
              },
              thumbnails : {
                title: 'Play',
                width: '10%'
              },
              textfound: {
                title: 'Text found'
              }
            }
          });
          $('#SearchResult').jtable('load', {
              FilterOrSearch: 'Search',
              TextToSearch: $('#TextToSearch').val()
            });
          
       });
       
      $('#SearchResultButton').click(function(e) {
        e.preventDefault();
        $('#ProcessList').jtable('load', {
              FilterOrSearch: 'Search',
              TextToSearch: $('#TextToSearch').val()
        });
        
      $("#datepickerStart").datetimepicker({dateFormat: 'yy-mm-dd'});
      $("#datepickerStop").datetimepicker({dateFormat: 'yy-mm-dd'});
      });

      </script>
    {/literal}    

    {include file='menu.tpl'}
    <center>
        <div class="filtering" align="center">
          <table border=0>
            <tr>
             
              <td style="width:100px">
              </td>
              <td valign="bottom">
                <div class="jtable-main-container">
                <div class="jtable-busy-panel-background jtable-busy-panel-background-invisible" style="display: none; width: 1331px; height: 139px;"></div>
                <div class="jtable-busy-message" style="display: none;"></div>

                <div class="jtable-title">
                <div class="jtable-title-text">{#SearchText#}</div>
                <div class="jtable-toolbar"></div>
                </div>                
                <form>
                  <table class="jtable">
                    <tr>
                      <td>
                      <input type="text" name="TextToSearch" id="TextToSearch" value="{$TextToSearch}" style="width:350px"/>
                      </td>
                    </tr>
                  </table>
                  <center>
                    <button class="btn btn-info" type="submit" id="SearchResultButton">{#Search#}</button>
                  </center>
                </form>
              </td>
            </tr>
          </table>
        </div>
      
      <FONT FACE="courier">
        <div id="SearchResult" style="width:100%"></div>
      </FONT> 
      <br/>
    </center>
      

  </body>
</html>

