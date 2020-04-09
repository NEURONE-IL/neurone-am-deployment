#!/bin/bash

sudo docker stop ctn_neurone_visualization
sudo docker rm ctn_neurone_visualization
sudo docker rmi img_neurone_visualization


sudo docker build -t img_neurone_visualization .
sudo docker run  --network=host -p 3000:3000   --name ctn_neurone_visualization -d img_neurone_visualization