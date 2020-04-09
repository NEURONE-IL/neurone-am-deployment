#!/bin/bash

localPath=$PWD
repositories=("neurone-am-connector" "neurone-am-coordinator" "neurone-am-visualization")
confFiles=("src/main/resources/application.conf" ".env" ".env")
activesRepositories=()

echo "                                         "
echo "Starting NEURONE-AM components deployment"
echo "First, choose the stage where you would like to start"
echo "#####################################################"
echo "1) Download/clone selected repositories"
echo "2) Update configuration files"
echo "3) Create and run dockers containers"
echo "                                    "
read -p " Select an option (1/2/3) : " action

echo "######################################################"
echo "Select the repositories you want to update or download"
echo "y=yes/n=not"
echo "                                                      "
for repository in ${repositories[@]}
do
    read -p "${repository}: (y/n) " option
    activesRepositories+=($option)
done

echo "#############################"
echo "Stargint deployment stages..."
# for option in ${activesRepositories[@]}
# do

#     echo ${option}
# done

if [ $action -le 1 ];
then
      echo "Cloning repositories"
      for index in ${!repositories[@]}
      do
            # echo ${activesRepositories[$index]}
        if [ ${activesRepositories[$index]} = "y" ]; then
            if [ -d "${repositories[$index]}" ]; then
                echo "Dicorectory ${repositories[$index]} still exists"
                echo "Deleting directory..."
                sudo rm -R "${repositories[$index]}"
            fi
            echo "Cloning repository ${repositories[$index]}..."
            git clone "https://github.com/NEURONE-IL/${repositories[$index]}.git"
        fi
      done
      echo "Cloning repositories done" 
fi

if [ $action -le 2 ]

then

    echo "Copying configuration files..."
    for i in "${!confFiles[@]}"
    do
        if [ ${activesRepositories[$i]} = "y" ];  then

            echo "Copying ${confFiles[$i]} to ${repositories[$i]}/${confFiles[$i]}..."
            sudo cp -rf "configuration/${repositories[$i]}/${confFiles[$i]}" "${repositories[$i]}/${confFiles[$i]}"

            echo "Copying dockerfiles..."
            sudo cp -rf "configuration/${repositories[$i]}/Dockerfile" "${repositories[$i]}/Dockerfile"
    
            echo "Copying scripts..."
            sudo cp -rf "configuration/${repositories[$i]}/runDocker.sh" "${repositories[$i]}/runDocker.sh"

            if [ $i = 1 ]; then

                echo "Copying pushpin configuration and script..."
                sudo cp -rf "configuration/${repositories[$i]}/pushpin" "${repositories[$i]}/"
            fi
        
        fi
    done
    echo "Configuration done"
fi

if [ $action -le 3 ]

then
    echo "Run Dockers containers"
    for index in ${!repositories[@]}
    do
        if [ ${activesRepositories[$index]} = "y" ]; then

            echo "Enter to ${repositories[$index]}"
            cd ${repositories[$index]}
            echo "Running docker script..."
            ./runDocker.sh
            echo "Docker done"
            cd ${localPath}
        fi
    done
    echo "Dockers containers running"
fi

echo "#############"
echo "End script!!"