## Using Docker without Docker Desktop on MacOS

For me using Multipass seemed to be the easiest way to eliminate docker desktop as a mac user. Multipass will enable you to create a small vm (like docker desktop) that you’ll use the docker cli/tools to connect and issue docker commands. Docker-compose (on the host) works exactly as before.

Any containers mapped to public ports will be accessible to http://docker.local:XXXXX (not localhost);

```
brew install multipass docker
``` 

Run the following :

```
# Chose **ONE** relevant hupervisor backend, hyptekit is default, qemu / virtualbox are options
sudo multipass set local.driver=hyperkit
sudo multipass set local.driver=virtualbox
sudo multipass set local.driver=qemu

multipass launch -c 12 -m 6G -d 60G -n docker 20.04 --cloud-init docker.yml
```

Options:
Parameters mean the following:
-c 	= core count
-d 	= disk count 
-m 	= memory 
20.04 = version of ubuntu server to use

A new local vm will be provisioned and take a few minutes to start. You can whether the machine is up by running the following:

``` multipass list```

You should also be able to ssh into the provisioned vm

```ssh ubuntu@docker.local```
or 
```multipass shell docker```

### Docker Volumes
Run the following to ensure the VM can reach areas of you disk that Docker Desktop would normally make available. This is important if you want to use mounts.

```
mutlipass mount /Users docker
multipass mount /tmp docker
multipass mount /private docker
multipass mount /Volumes docker
```

### Docker Context
Setup a docker context which will allow the docker cli to just work as normal from a terminal

```docker context create multipass_docker --docker "host=ssh://ubuntu@docker.local"```
### Without Docker Context

To run docker commands, prefix DOCKER_HOST or setup a docker context

```DOCKER_HOST="ssh://ubuntu@docker.local" docker ps```

Or add the following to your bash / zsh profile

```export DOCKER_HOST="ssh://ubuntu@docker.local"```
### Docker Desktop UI Replacement
Replacement for Docker Desktop UI

Use something like Portainer if you need/want something graphical to administer or work with containers and look at log files etc.

```
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer     --restart=always     -v /var/run/docker.sock:/var/run/docker.sock     -v portainer_data:/data     portainer/portainer-ce:latest
```
Login at https://docker.local:9443/#!/2/docker/containers 
 
### VSCode Dev-Containers
I had issues with Ubuntu 21.04 and some of the EXA Dev Containers in use. These instructions have been updated to use 20.04 LTS version of ubuntu as the image.
