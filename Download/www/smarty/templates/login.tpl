<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Vecsys - {$web_pages_title}</title>
    <link rel="stylesheet" type="text/css" href="./css/login-form.css">
   </head>
<body>
  <script type="text/javascript" src="./scripts/jquery.min.js"></script>

  <center>
    <img  src="./images/mediaspeech.png" alt="" name="logo-client"  border="0" width="600">

      {if $Erreur == 0}
        {include file='menu.tpl'}
        </br>
        <div id="acceuil"> Welcome </div>
      {else}

        </br>

        </br>
        </br>

        {if $Erreur == 1001 }

          <H1>Login failed ! </H1>
        {/if}

        {if $Erreur == 1025 }

          <H1> Your account has expired, please consider buying access rights ! </H1>
        {/if}

        <font size=5 color=#25badd>Welcome to Mediaspeech factory</font></br></br>

        {if $Maintenance == 1}
          </br> </br> </br> </br> </br> </br>
          </br> </br> </br> </br> </br> </br>
          <font size=6 color=#ff0000>MAINTENANCE IN PROGRESS</br>please come back later</font></br>  
        {else}

          <font size=5 color=#ff0000>
          </font></br>  

          
          <div class="login-form">

            <h1>Login to MSF</h1>

            <form action='login.php' method='post' autocomplete="off">

              <input type="text" name="username" placeholder="username">

              <input type="password" name="password" placeholder="password" autocomplete="off">

              <input type="submit" value="log in">

            </form>

          </div>          

        {/if}
      {/if}
      </br></br></br></br>
      <div align=left>
        <font size=4 color=#ff00ff>
          <b> </b> 
        </font>
        </br></br></br></br>
        You have no login and you want one ? </br> 
        You may ask one at the support, but please provide some details about you, your Company, the transcription usage ...</br>
        <font size=3 color=#ff0000>
          If you need support email us at : "support at mediaspeech dot com"</br>
        </font>
      </div>
      </br></br></br>
      </br>
      (c)2017 Vecsys
      </body>
      </html>
