
  <tr>
    <td colspan="2">
      <h2 style="border-bottom: 1px solid #CCCCCC;">Processing Information (Pbs)</h2>
    </td>
  </tr>
  <tr>
    <td>Process priority
    </td> 
    <td  style="width:400px">
      <input name="quota_processpriority" type="text" id="nom" style="width:50px;" value="{$ProcessPriority}" >
      (-1024 -> +500, default 0)
      </br>Don't change unless you know what you are doing !
    </td>
    <td></td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>PBS new Queue</td>
    <td>
      <input name="QueueCreate" type="checkbox" style="width:10px">Create a user specific queue </br>
    </td>
    <td></td>
  </tr>
  <tr>
    <td>
      Queue to use :
    </td>
    <td>
        {$QueueName}
    </td>
    <td></td>
  </tr>
  <tr>
    <td>PBS Max running cores
    </td>
    <td>
      Hard Limit <input type="text" name="sched_queueprocesslimit" value="{$sched_queueprocesslimit}" style="width:50px;" SIZE=3 MAXLENGTH=3> 
    </td>
    <td></td>
  </tr>
  <tr>
    <td>
    </td>
    <td>
      Soft Limit <input type="text" name="sched_queueprocesslimitsoft" value="{$sched_queueprocesslimitsoft}" style="width:50px;" SIZE=3 MAXLENGTH=3> ( <= Hard Limit )
    </td>
    <td></td>
  </tr>
  <tr>
    <td>
      Number of core user per process
    </td>
    <td>
      <input type="text" name="quota_maxthread" value="{$ProcessMaxThread}" style="width:50px;" SIZE=3 MAXLENGTH=3>
    <td></td>
  </td>
  </tr>
