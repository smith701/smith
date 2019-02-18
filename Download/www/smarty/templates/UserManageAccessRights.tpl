<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>{$web_pages_title} - Configuration</title>
  <link rel="stylesheet" type="text/css" href="./css/tableau.css">
  <link rel="stylesheet" type="text/css" href="./css/player.css">
  <link rel="stylesheet" type="text/css" href="./css/main.css">
  <link type="text/css" href="./scripts/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="./css/tooltipster.css" />
  <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />
</head>
<body>
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

<center>

<font size=5 color=#0000ff>{$Message}<br> </font>
  <script type="text/javascript" src="./scripts/jquery.min.js"></script>

{literal}
	<SCRIPT LANGUAGE="JavaScript">
	
	    function ChangeUser(mySel)
	    {
	       // alert(mySel);
	        location="UserManageAccessRights.php?UserSelected=" + mySel;
	    }
	</SCRIPT>
{/literal}


<br>
<form name="Form_Config" method="get" action="#" onSubmit="return ValidateForm()">
  <H2> {#UsersInformation#}</H2>
	<table class="jtable">
		<tr>
      <td style="vertical-align: top;">
            Display the Access Right of this user :<br>
            <select name="UserSelected" onChange="ChangeUser(this.value);" >
               {html_options values=$UserIds output=$Usernames selected=$UserSelected}
            </select>
            </br></br></br></br>
               {html_checkboxes name     = 'SelectedPageList' 
                                values    = $PageIdList
                                output    = $PageNameList
                                selected  = $SelectedPageList 
                                separator = '<br />'}
            <br/>
                Limit user's access to certain type of audio or language <br/>
                Ex:cts,bn+eng <br/>
                Empty means no filtering<br/>
                Available audio types are : <font color="#000099">cts,bn,ccs,lcs</font><br/>
                Available languages are : <font color="#000099">ara,chi,spa,ita,rus,fre,eng,dut,ger</font><br/>
                <INPUT TYPE=TEXT NAME="ToolsAllowed" VALUE="{$ToolsAllowed}" SIZE=28 MAXLENGTH=200><br/>
            <br/>
                Hours per 24h limitation (0 = no limit)</br>
                <INPUT TYPE=TEXT NAME="quota_hoursper24h" VALUE="{$HoursPer24h}" SIZE=4 MAXLENGTH=4>                    
      </td>
      <td style="vertical-align: top;">
        Time Filtering (none selected=no filtering) </br>
            {html_checkboxes name     = 'SelectedHourList' 
                              values    = $HourIdList
                              output    = $HourNameList
                              selected  = $SelectedHourList 
                              separator = '<br />'}        
      </td>
    </tr>
  </table>
	
   <br>
     
   <button class="btn btn-info" name="StartAction" value="Exec" type="submit" onClick=""  style="font: 16px Arial">{#UpdateInfo#}</button>
   <button class="btn btn-info" name="DeleteUserAccessRights" value="Exec" type="submit" onClick=""  style="font: 16px Arial">{#DeleteUserAccessRights#}</button>


   <br><br><br>
    <table class="jtable" width="300px">
        <tr>
          <td>
            <table border=1 align="center" >
                <tr>
                  {$header}
                </tr> 
                {foreach from=$listing item=foo2}
                    <tr>
                      {$foo2}
                    </tr> 
                {/foreach}
            </table>
          </td>
        </tr>
    </table>

</form>
   
</center>      
    

</body>
</html>
