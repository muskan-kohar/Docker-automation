#!/bin/bash

#here basically we ask user for inputs to generate a automate script to create and deploy containerized setup
#creating multiple containers using while loop
read -p "Enter the container's name if no other container then type done: " dockerfile
if [ "$dockerfile" != "done" ]; then
	touch $dockerfile
	#generating base images (the initial libraries)
	read -p "Enter base image:" base_image
	echo "the base image is $base_image"
	grep -x "FROM $base_image" "$HOME/delta-onsite/$dockerfile" || echo "FROM $base_image\n" >> "$HOME/delta-onsite/$dockerfile"

	#asking for working directory
	read -p "Enter your working directory:" work_dir
	grep -x "WORKDIR $work_dir" "$HOME/delta-onsite/$dockerfile" || echo "WORKDIR $work_dir" >> "$HOME/delta-onsite/$dockerfile"

	#asking for libraries
	package=""
	while [ "$package" != "done" ]
	do
		read -p "Enter the package you want to install or type 'done' if all are done: " package
		if [ $package != "done" ];
		then
			 grep -x "RUN apt-get update && apt-get install -y $package" "$HOME/delta-onsite/$dockerfile" || echo "RUN apt-get update && apt-get install -y $package" >> "$HOME/delta-onsite/$dockerfile"
		fi
	done

	while [ "$command" != "done" ]
	do
        	read -p "Enter the package you want to install or type 'done' if all are done: " command
	        if [ "$command" != "done" ];
	        then


        	         grep -x "CMD [$command]" "$HOME/delta-onsite/$dockerfile" || echo "CMD [$command]" >> "$HOME/delta-onsite/$dockerfile"
	        fi
	done

	#creating docker compose file
	read -p "Enter the name of your docker-compose file: " docker_comp
	touch ${docker_comp}.yml
	#asking for services and dependencies and network
	echo "services:\n" >> "$HOME/delta-onsite/${docker-comp}.yml"
	while [ "$input" != "done" ]
	do
		read -p "Enter your first service name: " input
		if [ "$input" != "done" ];
		then
			echo "	$input:\n" >> "$HOME/delta-onsite/${docker-comp}.yml"
			read -p "Enter the network name: " networks
			echo "		networks:\n			- $networks\n" >> "$HOME/delta-onsite/${docker-comp}.yml" 
			read -p "Enter the container name: " container_name
			echo "		container_name: $container_name\n" >> "$HOME/delta-onsite/${docker-comp}.yml"
			read -p "Does it depend on other container: (y/n)" depend
			if [ "$depend" == "y" ]; then
				read -p "Enter the container name on which it depends: " depends_on
				echo "		depends_on:\n			-$depends_on" >>  "$HOME/delta-onsite/${docker-comp}.yml"
			fi
			read -p "Restart always: (y/n)" restart
			if [ "$restart" == "y" ]; then
				echo "		restart: always\n" >> "$HOME/delta-onsite/${docker-comp}.yml"
			fi
			read -p "Do you have environment variables for this service: (y/n)" env_var
			if [ "$env_var" == "y" ]; then
				variable_name=""
				echo "		environment:\n" >> "$HOME/delta-onsite/${docker-comp}.yml" 
				while [ "$variable_name" != "done" ]
				do
					read -p "Enter the environment variable name: " variable_name
					read -p "Enter the value of that variable: " variable_value
					echo "			$variable_name: $variable_value\n" >> "$HOME/delta-onsite/${docker-comp}.yml"
				done
			fi
			read -p "Enter the volume for the servive: " volume
			echo "			- $volume\n" >> "$HOME/delta-onsite/${docker-comp}.yml"
		fi
	done

	#printing the files we made
	cat $dockerfile
	cat ${docker-comp}.yml
fi
