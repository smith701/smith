<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<title>{$web_pages_title}</title>
  <link rel="stylesheet" href="./css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="./css/main.css" />
  <link href="./scripts/themes/redmond/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
  <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />
  <link class="include" rel="stylesheet" type="text/css" href="./scripts/jquery.jqplot.min.css" />
  
</head>
<body>
{include file='menu.tpl'}
  <div align="center">
    <font size=5 color=#0000ff>{$Message}<br> </font>
    <br>
    {if $PlayAudio == 1}
      {if !empty($AudioFileName)}
          <EMBED SRC="{$AudioFileName}" HREF="./"   >
      {/if}
    {/if}
  </div>
  <br>
  <div align=left>
      <input class="btn btn-info" type="button" onClick="history.go(-1);" value="Back"> 
  </div>

	<font size=3>
      {if ! $GetLog }
	    <a class="btn btn-info"  href="download.php?file={$DisplayedFileName}&Type=results">Download the displayed file</a>
      {/if}
      {$GetLog}
	</font>
  <br>

  <br>
   <FONT FACE="courier">
    <div align="left">
  {if !empty($VisuListe)}
      <div align=right>
        {if !empty($pagination)}
           {$pagination}
        {/if}
      </div>
      <br>
      <div style="font-size:12px; ">
          {foreach from=$VisuListe item=foo2}
                {$foo2}
          {/foreach}
      <br>
      {if !empty($pagination)}
        <div align=right>
           {$pagination}
        </div>
      {/if}

    </div>

   {/if}

    </div>

  </FONT> 
   <!--
    <div align="left">
        <br><br><br><br>
		color red    : low confidency<br>
		color yellow : medium confidency<br>
		color green  : high confidency<br>
    </div>
   -->
</body>
</html>


