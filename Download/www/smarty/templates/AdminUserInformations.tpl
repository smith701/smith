<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>{$web_pages_title}</title>

    <!-- link rel="stylesheet" href="css/bootstrap.min.css"-->
    <!-- link rel="stylesheet" type="text/css" href="./css/tableau.css"-->
    <link rel="stylesheet" type="text/css" media="screen" href="./css/screen.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="./css/stylesheetform.css" />
    
    <script src="./scripts/jquery.min.js" type="text/javascript"></script>
    <script src="./scripts/jquery.validate.js" type="text/javascript"></script>
    <script src="./scripts/additional-methods.js" type="text/javascript"></script>
    <script src="./scripts/jquery.mockjax.js"></script>

    {literal}

      <style type="text/css">
        form.cmxform { width: 50em; }
        em.error {
          background:url("./images/unchecked.gif") no-repeat 0px 0px;
          padding-left: 16px;
        }
        em.success {
          background:url("./images/checked.gif") no-repeat 0px 0px;
          padding-left: 16px;
        }

        form.cmxform label.error {
          margin-left: auto;
          width: 250px;
        }
        em.error { color: black; }
        #warning { display: none; }
      </style>
    {/literal}
  </head>
  <body>
    {include file='menu.tpl'}
    {config_load file="`$smarty.session.lang`.txt"}

    <script type="text/javascript" src="./scripts/datetimepicker_css.js"></script>
    <script type="text/javascript" src="./scripts/md5.js"></script>
{literal}
    <script type="text/javascript">
      $().ready(function() {
        var validator = $("#userform").bind("invalid-form.validate", function() {
          $("#summary").html("Your form contains " + validator.numberOfInvalids() + " errors, see details below.");
        }).validate({
          debug: true,
          errorElement: "em",
          //errorContainer: $("#warning, #summary"),
          errorPlacement: function(error, element) {
            error.appendTo( element.parent("td").next("td") );
          },
          submitHandler: function(form) {
            $("div.error").hide();
            form.submit();
          },              
          success: function(label) {
            label.text("ok!").addClass("success");
          },
          rules: {
            username: {
              required:true,
              minlength:3,
              maxlength:15	
            },
            FirstName: {
              required:true,
              minlength:3,
              maxlength:15	
            },
            LastName: {
              required:true,
              minlength:3,
              maxlength:15	
            },
            CompanyName: {
              required:true,
              minlength:3,
              maxlength:30	
            },
            EmailAddress:{
              required:true,
              email:true
            },
            PhoneNumber:{
              required:true
            },
            ProcessPriority:{
              required:true,
              number:true
            },
            password: {
 {/literal}
           {if $CreatePwd == true}
              required: true,
              minlength: 6,
           {else}
              required: false
           {/if}
            }
             {if $CRYPT_PASSWORD == true}
            ,confirm_password: {

           {if $CreatePwd == true}
              required: true,
              minlength: 6,
 {literal}
              equalTo: "#password"
 {/literal}
           {else}
              required: false
           {/if}

            }
              {/if}
 {literal}
          },
          messages: {
              password: {
                required: "Please provide a password",
                minlength: "Your password must be at least 6 characters long"
              }
 {/literal}
             {if $CRYPT_PASSWORD == true}
 {literal}
              ,
              confirm_password: {
                required: "Please provide a password",
                minlength: "Your password must be at least 6 characters long",
                equalTo: "Please enter the same password as above"
              }
              
 {/literal}
              {/if}
 {literal}
          }
        });

      });
    </script>
 {/literal}

    </br>
<font size=4 color=#0000ff>
<b>{$error}</b>
</font>    
    
  <center>
    <form class="cmxform" id="userform" method="get" action="">
      <INPUT TYPE=hidden NAME="IdUser" VALUE="{$IdUser}">
      <input type="hidden" name="function" value="Add">
      <h2 id="summary"></h2>
      <fieldset>
        <legend>User's administration</legend>
         <div class="buttonSubmit">
            <span></span>
            <input class="formButton"  type="submit" value="{$ActionButton}" style="width: 140px" />
          </div>

            <table>
              <tr>
                <td colspan="2">
                  <h2 style="border-bottom: 1px solid #CCCCCC;">Login Information</h2>
                </td>
              </tr>
              <tr>
                <td>
                  <label for="username">Login</label>
                </td> 
                <td>
                  <input id="username" name="username" type="text" title="Please enter a login name at least 3 and max 15 characters!" required  value="{$username}">
                </td> 
                <td></td>
              </tr>
              <tr>
                <td>
                <label for="password">Password</label>
                </td> 
                <td>
                   <input name="password" type="{$PasswordType}" id="password" minlength="6" style="width:200px;" required value="{$password}">
                </td>
                <td></td>
              </tr>
             {if $CRYPT_PASSWORD == true}
                
              <tr>
                <td>
                <label for="confirm_password">Confirm Password</label>
                </td> 
                <td>
                  <input name="confirm_password" type="password" id="confirm_password" minlength="6" style="width:200px;" value="" required value="">
                </td>
                <td></td>
              </tr>
               {/if}
              <tr>
                <td colspan="2">
                  <h2 style="border-bottom: 1px solid #CCCCCC;">User Information</h2>
                </td>
              </tr>
              <tr>
                <td><label for="info_emailaddress">Email</label></td> 
                <td>
                  <input name="info_emailaddress" type="text" id="info_emailaddress" style="width:250px;" value="{$EmailAddress}" required>
                </td>
                <td></td>
              </tr>
              <tr>
                <td><label for="info_lastname">Name</label></td>
                <td><input id="info_lastname" type="text" name="info_lastname" value="{$LastName}" required title="Please enter name at least 3 and max 15 characters!"></td>
                <td></td>
              </tr>
              <tr>
                <td><label for="info_firstname">First Name</label></td>
                <td><input id="info_firstname" type="text" name="info_firstname" value="{$FirstName}" required title="Please enter firstname at least 3 and max 15 characters!"></td>
                <td></td>
              </tr>
              <tr>
                <td><label for="info_companyname">Company</label></td>
                <td><input type="text" id="info_companyname" name="info_companyname" value="{$CompanyName}"  required title="Please enter Company name at least 3 and max 15 characters!"></td>
                <td></td>
              </tr>
              <tr>
                <td><label for="info_phonenumber">Phone</label></td>
                <td><input type="text" id="info_phonenumber" name="info_phonenumber" value="{$PhoneNumber}" required title="Please enter valid phone number"></td>
                <td></td>
              </tr>
              <tr>
                <td>Country</td>
                <td>
                  <select name="info_country" >
                    {html_options values=$CountryIds output=$Country selected=$CountrySelected}
                  </select>
                </td>
                <td></td>
              </tr>
              <tr>
                <td>Max date of use</td> 
                <td>
                  <input id="datepicker" name="quota_maxdate" type="text" size="25" onclick="NewCssCal('datepicker', 'yyyymmdd');" value={$MaxDate}>
                    <a href="javascript:NewCssCal('datepicker','yyyymmdd')">
                      <img src="images/cal.gif" width="16" height="16"></a> 
                </td>
                <td></td>
              </tr>
              <tr>
                <td>Role</td> 
                <td>
                  <select name="info_role">
                    {html_options values=$RoleId output=$RoleName selected=$RoleSelected}
                  </select>
                </td>
                <td></td>
              </tr>
{if $Sched == 0}
  {include file='ProcessingInfoPbs.tpl'}
{elseif $Sched == 1}
  {include file='ProcessingInfoSlurm.tpl'}
{elseif $Sched == 3}
  {include file='ProcessingInfoActiveMQ.tpl'}
{/if}
              <tr>
                <td>Processing Script</td>
                <td>
                  <select name="quota_scriptname" >
                    {html_options values=$ScriptNameId output=$ScriptName selected=$ScriptNameSelected}
                  </select>
                </td>
                <td></td>
              </tr>
{if $Sched == 1}
              <tr>
                <td>Priority</td>
                <td>
                  <select name="sched_priority" >
                    {html_options values=$SlurmPriorityId output=$SlurmPriority selected=$SlurmPrioritySelected}
                  </select>
                </td>
                <td></td>
              </tr>
{/if}

        </table>
    </br>

	</fieldset>
  </br>
  <input name="SendEmail" type="checkbox">Send the new user it's account informations</br>
    <TEXTAREA name="EmailText" COLS=80 ROWS=15 style="width:800px">
Dear Sir or Madam,
Please find hereafter a login and a password allowing you to test our SaaS system for automatic speech transcription.
 
URL: https://mediaspeech.com/login.php
Login:%s
Password:%s 

To start a transcription go to  : https://mediaspeech.com/StartTranscription.php
Select :
   BN for Broadcast News audio files 
   CTS for Telephonic conversation audio files
   CCS for call center speach

To view your results go to : https://mediaspeech.com/StatusAndResults.php

A documentation about the webservice interface can be downloaded at https://mediaspeech.com/Home.php
 
If you encounter any issue while using this system, do not hesitate to contact us at : 
   support@mediaspeech.com.
 
Best regards,	
The MediaSpeech Team	
	
	</TEXTAREA>

</form>

</body>
</html>

