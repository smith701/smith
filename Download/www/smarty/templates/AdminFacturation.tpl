<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<title>{$web_pages_title}</title>

    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
	
</head>
<body>
<script type="text/javascript" src="scripts/datetimepicker_css.js"></script>

{include file='menu.tpl'}
<center>
<form method="get" action="">
	<table border=1>
	  <tr>
		<td>
            <input type="hidden" name="function" value="Facturation"></input>
		    
			Display only this user :<br>
		</td>	
		<td>	
			<select name="UserFilter" >
			   {html_options values=$UserIds output=$Usernames selected=$UserSelected}
			</select>
		</td>	
    </tr>
    <tr>
		<td>	
    Date Start billing 
		</td>	
		<td>	
       <input id="datepicker1" name="DateStart" type="text" size="15" VALUE="{$DateStart}" onclick="NewCssCal('datepicker','yyyymmdd');">
       <a href="javascript:NewCssCal('datepicker1','yyyymmdd')">
       <img src="images/cal.gif" width="16" height="16"></a>             
		</td>	
    </tr>
    <tr>
		<td>	
    Date Stop billing 
		</td>	
		<td>	
       <input id="datepicker2" name="DateStop" type="text" size="15" VALUE="{$DateStop}" onclick="NewCssCal('datepicker','yyyymmdd');">
       <a href="javascript:NewCssCal('datepicker2','yyyymmdd')">
       <img src="images/cal.gif" width="16" height="16"></a>             
		</td>	

    </tr>

		</table>
            <button name="DoFilter" style="background-color:orange" value="DoFilter" type="submit" onClick="" >Apply filter</button>
            <button name="ClearFilter" style="background-color:lightgreen" value="ClearFilter" type="submit" onClick="" >Clear filter</button>
</form>

<font size=4 color=#ff0000>
<b>{$MessageDeRetour}</b>
</font>
 <br><br>
 {if !empty($listing)}
	{if !empty($pagination)}
	   {$pagination}
   	{/if}
    <br><br>
	<FONT FACE="courier">
	    <table border=1 align="center" class="table_res">
            <tr>
              {$header}
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


</body>
</html>

