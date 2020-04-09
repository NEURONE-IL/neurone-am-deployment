# Neurone AM Deployment

Neurone-AM (Active Monitoring) is a solution aimed at the real-time delivery, throught a persistent connection, of updated metrics to measure the performance of users when they use the [NEURONE](https://github.com/NEURONE-IL/neurone) search engine. It consists of three components that interact with each others: [neurone-am-connector](https://github.com/NEURONE-IL/neurone-am-connector.git), [neurone-am-coordinator](https://github.com/NEURONE-IL/neurone-am-coordinator.git), and [neurone-am-visualization](https://github.com/NEURONE-IL/neurone-am-visualization.git).

This repository provides a enviroment to deploy and configure all Neurone-AM components together in A GNU/Linux Machine.

## Neurone AM Components

Neurone-AM is made up of three componets with differents roles. Each is briefly described below:

* [neurone-am-connector](https://github.com/NEURONE-IL/neurone-am-connector.git): This component is a API REST that provides a set of services to calculate behavioral and performance metrics for participans of NEURONE search engine. Therefore, it interact directly with NEURONE database to get the all necesary data for the process.
* [neurone-am-coordinator](https://github.com/NEURONE-IL/neurone-am-coordinator.git): Coordinator component is responsible of deliver the metrics in real time through a persistent connection to the clients or consumers of its. This handle the interaction between neruone-am-connector API and any client as neurone-am-visualization client prototype. Also, support publish-subscribe pattern.
* [neurone-am-visualization](https://github.com/NEURONE-IL/neurone-am-visualization.git): Visualization component is a Front-end prototype client that allow to a observer visualize the behavior and performance of all users. Therefore, through this component differents metrics are displayed and actualized in a defined update interval. This component interact directly with neurone-am-coordinator through subscription and consumption of previously selected metrics.



## Deployment Instrucctions

First, the following requirements must be met to successfully deploy the solution:

* The [NEURONE](https://github.com/NEURONE-IL/neurone) Mongo Database must be initialized.
* [Docker](https://www.docker.com/) installed.

Below are listed the instructtions to do the deployment:

1. Download or clone this repository.
2. Go to to the neurone-am-deployment directory.
3. The first time, run `sudo chmod 777 runAll.sh` to grant script permissions.
4. Set up the configuration variables for each component in the configuration folder (See Configuration section).
5. Run `./runAll.sh` to init the process.
6. Choose the stage from which you want to start the implementation process. Those are listed below:
    - Clone selected components repositories.
    - Copy configurations files to the cloned repositories
    - Run docker containers.
```sh
Starting NEURONE-AM components deployment
First, choose the stage where you would like to start
#####################################################
1) Download/clone selected repositories
2) Update configuration files
3) Create and run dockers containers
                                    
 Select an option (1/2/3) : 1 #Start from the first stage.
```
7. Choose the components to which you want to apply the previous choice with the "y" option for each one. For example:
```sh
Select the repositories you want to update or download
y=yes/n=not
                                                      
neurone-am-connector: (y/n) y  #yes
neurone-am-coordinator: (y/n) y #yes
neurone-am-visualization: (y/n) n #not
```
8. Wait for the script to finish. The first time will take longer because the dockers creation.
9. Run `docker ps` to verify that all docker containers are running. The following containers should appear:
    - ctn_neurone_visualization  (visualization component).
    - ctn_neurone_pushpin       (coordinator component proxy).
    - ctn_neurone_coordinator   (coordinator component API Rest).
    - ctn_neurone_conector      (connector component).
10. By default the component are running in the following ports:
    - visualization: 3000
    - coordinator: 4001
    - connector: 8081
11. To stop all docker run `./stopAll.sh`.


## Configuration

To change the default settings for each component, access its folder in the configuration directory. 

When the component port is changed its runDocker.sh script also must be modify with new ports.

#### neurone-am-connector

The most important thing is define the NEURONE Mongo DB settings (Mongo DB NAME and Mongo URL). Also, you can change the default API port. To do this:
1. In the root directory of the project run `cd configuration/neurone-am-connector/src/main/resources/ `
2. Modify the variables in the application.conf file. This is a example of that file:
```conf
mongo {
    MONGO_URL="mongodb://username:password@localhost:27017/?authSource=db_name"
    MONGO_DB="db_name"
}

app{
    PORT="8081"
}
```
#### neurone-am-coordinator

The coordinator component is made up of the Pushpin proxy and a REST API node.js. They both have variables that can be modified.

* Pushpin: Because the principal task of pushpin is the request redirection to the API REST his url must be definted. For this, change the routes file in the pushpin folder with the API_URL. On the other hand, in the pushpin.conf file there are more complex parameters and it not necessary edit this. See [pushpin configuration](https://pushpin.org/docs/configuration/) for more details.
1. In the root directory of the project run `cd configuration/neurone-am-coordinator/pushpin/pushpin/`.
2. Modify the variables in the routes file. This is a example of that file:

    ```sh
    * localhost:4001 
    ```
* Coordinator API: The coordinator must interact with neurone-am-connector API as well as the Pushpin proxy. The url of each one must be defined in a .env file in the root folder. Adiotionally, the API port and NODE_ENV can be modified here.
1. In the root directory of the project run `cd configuration/neurone-am-coordinator/`.
2. Modify the variables in the .env file. This is a example of that file:
```env
PORT=4001  #coordinator API port
NODE_ENV=production 
PUSHPIN_URL=http://localhost:5561  # Pushpin proxy default url
CONECTOR_URL=http://localhost:8081 # neurone-am-connector API url
```

#### neurone-am-visualization

The component interact with neurone-am-coordinator. Therefore, its url must be configured in a .env file in the configuration folder.

1. In the root directory of the project run `cd configuration/neurone-am-visualization/`.
2. Modify the variables in the .env file. This is a example of that file:
```env
VUE_APP_API_URL=http://localhost:7999 #Proxy default consumers url
```

## License
Licensed under the GNU General Public License (Version 3) [LICENSE](LICENSE) ; you may not use this software except in compliance with the License.