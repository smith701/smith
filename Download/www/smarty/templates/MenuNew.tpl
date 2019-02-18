<link rel="stylesheet" href="css/menu.css" type="text/css">

{literal}    


  <style type="text/css">
    .wrapper {
      width: 970px;
    }

    #content-shift {
      margin-right: 270px;
    }

    #contentright {
      width: 255px;
      margin-left: -255px;
    }

    #menu .dropdown {
      width: 340px;
    }

    #menu .columns2 {
      width: 680px;
    }

    #menu .columns3 {
      width: 1020px;
    }

    #menu .columns4 {
      width: 1360px;
    }
  </style>
{/literal}    

{config_load file="`$smarty.session.lang`.txt"}


<div id="header">


  <div id="menubar">
    <div class="menubar-2">
      <div class="menubar-3"></div>
    </div>
  </div>							
  <div id="menu">


    <ul class="menu menu-dropdown">
      <li class="level1 item1 first parent active current ">
        <a	href="./Home.php"
           class="level1 item1 first parent active current"> 
          <span class="bg">
            <span class="title">{#Home#}</span> 
            <span class="subtitle">{#MediaSpeechWebSites#}</span></span> 
        </a>
      </li>
      <li class="level1 item2 parent "><a
          href="StartTranscription.php"
          class="level1 item2 parent"> <span class="bg"> <span
              class="title">{#Processing#}</span> 
            <span class="subtitle">{#MSFForYou#}</span> </span> </a>
        <div
          style="height: 250px; overflow: hidden; width: 400px; visibility: visible; opacity: 1;"
          class="dropdown columns1">
          <div style="margin-top: 0px;">
            <div class="dropdown-t1">
              <div class="dropdown-t2">
                <div class="dropdown-t3"></div>
              </div>
            </div>
            <div class="dropdown-1">
              <div class="dropdown-2">
                <div class="dropdown-3">
                  <ul class="col1 level2 first last">
                    <li class="level2 item1 first parent">
                      <div class="group-box1">
                        <div class="group-box2">
                          <div class="group-box3">
                            <div class="group-box4">
                              <div class="group-box5">
                                <div class="hover-box1">
                                  <div class="hover-box2">
                                    <div class="hover-box3">
                                      <div style="min-height: 45px;" class="hover-box4">
                                        <a href="StartTranscription.php"	class="level2 item1 first parent"> 
                                          <span class="bg icon" style="background-image: url('images/transcription.jpg');">
                                            <span class="title">{#Transcription#}</span> 
                                            <span class="subtitle">{#Transcription#}</span></span>
                                        </a>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div style="min-height: 45px;" class="sub">
                                  <ul class="level3">
                                    <li class="level3 item1 first ">
                                      <a	href="StartTranscription.php" class="level3 item1 first"> 
                                        <span class="bg">{#MNU_StartTranscription#}</span>
                                      </a>
                                    </li>
                                    <li class="level3 item2 ">
                                      <a	href="ModelsTools.php?Page=Dic" class="level3 item2 "> 
                                        <span class="bg">{#MNU_ModelsToolsWordsInDic#}</span>
                                      </a>
                                    </li>
                                    <li class="level3 item2 last">
                                      <a	href="ModelsTools.php?Page=Builder" class="level3 item2 last"> 
                                        <span class="bg">{#MNU_ModelsToolsBuilder#}</span>
                                      </a>
                                    </li>
                                  </ul>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </li>
                    <li class="level2 item2 parent">
                      <div class="group-box1">
                        <div class="group-box2">
                          <div class="group-box3">
                            <div class="group-box4">
                              <div class="group-box5">
                                <div class="hover-box1">
                                  <div class="hover-box2">
                                    <div class="hover-box3">
                                      <div style="min-height: 45px;" class="hover-box4">
                                        <a	href="StartAlignment.php?alignmode=0"	class="level2 item2 parent"> 
                                          <span class="bg icon" style="background-image: url('images/align.jpg'); color: rgb(50, 50, 50); ">
                                            <span class="title">{#Alignment#}</span> 
                                            <span class="subtitle">{#Alignment#}</span></span>
                                        </a>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div style="min-height: 45px;" class="sub">
                                  <ul class="level3">
                                    <li class="level3 item1 first last">
                                      <a	href="StartAlignment.php?alignmode=0"	class="level3 item1 first last" > 
                                        <span class="bg">{#MNU_StartAlignment#}</span>
                                      </a>
                                    </li>
                                  </ul>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </li>
                    <li class="level2 item3 parent" style="display: none">
                      <div class="group-box1">
                        <div class="group-box2">
                          <div class="group-box3">
                            <div class="group-box4">
                              <div class="group-box5">
                                <div class="hover-box1">
                                  <div class="hover-box2">
                                    <div class="hover-box3">
                                      <div style="min-height: 45px;" class="hover-box4">
                                        <a	href="StartLanguageId.php" class="level2 item3 last parent"> 
                                          <span class="bg icon" style="background-image: url('images/languageId.jpg'); color: rgb(50, 50, 50);">
                                            <span class="title">{#LanguageIdentification#}</span> 
                                            <span class="subtitle">{#LanguageIdentification#}</span></span>
                                        </a>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div style="min-height: 45px;" class="sub">
                                  <ul class="level3">
                                    <li class="level3 item1 first last">
                                      <a	href="StartLanguageId.php"	class="level3 item1 first last"> 
                                        <span class="bg">{#MNU_StartLanguageId#}</span>
                                      </a>
                                    </li>
                                  </ul>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </li>
                    <li class="level2 item4 last parent" style="display: none">
                      <div class="group-box1">
                        <div class="group-box2">
                          <div class="group-box3">
                            <div class="group-box4">
                              <div class="group-box5">
                                <div class="hover-box1">
                                  <div class="hover-box2">
                                    <div class="hover-box3">
                                      <div style="min-height: 45px;" class="hover-box4">
                                        <a href="StartPartitionning.php"  class="level2 item4 last parent"> 
                                          <span class="bg icon" style="background-image: url('images/partitionning.jpg'); color: rgb(50, 50, 50);">
                                            <span class="title">{#Partitioning#}</span> 
                                            <span class="subtitle">{#Partitioning#}</span></span>
                                        </a>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div style="min-height: 45px;" class="sub">
                                  <ul class="level3">
                                    <li class="level3 item1 first last">
                                      <a href="StartPartitionning.php" class="level3 item1 first last"> 
                                        <span class="bg">{#MNU_StartPartitionning#}</span>
                                      </a>
                                    </li>
                                  </ul>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="dropdown-b1">
              <div class="dropdown-b2">
                <div class="dropdown-b3"></div>
              </div>
            </div>
          </div>
        </div>
      </li>

      <li class="separator level1 item3 parent">
        <a href="StatusAndResults.php" class="level1 item3 first">
          <span class="bg"> 
            <span class="title">{#MNU_StatusResults#}</span> 
            <span class="subtitle">{#DisplayStatusResults#}</span></span>
        </a>
        <div class="dropdown columns1">
          <div>
            <div class="dropdown-t1">
              <div class="dropdown-t2">
                <div class="dropdown-t3"></div>
              </div>
            </div>
            <div class="dropdown-1">
              <div class="dropdown-2">
                <div class="dropdown-3">
                  <ul class="col1 level2 first last">
                    <li class="level2 item1 last parent">
                      <div class="group-box1">
                        <div class="group-box2">
                          <div class="group-box3">
                            <div class="group-box4">
                              <div class="group-box5">
                                <div class="hover-box1">
                                  <div class="hover-box2">
                                    <div class="hover-box3">
                                      <div style="min-height: 45px;" class="hover-box4">
                                        <a href="StatusAndResults.php" class="level2 item1 last parent"> 
                                          <span class="bg icon" style="background-image: url('images/results.jpg');">
                                            <span class="title">{#MNU_StatusResults#}</span> 
                                            <span class="subtitle">{#ViewResults#}</span></span>
                                        </a>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div style="min-height: 45px;" class="sub">
                                  <ul class="level3">
                                    <li class="level3 item1 first">
                                      <a href="StatusAndResults.php"  class="level3 item1 first "> 
                                        <span class="bg">{#MNU_StatusResults#}</span>
                                      </a>
                                    </li>
                                    <li class="level3 item2 ">
                                      <a href="FileDeleteAudio.php"  class="level3 item2 "> 
                                        <span class="bg">{#MNU_DeleteAudio#}</span>
                                      </a>
                                    </li>
                                    <li class="level3 item3 last">
                                      <a href="FileDeleteResults.php"  class="level3 item3 last "> 
                                        <span class="bg">{#MNU_DeleteResults#}</span>
                                      </a>
                                    </li>
                                    <li class="level3 item3 last">
                                      <a href="UserStatistics.php"  class="level3 item3 last "> 
                                        <span class="bg">{#MNU_UserStats#}</span>
                                      </a>
                                    </li>

                                  </ul>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="dropdown-b1">
              <div class="dropdown-b2">
                <div class="dropdown-b3"></div>
              </div>
            </div>
          </div>
        </div>

      </li>


      {if $role eq 'A'}

        <li class="separator level1 item6 parent ">
          <span class="separator level1 item6 parent "> 
            <span class="bg">
              <span class="title">Administration</span> 
              <span class="subtitle">{#AdminLinks#}</span></span></span>
          <div class="dropdown columns1">
            <div>
              <div class="dropdown-t1">
                <div class="dropdown-t2">
                  <div class="dropdown-t3"></div>
                </div>
              </div>
              <div class="dropdown-1">
                <div class="dropdown-2">
                  <div class="dropdown-3">
                    <ul class="col1 level2 first last">
                      <li class="level2 item1 first parent">
                        <div class="group-box1">
                          <div class="group-box2">
                            <div class="group-box3">
                              <div class="group-box4">
                                <div class="group-box5">
                                  <div class="hover-box1">
                                    <div class="hover-box2">
                                      <div class="hover-box3">
                                        <div style="min-height: 45px;" class="hover-box4">
                                          <a href="Administration.php?function=ListUsers" class="level2 item1 first parent"> 
                                            <span class="bg icon" style="background-image: url('images/users.jpg');">
                                              <span class="title">{#Users#}</span> 
                                              <span class="subtitle">{#ManageUsers#}</span></span>
                                          </a>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                  <div style="min-height: 45px;" class="sub">
                                    <ul class="level3">
                                      <li class="level3 item1 first">
                                        <a href="Administration.php?function=ListUsers" class="level3 item1 first last"> 
                                          <span class="bg">{#UsersList#}</span>
                                        </a>
                                      </li>
                                      <li class="level3 item1 ">
                                        <a href="Administration.php?function=Add" class="level3 item1"> 
                                          <span class="bg">{#AddUser#}</span>
                                        </a>
                                      </li>
                                      <li class="level3 item1 ">
                                        <a href="QuotaControl.php" class="level3 item1"> 
                                          <span class="bg">{#QuotasControl#}</span>
                                        </a>
                                      </li>
                                      <li class="level3 item1 ">
                                        <a href="SetupDemo.php" class="level3 item1"> 
                                          <span class="bg">Setup Demo videos</span>
                                        </a>
                                      </li>
                                      <li class="level3 item1 first last">
                                        <a href="UserManageAccessRights.php" class="level3 item1 first last"> 
                                          <span class="bg">{#ManageAccessRights#}</span>
                                        </a>
                                      </li>
                                    </ul>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </li>
                      <li class="level2 item2 parent">
                        <div class="group-box1">
                          <div class="group-box2">
                            <div class="group-box3">
                              <div class="group-box4">
                                <div class="group-box5">
                                  <div class="hover-box1">
                                    <div class="hover-box2">
                                      <div class="hover-box3">
                                        <div style="min-height: 45px;" class="hover-box4">
                                          <a href="Administration.php?function=ListJobs" class="level2 item2 parent"> 
                                            <span class="bg icon" style="background-image: url('images/statistics.jpg');">
                                              <span class="title">{#StatisticsStatus#}</span> 
                                              <span class="subtitle">{#Stats#}</span></span>
                                          </a>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                  <div style="min-height: 45px;" class="sub">
                                    <ul class="level3">
                                      <li class="level3 item1 ">
                                        <a href="UserStatistics.php?Users=All" class="level3 item1 first last"> 
                                          <span class="bg">{#Statistics#}</span>
                                        </a>
                                      </li>
                                      <li class="level3 item1 ">
                                        <a href="AdminMonitoring.php" class="level3 item1"> 
                                          <span class="bg">MSF Monitoring</span>
                                        </a>
                                      </li>
                                      <li class="level3 item1 ">
                                        <a href="AdminMonitoring.php?Display=Phone" class="level3 item1"> 
                                          <span class="bg">MSF Monitoring 2</span>
                                        </a>
                                      </li>
                                    </ul>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </li>
                      
                      <li class="level2 item4 last parent">
                        <div class="group-box1">
                          <div class="group-box2">
                            <div class="group-box3">
                              <div class="group-box4">
                                <div class="group-box5">
                                  <div class="hover-box1">
                                    <div class="hover-box2">
                                      <div class="hover-box3">
                                        <div style="min-height: 45px;" class="hover-box4">
                                          <a href="" class="level2 item4 first parent"> 
                                            <span class="bg icon"  style="background-image: url('images/system.jpg');">
                                              <span class="title">{#System#}</span> 
                                              <span class="subtitle">{#SystemFunctions#}</span></span>
                                          </a>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                  <div style="min-height: 45px;" class="sub">
                                    <ul class="level3">
                                      <li class="level3 item2 ">
                                        <a href="SearchEngine.php" class="level3 item2 "> 
                                          <span class="bg">{#SearchEngine#}</span>
                                        </a>
                                      </li>
                                      <li class="level3 item2 ">
                                        <a href="Administration.php?function=Facturation" class="level3 item2 "> 
                                          <span class="bg">{#Billing#}</span>
                                        </a>
                                      </li>
                                      <li class="level3 item4 ">
                                        <a href="Administration.php?function=ShowErrorsInLog&LastXDays=60" class="level3 item4 "> 
                                          <span class="bg">{#ErrorsInMSFLogs#}</span>
                                        </a>
                                      </li>
                                    </ul>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </li>

                    </ul>
                  </div>
                </div>
              </div>
              <div class="dropdown-b1">
                <div class="dropdown-b2">
                  <div class="dropdown-b3"></div>
                </div>
              </div>
            </div>
          </div>
        </li>
      {else}
        <li class="separator level1 item7 parent last">
          <a href="help.php" class="separator level1 item6 parent"> 
            <span class="bg">
              <span class="title">{#MNU_Help#}</span> 
              <span class="subtitle">{#MNU_Help#}</span></span>
          </a>

        </li>

      {/if}   	
      <li class="separator level1 item7 parent last">
        <a href="logout.php" class="separator level1 item7 parent last"> 
          <span class="bg">
            <span class="title">{#MNU_LoginLogout#} ({php}echo $_SESSION['login'];{/php})</span> 
            <span class="subtitle">{#Connection#}</span></span>
        </a>

      </li>

    </ul>


  </div>    
</div>    
