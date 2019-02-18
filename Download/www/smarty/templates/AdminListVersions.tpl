<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />

    <title>{$web_pages_title}</title>

    <link rel="stylesheet" type="text/css" href="./css/tableau.css" />
    <link rel="stylesheet" type="text/css" href="./css/main.css" />

  </head>
  <body>
    <script type="text/javascript" src="scripts/Fonctions.js"></script>

    {include file='menu.tpl'}
    <center>

      <FONT FACE="courier">
        <div class="grid">
          <table border=1 align="center" class="table_res">
            <tr class="tr_res">
              {$header}
            </tr> 
            {foreach from=$listing item=foo2}
              {$foo2}
            {/foreach}
          </table>
        </div>
      </FONT> 
      <br/>
      <br/>


  </body>
</html>

