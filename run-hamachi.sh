#!/bin/bash

#Special thanks to https://github.com/gfjardim from whom I grifted some of this script

#start hamachi - we must keep testing to see 
#if the service is up as the daemon doesn't block
echo "Starting the Hamachi Daemon..."
/opt/logmein-hamachi/bin/hamachid

echo "Waiting for said Daemon to start..."
while [ 1 ]; do
	out=$(hamachi)
	[[ $out == *"version"* ]] && break || sleep 5
done

#log in to hamachi
hamachi login

#set nickname
[[ -n $HAMACHI_CLIENT_NICKNAME ]] && hamachi set-nick $HAMACHI_CLIENT_NICKNAME

#it seems as though, if commands are too fast they fail
sleep 5

#attach to account
hamachi attach $HAMACHI_ACCOUNT_USERNAME
