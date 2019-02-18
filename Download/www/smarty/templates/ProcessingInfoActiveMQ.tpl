
  <tr>
    <td colspan="2">
      <h2 style="border-bottom: 1px solid #CCCCCC;">Processing Information (ActiveMQ)</h2>
    </td>
  </tr>
  <tr>
    <td>User's priority
    </td> 
    <td  style="width:400px">
      <input name="quota_processpriority" type="text" id="nom" style="width:50px;" value="{$ProcessPriority}" >
      (0 -> 1, default 0=normal, 1=high)
    </td>
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
