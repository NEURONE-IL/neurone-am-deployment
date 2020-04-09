#!/bin/bash


echo "Stop visualization"
sudo docker stop ctn_neurone_visualization
sudo docker rm ctn_neurone_visualization
sudo docker rmi img_neurone_visualization

echo "Visualization stoped"

echo "Stop coordinator"

sudo docker stop ctn_neurone_coordinator
sudo docker rm ctn_neurone_coordinator
sudo docker rmi img_neurone_coordinator

echo "Coordinator stoped"

echo "Stop conector"

sudo docker stop ctn_neurone_conector
sudo docker rm ctn_neurone_conector
sudo docker rmi img_neurone_conector

echo "Conector stoped"


echo "Stop pushpin"

sudo docker stop ctn_neurone_pushpin
sudo docker rm ctn_neurone_pushpin
echo "Pushpin stoped"


echo "All containers stoped"