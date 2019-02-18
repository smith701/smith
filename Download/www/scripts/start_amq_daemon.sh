#!/bin/sh
log=/var/log/msf_amq.log

ScriptName=MsfAmqInterface-1.0.jar
#ScriptName=daemon_amq_reader.php

#export PATH_FILES=/home/MSF/development/
export PATH_FILES=/home/MSF/
export OPT_SCRIPTS=$PATH_FILES/scripts

if [ "$1" == "restart" ]; then
  ps -ef | grep $ScriptName | grep -v grep | awk '{print $2}' | xargs kill -9
fi

if [ "$1" == "stop" ]; then
  ps -ef | grep $ScriptName | grep -v grep | awk '{print $2}' | xargs kill -9
  exit
fi

#setup the number of daemon we can launch
NbDaemon=2

process=`ps -edf | grep "$ScriptName" | grep -v "grep" | wc -l`
echo -n [`date +"%d/%m/%Y %H:%M:%S"`] >> $log
echo " Number of daemon processes :  $process" >> $log

for ((i=$process;$i<$NbDaemon;i=$i+1))
do
  echo -n [`date +"%d/%m/%Y %H:%M:%S"`] >> $log
  echo " daemon_amq_reader started $process/$NbDaemon, Path=$PATH_FILES ..."  >> $log
  cd $OPT_SCRIPTS
#  nohup ./$ScriptName &
  nohup java -jar $ScriptName &
done
#HostName=`hostname`




