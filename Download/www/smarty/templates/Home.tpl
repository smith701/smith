<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>{$web_pages_title}</title>
{config_load file="`$smarty.session.lang`.txt"}
    <link rel="stylesheet" type="text/css" href="./css/panels.css">

</head>
<body>
{include file='menu.tpl'}
<br><br><br><br><br><br><br>
<center>

<br>

<font size=4 color=#0000FF>
{$MessageDeRetour}
</font>

    <div style="clear:both"></div>

    <div class="one-third">

        <h2>
            {#AccountInformations#}
        </h2>
        <p>
            {#Username#} : {php}echo $_SESSION['login'];{/php}
            <br>
            {$Quota}
            <br>
            {$MaxDate}
            <br>
            {$QuotaDisk}
        </p>
    </div>
    <div class="one-third">
        <h2>
            {#Documentation#}
        </h2>
        <p>
             {#DocQuickStartGuide#} : <a href="./download.php?file=MSF_WebQuickStartAndModelUpdate.pdf&Type=pdf" >Download</a><br><br>
             {#DocWebserviceInterface#} : <a href="./download.php?file=MSF_SpecificationsInterfaceWebservice.pdf&Type=pdf" >Download</a><br>
             {#ExWebserviceInterface#} : <a href="./webservice" >Examples</a><br><br>
             {#DocRestInterface#} : <a href="./download.php?file=MSF_SpecificationsInterfaceHttp.pdf&Type=pdf" >Download</a><br><br>
        </p>
    </div>
    <div class="one-third last">
        <h2>
            {#QuickStart#}
        </h2>
        <p>
            <a href="./StartTranscription.php" >{#LinkStartTranscription#}</a><br><br>
            <a href="./StatusAndResults.php" >{#LinkStatusAndResults#}</a><br><br>
            <a href="./StartAlignment.php" >{#LinkStartAlignment#}</a><br><br>
        </p>

    </div>
    <div style="clear:both"></div>

</body>
</html>


