#!/bin/bash

#here basically we ask user for inputs to generate a automate script to create and deploy containerized setup
#creating multiple containers using while loop
read "Enter the container's name if no other container then type done: " dockerfile
if [$dockerfile -ne "done"];then
	touch $dockerfile
	#generating base images (the initial libraries)
	read -p "Enter base image:" base_image
	echo "the base image is $base_image"
	grep -x "FROM $base_image" "~/delta-onsite/dockerfile" || echo "FROM $base_image" >> "~/delta-onsite/dockerfile"

	#asking for working directory
	read -p "Enter your working directory:" work_dir
	grep -x "WORKDIR $work_dir" "~/delta-onsite/dockerfile" || echo "WORKDIR $work_dir" "FROM $base_image" >> "~/delta-onsite/dockerfile"

	#asking for libraries
	while($package -ne "done")
	do
		read -p "Enter the package you want to install or type 'done' if all are done: " package
		if [$package -ne "done"];
		then
			 grep -x "RUN apt-get update && apt-get install -y $command" "~/delta-onsite/dockerfile" || echo "RUN apt-get update && apt-get install -y $command" >> "~/delta-onsite/dockerfile"
		fi
	done

	while($command -ne "done")
	do
        	read -p "Enter the package you want to install or type 'done' if all are done: " command
	        if [$command -ne "done"];
	        then

        	         grep -x "CMD [$command]" "~/delta-onsite/dockerfile" || echo "CMD [$command]" >> "~/delta-onsite/dockerfile"
	        fi
	done

	read 
	#asking for services and dependencies and network
	echo "services:\n" >> "~/delta-onsite/docker-comp.yml"
	while($input -ne "done")
	do
		read "Enter your first service name: " input
		if [$input -ne "done"];
		then
			echo "	$input:\n" >> "~/delta-onsite/docker-comp.yml"
			read -p "Enter the network name: " networks
			echo "		networks:\n			- $network\n" >> "~/delta-onsite/docker-comp.yml" 
			read -p "Enter the container name: " container_name
			echo "		container_name: $container_name\n" >> "~/delta-onsite/docker-comp.yml"
			read -p "Does it depend on other container: (y/n)" depend
			if [$depend -eq "y"];then
				read -p "Enter the container name on which it depends: " depends_on
				echo "		depends_on:\n			-$depends_on"
			fi
			read -p "Restart always: (y/n)" restart
			if [$restart -eq "y"];then
				echo "		restart: always\n" >> "~/delta-onsite/docker-comp.yml"
			fi
			read -p "Do you have environment variables for this service: (y/n)" env_var
			if [$env_var -eq "y"];then
				echo "		environment:\n"
				while("$env_variable" -ne "done")
				do
					read -p "Enter the environment variable name: " variable_name
					read -p "Enter the value of that variable: " variable_value
					echo "			$variable_name: $variable_value\n"
				done
			read -p "Enter the volume for the servive: " volume
			echo "			- $volume\n" >> "~/delta-onsite/docker-comp.yml"
		fi
	done

	done
fi
