<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

    <title>{$web_pages_title}</title>
 <link rel="stylesheet" type="text/css" href="./css/tableau.css">
</head>
<body>
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

{if $JobId}
{#JobIdSubmission#} <br><b> 
    {section name=nIndex loop=$JobId}
        <a href="StatusAndResults.php">{#ViewStatus#} {$JobId[nIndex]}</a><br>
    {/section}
    </b>
{/if}
<br>
<div align=left>
	<font size=4 color=#ff0000>
	<b>{$MessageDeRetour}</b>
	</font>
</div>

 {if !empty($DestText)}
        <table border=1 align="center" class="table_res">
            <tr>
                <th  class="th_res">{$SrcLang}</th>
                <th class="th_res">{$DestLang}</th>
            </tr> 
            <tr>
                <td>{$SrcText}</td>
                <td>{$DestText}</td>
            </tr> 
        </table>
 {/if}


 {if !empty($listing)}
    {if !empty($pagination)}
       {$pagination}
    {/if}
    <br>
    <FONT FACE="courier">
        <table border=1 align="center" class="table_res">
            <tr>
                <th  class="th_res">{#JobId#}</th>
                <th class="th_res">{#ProcessType#}</th>
                <th class="th_res">{#AudioFile#}</th>
                <th class="th_res">{#Status#}</th>
              <th class="th_res">{#Translate#}</th>
            </tr> 
            {foreach from=$listing item=foo2}
                <tr>
                  {$foo2}
                </tr> 
            {/foreach}
        </table>
    </FONT> 
    {if !empty($pagination)}
    <div align=right>
       {$pagination}
    </div>
    {/if}
 {/if}
 <br>
 <br>
     This page has no auto refresh
</body>
</html>
