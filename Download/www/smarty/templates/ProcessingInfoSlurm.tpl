
  <tr>
    <td colspan="2">
      <h2 style="border-bottom: 1px solid #CCCCCC;">Processing Information (Slurm)</h2>
    </td>
  </tr>
  <tr>
    <td>User's FairShare
    </td> 
    <td  style="width:400px">
      <input name="quota_processpriority" type="text" id="nom" style="width:50px;" value="{$ProcessPriority}" >
      (0 -> 10000, default 1000)
    </td>
    <td></td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Max running jobs
    </td>
    <td>
      <input type="text" name="sched_queueprocesslimit" value="{$sched_queueprocesslimit}" style="width:50px;" SIZE=3 MAXLENGTH=3> 
    </td>
    <td></td>
  </tr>
  <tr>
    <td>
      Number of cores per job
    </td>
    <td>
      <input type="text" name="quota_maxthread" value="{$ProcessMaxThread}" style="width:50px;" SIZE=3 MAXLENGTH=3>
    <td></td>
  </td>
  </tr>
