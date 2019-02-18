<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xml:lang="en-gb" xmlns="http://www.w3.org/1999/xhtml" lang="en-gb">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />

    <title>{$web_pages_title}</title>

    <link rel="stylesheet" href="css/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="./css/main.css" />
      <link href="./scripts/themes/redmond/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
      <link class="include" rel="stylesheet" type="text/css" href="./scripts/jquery.jqplot.min.css" />

      {literal}    
        <link href="./scripts/jtable/themes/lightcolor/blue/jtable.css" rel="stylesheet" type="text/css" />
        <script src="./scripts/jquery.min.js" type="text/javascript"></script>
        <script src="./scripts/jquery-ui.min.js" type="text/javascript"></script>
        <script src="./scripts/jtable/jquery.jtable.js" type="text/javascript"></script>

    </head>
    <body>
      <script type="text/javascript" src="scripts/Fonctions.js"></script>
      <script type="text/javascript">

        $(document).ready(function() {

          //Prepare jTable
          $('#UsersList').jtable({
            title: 'List of users',
            paging: true,
            pageSize: 20,
            sorting: true,
            defaultSorting: 'UserId ASC',
            actions: {
              listAction: './scripts/jQListUsers.php?action=list',
              //createAction: './scripts/jQListUsers.php?action=create',
              //updateAction: './scripts/jQListUsers.php?action=update',
              deleteAction: './scripts/jQListUsers.php?action=delete'  
              },
            fields: {
              iduser: {
                title: 'Id',
                key: true,
                create: false,
                edit: false,
                list: true,
                width:80
              },
              username: {
                title: 'Username'
              },
              password: {
                title: 'Password'
              },
              info_companyname: {
                title: 'Company Name'
              },
              info_lastname: {
                title: 'Name'
              },
              info_firstname: {
                title: 'Firstname'
              },
              info_emailaddress: {
                title: 'Email Address'
              },
              info_phonenumber: {
                title: 'Phone'
              },
              quota_maxdate: {
                title: 'Max Date',
                type: 'date',
                displayFormat: 'yy-mm-dd',
                display : 
                    function(data)
                    {
                      var CurrentDate = new Date();
                      if (data.record.quota_maxdate=="1970-01-01")
                        return "<div style=\"background-color:#bed5fd; text-align:center\">Unlimited</div>";
                      else if (new Date(data.record.quota_maxdate).getTime() < CurrentDate)
                        return "<div style=\"background-color:#f93a26; text-align:center\">" + data.record.quota_maxdate +"</div>";
                      else 
                        return "<div style=\"background-color:#7ae507; text-align:center\">" + data.record.quota_maxdate +"</div>";
                    }
              },
              info_role: {
                title: 'Role',
                type: 'radiobutton',
                    options: [
                        { Value: 'U', DisplayText: 'User' },
                        { Value: 'A', DisplayText: 'Administrator' }
                    ]
              },
              processinfo: {
                title : 'cor/jb-maxjobs'
              },
              sched_priority: {
                title : 'priority'
              },
              Actions: {
                title: 'Actions'
              },
              /*IdQuota: {
                title: 'Quota'
              },*/
              info_country: {
                  title: 'Country',
                  options:  './scripts/jQListUsers.php?ListCountry',
                  list: false
              }              
            },
            //Register to selectionChanged event to hanlde events
            recordsLoaded : function () {
              /*var ROWNUMBER = 2;
              var $row = $('#UsersList').find(".jtable tbody tr:eq(" + ROWNUMBER + ")");    
              $row.css("background", "#FF0000");            */
            }
          });
          $('#UsersList').jtable('load');
          
          $('#EditButton').click(function() {
                e.preventDefault();
                alert("coucou");
          });
          
       });

      </script>
    {/literal}    

    {include file='menu.tpl'}
    <center>

      <FONT FACE="courier">
        <div id="UsersList" style="width:100%"></div>
      </FONT> 
      <br/>
    </center>
      

  </body>
</html>

