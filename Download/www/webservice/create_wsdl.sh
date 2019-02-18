#!/bin/sh
display_usage() { 
	echo "This script generates the wsdl file for the webserver." 
	echo -e "\nUsage:\n$0 <server URL> \n" 
	echo -e "\nExample:\n$0 http://192.168.1.0 \n" 
	} 

# if less than 1 argument supplied, display usage 
if [  $# -lt 1 ] 
then 
  display_usage
  exit 1
fi 

cd /home/MSF/www/webservice
/home/MSF/www/html/wsdl-writer/wsdl ../Toolbox/WebserviceMSF.php $1/webservice/ server.wsdl index.php 
chown apache:apache *.wsdl
