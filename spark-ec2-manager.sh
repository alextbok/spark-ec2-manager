#!/bin/bash
#spark ec2 cluster management script

export KEY_PAIR_NAME=name_of_your_key_pair
export KEY_FILE=/path/to/your/key/file

# environment variables are not set
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" ]]; then

	echo "First you must set your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables"
	echo "To obtain them, navigate to AWS homepage > Account > Security Credentials > Access Credentials"

	echo -e "Enter AWS_ACCESS_KEY_ID: "
	read access_key
	echo "export AWS_ACCESS_KEY_ID=$access_key" >> ~/.bash_profile

	echo -e "Enter AWS_SECRET_ACCESS_KEY: "
	read secret_key
	echo "export AWS_SECRET_ACCESS_KEY=$secret_key" >> ~/.bash_profile

	echo "Your environment variables have been set. Please restart the script *in a new tab*."
fi

# REPL to manage ec2 cluster
while true; do

	echo -e "Enter an action (launch, destroy, login, stop, start, get-master) or \"quit\" to exit: "
	read command

	if [ "$command" == "launch" ]; then
		echo -e "Enter number of slaves: "
		read num_slaves

		echo -e "Enter cluster-name: "
		read cluster_name

		echo "Starting cluster \"$cluster_name\" with $num_slaves slaves..."
		source spark-ec2 -asdsad "bad_arg" -k $KEY_PAIR_NAME -i $KEY_FILE -s $num_slaves launch $cluster_name
	elif [[ "$command" == "destroy" || "$command" == "stop" ]]; then
		echo -e "Enter cluster-name: "
		read cluster_name

		$ing = ing
		echo "$command$ing \"$cluster_name\"... "
		source spark-ec2 $command $cluster_name
	elif [ "$command" == "start" ]; then
		echo -e "Enter cluster-name: "
		read cluster_name

		echo "Starting cluster \"$cluster_name\""
		source spark-ec2 -i $KEY_FILE start $cluster_name
	elif [ "$command" == "stop" ]; then
		echo -e "Enter cluster-name: "
		read cluster_name

		echo "Stopping cluster \"$cluster_name\""
		source spark-ec2 stop $cluster_name
	elif [ "$command" == "get-master" ]; then
		echo -e "Enter cluster-name: "
		read cluster_name
		
		source spark-ec2 -k $KEY_PAIR_NAME -i $KEY_FILE get-master $cluster_name
	elif [ "$command" == "quit" ]; then
		break
	else
		echo ""
		echo "Available options are (launch, destroy, login, stop, start, get-master, quit)"
	fi
done
