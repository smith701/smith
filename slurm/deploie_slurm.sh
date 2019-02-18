#!/bin/sh


echo "------------------------------------------------------------"
echo "Usefull commands : ";
echo "Resume node       : scontrol update nodename=localhost state=resume";
echo "Display node list : scontrol show nodes";
echo "Cancel all jobs   : squeue  -o %i -h | xargs scancel";
echo "------------------------------------------------------------"
rm -f /var/log/slurm/*
cp -f /home/MSF/slurm/slurm*.conf /etc/slurm/
cp -f /home/MSF/slurm/gres.conf /etc/slurm/
killall -9 slurmdbd 
killall -9 slurmd 
killall -9 slurmctld 
/etc/init.d/slurmdbd start
/etc/init.d/slurm start

echo "------------------------------------------------------------"
echo "commande : sacctmgr show clusters"
sacctmgr show clusters
