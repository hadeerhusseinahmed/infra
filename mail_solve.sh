#!/bin/bash 

#################################################################################################
# DESC : Checking Postfix Error , if it is Found then kill postdrop & restart postfix service   #
# DATE : 06/01/2021                                                                             #
# Maintainer : Mahmoud Samy @Infrastructre Team @ULTATEL                                        #
#################################################################################################

#----------------------------------------------------------------

#####First Step to tail maillog file and search for specific error

tail /var/log/maillog | grep -i "Device or resource busy" 

#####Second Step if this error is found then kill postdrop & restart postfix service 

if [ $? -eq 0 ]
then
	killall postdrop
        if [ $? -eq 0 ]
        then
		echo "Postdrop is Killed Successfully" >> /var/log/maillog_resolve.log
	else
		echo "There is Problem with Killing Postdrop" >> /var/log/maillog_resolve_error.log
	fi
	service postfix restart 
        if [ $? -eq 0 ]
        then
                echo "Postfix is Restarted Successfully" >> /var/log/maillog_resolve.log
	else
                echo "There is Problem with Restarting Postfix" >> /var/log/maillog_resolve_error.log
        fi

#####Thrid step if this error is not found then restart it

else
	POSTFIX_STATUS_LINE=$(service postfix status | grep -i running)

	POSTFIX_STATUS='running'

	if [[ ${POSTFIX_STATUS_LINE} != *"${POSTFIX_STATUS}"* ]]
	then
        	service postfix restart
	        if [ $? -eq 0 ]
	        then
        	        echo "Postfix is Restarted Successfully" >> /var/log/maillog_resolve.log
	        else
        	        echo "There is Problem with Restarting Postfix" >> /var/log/maillog_resolve_error.log
        	fi
	fi

fi


