<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<title>{$web_pages_title}</title>

    <link rel="stylesheet" type="text/css" href="./css/tableau.css">
	
</head>
<body>
{include file='menu.tpl'}
<center>
<form method="get" action="">
    <input type="hidden" name="Action" value="ListAudioFiles"></input>

	<table border=1>
	  <tr>
		<td>
			Display the files of this user :<br>
			<select name="UserFilter" >
			
			   {html_options values=$UserIds output=$Usernames selected=$UserSelected}
			</select>
	    </td>
	  </tr>
	</table>
    <button name="DoFilter" style="background-color:orange" value="DoFilter" type="submit" onClick="" >Apply filter</button>
</form>

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

 <div align=center>
   <table  class="table_res">
   <tr  class="tr_res"><td class="td_res">
       <table>
         <tr><td class="td_res">Type de job</td><td class="td_res">Qt</td></tr>
         <tr><td class="td_res">E</td><td class="td_res">{$Recap_E} </td>
             <td class="td_res">Hide <a href="Administration.php?Action=ListJobs&Type=NotE">Y</a>/<a href="Administration.php?Action=ListJobs">N</a> </td>  </tr> 
         <tr><td class="td_res">F</td><td class="td_res">{$Recap_F} </td></tr>
         <tr><td class="td_res">R</td><td class="td_res">{$Recap_R} </td></tr>
         <tr><td class="td_res">Q</td><td class="td_res">{$Recap_Q} </td></tr>
         <tr><td class="td_res">C</td><td class="td_res">{$Recap_C} </td></tr>
         <tr><td class="td_res">D</td><td class="td_res">{$Recap_D} </td></tr>
         <tr><td class="td_res">Total de jobs</td><td class="td_res">{$NbJobs}</td></tr>
       </table>

   </td></tr>
   </table>
  </div>


</body>
</html>

