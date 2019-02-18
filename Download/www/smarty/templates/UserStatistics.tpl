<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

  <title>{$web_pages_title} - Statistics</title>
  <link rel="stylesheet" href="./css/bootstrap.min.css">
  <link href="./scripts/themes/redmond/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
  <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />

  <script src="./scripts/jquery.min.js" type="text/javascript"></script>
  <script src="./scripts/jquery-ui.min.js" type="text/javascript"></script>

</head>
<body>
  
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

  {literal}    
    <script type="text/javascript">
      $(document).ready(function() {
        $("#datepickerStart").datepicker({dateFormat: 'yy-mm-dd'});
        $("#datepickerStop").datepicker({dateFormat: 'yy-mm-dd'});
        $('#FilterButton').click(function(e) {
          e.preventDefault();


          var dateStringStart = $( "#datepickerStart" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();
          var dateStringStop = $( "#datepickerStop" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();

          //affiche avec filtrage
          window.location.replace("?datepickerStart="+ dateStringStart+"&datepickerStop="+dateStringStop+"&Users="+ $( "#Users" ).val());
        });
      });

    </script>
  {/literal}    
<center>
{$error}


  <input type="hidden" id="Users" value={$Users} />
  <table border=1>
    <tr>
      <td >
        {#StartDate#}
      </td>
      <td colspan="2">
        <input type="text" id="datepickerStart" style="width:100px" value={$datepickerStart} />
      </td>
    </tr>
    <tr>
      <td >
        {#EndDate#}
      </td>
      <td colspan="2">
        <input type="text" id="datepickerStop" style="width:100px" value={$datepickerStop} />
      </td>
    </tr>
  </table>
  <button class="btn btn-info" id="FilterButton" type="submit" >{#Filter#}</button>
  </br>
    <H2>Ratios  </H2>
        <table border=1>
            {foreach from=$VisuListeRatio item=foo2}
                 <tr> {$foo2}</tr>
            {/foreach}
        </table>
<br><br>
<H2>{#Stats_SizeDur#}</H2>
    <table border=1>
        {foreach from=$VisuListeTailles item=foo2}
             <tr> {$foo2}</tr>
        {/foreach}
    <table>

<br><br>

</body>
</html>
