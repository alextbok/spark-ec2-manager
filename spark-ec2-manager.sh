#!/bin/bash
#spark ec2 cluster management script

export KEY_PAIR_NAME=""
export KEY_FILE=""

function add_param() {
	if [ -z "$2" ]; then
		echo "$1"
	elif [[ "$2" == "w" || \
			"$2" == "t" || \
			"$2" == "m" || \
			"$2" == "r" || \
			"$2" == "z" || \
			"$2" == "a" || \
			"$2" == "v" || \
			"$2" == "spark-git-repo" || \
			"$2" == "hadoop-major-version" || \
			"$2" == "D" || \
			"$2" == "ebs-vol-size" || \
			"$2" == "swap" || \
			"$2" == "spot-price" || \
			"$2" == "u" || \
			"$2" == "worker-instances" || \
			"$2" == "master-ops" ]]; then
		if [ -z "$3" ]; then
			echo "$1"
		elif [ ${#2} -eq "1" ]; then
			echo "$1 -$2 $3"
		else
			echo "$1 --$2=$3"
		fi
	elif [[ "$2" == "resume" || \
			"$2" == "ganglia" || \
			"$2" == "no-ganglia" || \
			"$2" == "delete-groups" || \
			"$2" == "use-existing-master" ]]; then
		echo "$1 --$2"
	else
		echo "$1"
	fi
}

if [[ -z "$KEY_PAIR_NAME" || -z "$KEY_FILE" ]]; then

	echo "You have not chosen a key pair or file. Hardcode them into the script to avoid seeing this prompt again."
	
	echo -e "Enter the name of your AWS ec2 key pair: "
	read KEY_PAIR_NAME
	
	echo -e "Enter the path to your key file: "
	read KEY_FILE
fi


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

		base_cmd="spark-ec2 -asdsad "bad_arg" -k $KEY_PAIR_NAME -i $KEY_FILE -s $num_slaves launch $cluster_name"
		while true; do
			echo -e "Would you like to add any more flags (y/n)?"
			read ans
			if [ $ans == "y" ]; then
				echo -e "Which flag would you like to set? \n \
					w (wait time) \n \
					t (instance type) \n \
					m (master instance type) \n \
					r (region) \n \
					z (zone) \n \
					a (Amazon Machine Image) \n \
					v (spark version) \n \
					D (SSH dynamic port forwaring) \n \
					u (user - root is default) \n \
					spark-git-repo \n \
					hadoop-major-version \n \
					ebs-vol-size \n \
					swap \n \
					spot-price \n \
					worker-instances \n \
					master-ops \n \
					resume \n \
					ganglia \n \
					no-ganglia \n \
					delete-groups \n \
					use-existing-master"
				read flag
				if [[ "$flag" == "resume" || \
					"$flag" == "ganglia" || \
					"$flag" == "no-ganglia" || \
					"$flag" == "delete-groups" || \
					"$flag" == "use-existing-master" ]]; then
					base_cmd=$(add_param "$base_cmd" "$flag")
				else
					echo -e "What value do you want to set for $flag?"
					read val
					base_cmd=$(add_param "$base_cmd" "$flag" "$val")
				fi
			elif [ $ans == "n" ]; then
				break
			fi
		done

		echo "Starting cluster \"$cluster_name\" with $num_slaves slaves..."
		source spark-ec2 -asdsad "bad_arg" -k $KEY_PAIR_NAME -i $KEY_FILE -s $num_slaves launch $cluster_name

	elif [[ "$command" == "destroy" || "$command" == "stop" ]]; then
		echo -e "Enter cluster-name: "
		read cluster_name

		ing="ing"
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
