#!/bin/bash
mkdir -p "$HOME/delta-onsite"
dockerfile=""
while [ "$dockerfile" != "done" ]
do
#here basically we ask user for inputs to generate a automate script to create and deploy containerized setup
#creating multiple containers using while loop
read -p "Enter the container's name if no other container then type done: " dockerfile
if [ "$dockerfile" != "done" ]; then
	touch "$HOME/delta-onsite/$dockerfile" 
	#generating base images (the initial libraries)
	read -p "Enter base image:" base_image
	echo "the base image is $base_image"
	grep -x "FROM $base_image" "$HOME/delta-onsite/$dockerfile" || echo -e "FROM $base_image\n" >> "$HOME/delta-onsite/$dockerfile"

	#asking for working directory
	read -p "Enter your working directory:" work_dir
	grep -x "WORKDIR $work_dir" "$HOME/delta-onsite/$dockerfile" || echo "WORKDIR $work_dir" >> "$HOME/delta-onsite/$dockerfile"

	#asking for libraries
	package=""
	while [ "$package" != "done" ]
	do
		read -p "Enter the package you want to install or type 'done' if all are done: " package
		if [ "$package" != "done" ];
		then
			 grep -x "RUN apt-get update && apt-get install -y $package" "$HOME/delta-onsite/$dockerfile" || echo "RUN apt-get update && apt-get install -y $package" >> "$HOME/delta-onsite/$dockerfile"
		fi
	done


	read -p "Enter source to copy (default .): " source
	[ -z "$source" ] && source="."

	read -p "Enter destination inside container (default .): " destination
	[ -z "$destination" ] && destination="."

	echo "COPY $source $destination" >> "$HOME/delta-onsite/$dockerfile"

    	read -p "Enter the command you want to run: " command
        grep -x "CMD $command" "$HOME/delta-onsite/$dockerfile" || echo "CMD $command" >> "$HOME/delta-onsite/$dockerfile"

	#creating docker compose file
	read -p "Enter the name of your docker_compose file: " docker_comp
	touch "$HOME/delta-onsite/${docker_comp}.yml"
	#asking for services and dependencies and network
	echo "services:\n" >> "$HOME/delta-onsite/${docker_comp}.yml"
	input=""
	while [ "$input" != "done" ]
	do
		read -p "Enter your first service name: " input
		if [ "$input" != "done" ];
		then
			echo "	$input:\n" >> "$HOME/delta-onsite/${docker_comp}.yml"
			read -p "Enter the network name: " networks
			echo "		networks:\n			- $networks\n" >> "$HOME/delta-onsite/${docker_comp}.yml" 
			read -p "Enter the container name: " container_name
			echo "		container_name: $container_name\n" >> "$HOME/delta-onsite/${docker_comp}.yml"
			read -p "Enter build context (default .): " context
		[ -z "$context" ] && context="."

			read -p "Enter Dockerfile name (default $dockerfile): " dockerfile_name
			[ -z "$dockerfile_name" ] && dockerfile_name="$dockerfile"

			echo "    build:" >> "$HOME/delta-onsite/${docker_comp}.yml"
			echo "      context: $context" >> "$HOME/delta-onsite/${docker_comp}.yml"
			echo "      dockerfile: $dockerfile_name" >> "$HOME/delta-onsite/${docker_comp}.yml"
			read -p "Does it depend on other container: (y/n)" depend
			if [ "$depend" == "y" ]; then
				read -p "Enter the container name on which it depends: " depends_on
				echo "		depends_on:\n			-$depends_on" >>  "$HOME/delta-onsite/${docker_comp}.yml"
			fi
			read -p "Restart always: (y/n)" restart
			if [ "$restart" == "y" ]; then
				echo "		restart: always\n" >> "$HOME/delta-onsite/${docker_comp}.yml"
			fi
			read -p "Do you have environment variables for this service: (y/n)" env_var
			if [ "$env_var" == "y" ]; then
				variable_name=""
				echo "		environment:\n" >> "$HOME/delta-onsite/${docker_comp}.yml" 
				while [ "$variable_name" != "done" ]
				do
					read -p "Enter the environment variable name: " variable_name
					[ "$variable_name" == "done" ] && break
					read -p "Enter the value of that variable: " variable_value
					echo "			$variable_name: $variable_value\n" >> "$HOME/delta-onsite/${docker_comp}.yml"
				done
			fi
			echo "		volumes:\n" >>  "$HOME/delta-onsite/${docker_comp}.yml"
			volume=""
			while [ "$volume" != "done" ]
			do
			read -p "Enter the volume for the servive or type 'done' to end: " volume
			[ "$volume" == "done" ] && break
			echo "			- $volume\n" >> "$HOME/delta-onsite/${docker_comp}.yml"
			done
		fi
	done
	echo "	networks:\n		-$networks\n" >> "$HOME/delta-onsite/${docker_comp}.yml"


	#printing the files we made
	cat "$HOME/delta-onsite/$dockerfile"
	cat "$HOME/delta-onsite/${docker_comp}.yml"
fi
done
