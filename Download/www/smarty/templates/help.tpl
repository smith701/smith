<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<title>{$web_pages_title}</title>
</head>
<body>
{include file='StartScripts.tpl'}
{include file='menu.tpl'}
{config_load file="`$smarty.session.lang`.txt"}

{literal} 
  <style type="text/css">
      h1 {font-size: 30px; font-family: arial;}
      h2 {font-size: 15px; font-family: courier;}
      p 
      {
        font-size: 16px; 
        font-family: "times new roman";
        text-align:left; /* On aligne au gauche */
        text-indent:45px; 
      }
  </style>
{/literal} 

<br>
<br>
<br>
	<h1>Help</h1>
	<h2>How to transcribe an audio file ?</h2>
    <p>Step 1 : Select the transcription process. <a href=/StartTranscription.php> Menu process/Start transcription</a></p>
    <p>Step 2 : Select the Audio file type bn for broadcast news</p>
    <p>Step 3 : Select the Audio source (your local pc, a web site or a file already on the system)</p>
    <p>Step 4 : Select the Audio file name, your uploaded file should be in the list</p>
    <p>Step 5 : Select the Language for broadcast audio (optional for CTS)</p>
    <p>Step 6 : Start the transcription process. Press the button "start the transcription"</p>
    
    <h2>How to see the status or the result of the transcription process ?</h2>
    <p>Step 1 : Select the status & result page. <a href=/StatusAndResults.php> Menu process/View processes status & result</a></p>

    <h2>What are the status ?</h2>
    <div align=left style="padding-left:45px;">
      <p>
        <font size=4>
        <table>
	        <tr><td>Downloading </td><td>downloading your file from your server</td></tr>
	        <tr><td>Queued      </td><td>your process is waiting for a free CPU</td></tr>
	        <tr><td>Running     </td><td>your process is in progress</td></tr>
	        <tr><td>Ended       </td><td>your process is completed but the result has not been viewed</td></tr>
	        <tr><td>Finished    </td><td>your process is completed AND the result has been viewed</td></tr>
        </table>
        </font>
      </p>
    </div>
    
    <h2>Language code</h2>
    <div align=left style="padding-left:45px;">
    <p>
        <font size=4>
        <table>
        <tr><td>
			amh     </td><td>Amharic</td></tr><tr><td>
			ara     </td><td>Modern standard Arabic</td></tr><tr><td>
			ara-egy </td><td>Egyptian Arabic</td></tr><tr><td>
			ara-kwt </td><td>Kuwaitian Arabic</td></tr><tr><td>
			ara-lbn </td><td>Lebanese Arabic</td></tr><tr><td>
			ara-mar </td><td>Moroccan Arabic</td></tr><tr><td>
			chi     </td><td>Mandarin Chinese</td></tr><tr><td>
			chi-CNT </td><td>Cantonese (Yue Chinese)</td></tr><tr><td>
			cmn     </td><td>Mandarin Chinese</td></tr><tr><td>
			eng     </td><td>Standard English</td></tr><tr><td>
			eng-aus </td><td>Australian English</td></tr><tr><td>
			eng-can </td><td>Canadian English</td></tr><tr><td>
			eng-gbr </td><td>UK English</td></tr><tr><td>
			eng-ind </td><td>Indian English</td></tr><tr><td>
			eng-usa </td><td>US English</td></tr><tr><td>
			eng-zaf </td><td>South Africa English</td></tr><tr><td>
			ger     </td><td>standard German</td></tr><tr><td>
			fas     </td><td>Farsi (Persian)</td></tr><tr><td>
			fre     </td><td>standard French</td></tr><tr><td>
			fre-bel </td><td>Belgium French</td></tr><tr><td>
			fre-can </td><td>Canadian French</td></tr><tr><td>
			fre-che </td><td>Switzerland French</td></tr><tr><td>
			fre-mtq </td><td>Martinique French</td></tr><tr><td>
			fre-MAF </td><td>Middle Africa French</td></tr><tr><td>
			fre-NAF </td><td>Northern Africa French</td></tr><tr><td>
			hin     </td><td>Hindi</td></tr><tr><td>
			ita     </td><td>Italian</td></tr><tr><td>
			jpn     </td><td>Japanese</td></tr><tr><td>
			kor     </td><td>Korean</td></tr><tr><td>
			por     </td><td>Portuguese</td></tr><tr><td>
			por-bra </td><td>Brazilian Portuguese</td></tr><tr><td>
			por-ago </td><td>Angola Portuguese</td></tr><tr><td>
			rus     </td><td>Russian</td></tr><tr><td>
			spa     </td><td>Castilian Spanish</td></tr><tr><td>
			spa-SAM </td><td>South American Spanish (including Caribbean)</td></tr><tr><td>
			tam     </td><td>Tamil</td></tr><tr><td>
			vie     </td><td>Vietnamese</td></tr>
        <table>
        </font>
    </p>
    </div>


</body>
</html>


