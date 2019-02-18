<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <meta http-equiv="refresh" content="60" > 

      <title>{$web_pages_title} - {$cluster_id}</title>

        <link rel="stylesheet" type="text/css" href="./css/tableau.css" />
        <link rel="stylesheet" type="text/css" href="./css/main.css" />
        <script src="./scripts/jquery.min.js" type="text/javascript"></script>
        <script src="./scripts/jquery-ui.min.js" type="text/javascript"></script>

  </head>
  <body  bgcolor="silver">
    {$cluster_id} : <span id="digitalclock" class="styling"></span> 

    {literal} 
      <style>
        <!--
        .styling{
          background-color:black;
          color:lime;
          font: bold 16px MS Sans Serif;
          padding: 3px;
        }
        -->
      </style>      
      <script>
        function Cancel(jobid)
        {
        var xmlHttp = null;

           xmlHttp = new XMLHttpRequest();
           xmlHttp.open( "GET", "./scripts/jQListJobs.php?Cancel="+jobid, false );
           xmlHttp.send( null );
           if (xmlHttp.responseText !== "")
               alert(xmlHttp.responseText );
 
           location.reload();
        }
        
      <!--

      //LCD Clock script- by javascriptkit.com
      //Visit JavaScript Kit (http://javascriptkit.com) for script
      //Credit must stay intact for use

      var alternate=0
      var standardbrowser=!document.all&&!document.getElementById

      if (standardbrowser)
      document.write('<form name="tick"><input type="text" name="tock" size="11"></form>')

      function show(){
      if (!standardbrowser)
      var clockobj=document.getElementById? document.getElementById("digitalclock") : document.all.digitalclock
      var Digital=new Date()
      var hours=Digital.getHours()
      var minutes=Digital.getMinutes()
      var dn=""

      if (hours.toString().length==1)
      hours="0"+hours
      if (minutes<=9)
      minutes="0"+minutes

      if (standardbrowser){
      if (alternate==0)
      document.tick.tock.value=hours+" : "+minutes+" "+dn
      else
      document.tick.tock.value=hours+"   "+minutes+" "+dn
      }
      else{
      if (alternate==0)
      clockobj.innerHTML=hours+" : "+minutes+" "+"<sup style='font-size:1px'>"+dn+"</sup>"
      else
      clockobj.innerHTML=hours+" : "+minutes+" "+"<sup style='font-size:1px'>"+dn+"</sup>"
      }
      alternate=(alternate==0)? 1 : 0
      setTimeout("show()",1000)
      }
      window.onload=show

      //-->
      </script>
      <script type="text/javascript" src="scripts/Fonctions.js"></script>
     <table width="100%">
        <tr>
          <td>
            <font size=1>Auto-Refresh in <span id="CDTimer">???</span> secs.</font>
          </td>
          <td align="right">
            <a href="login.php">login</a>
          </td>
        </tr>
      </table>
      <script language="JavaScript" type="text/javascript">
        /*<![CDATA[*/
        var TimerVal = 60;
        var TimerSPan = document.getElementById("CDTimer");
        function CountDown()
      {
        setTimeout( "CountDown()", 1000 );
        TimerSPan.innerHTML=TimerVal;
        TimerVal=TimerVal-1;
        if (TimerVal<0) 
        { TimerVal=0 
        } //improvement by vivalibre, tq 
        } CountDown()  /*]]>*/ 
      </script>
    {/literal}  
    <table border=0>
      <tr>
        <td>
          {if !empty($GraphName)}
            <img alt="Line chart" src="{$GraphName}" style="border: 1px solid gray;"/>
          {/if}
        </td>
        <td valign="top">
          {$Totalheures}h</br>{$TotalProcess}
        </td>
        <td>
          {if !empty($GraphName2)}
            <img alt="Line chart" src="{$GraphName2}" style="border: 1px solid gray;"/>
          {/if}
        </td>
        
      </tr>
      <tr>
        <td valign="top">
          </br>
          <font color=blue>FTP Logs errors</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$FtpErrors item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
          </br>
          <font color=blue>HTTP Logs errors</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$HttpErrors item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
          </br>
          <font color=blue>Mysql errors</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$MysqlErrors item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
          </br>
          <font color=blue>Scheduler errors</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$PbsErrors item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
      
        </td>
        </td>
        <td>
        <td valign="top">
          </br>
          <font color=blue>Current Users</font></br>
          <table border=1>
            {foreach from=$Queues item=foo2}
              {$foo2}
            {/foreach}
          </table>
          </br>
          <font color=blue>MSF process errors</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$ProcessErrors item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
          </br>
          <font color=blue>MSF Errors in logs</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$LogsErrors item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
          </br>
          <font color=blue>MSF Slow processes</font></br>
          <font size=1>
            <table border=1>
              {foreach from=$ProcessTooSlow item=foo2}
                {$foo2}
              {/foreach}
            </table>
          </font>
      </tr>
    </table>

    <br/>

  </body>
</html>

