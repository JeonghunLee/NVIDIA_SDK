#!/bin/bash 
#
# Check for installing NVIDIA NGC DOCKER
# 
# Author  : Jeonghun Lee
# Version : 0.1
#
# Refer to 
# 
# How to use NVIDIA DOCKER
# - https://medium.com/@sh.tsang/docker-tutorial-5-nvidia-docker-2-0-installation-in-ubuntu-18-04-cb80f17cac65
# - https://github.com/NVIDIA/nvidia-docker

# - https://github.com/nvidia/nvidia-container-runtime
# - https://www.nvidia.co.kr/content/apac/event/kr/deep-learning-day-2017/dli-1/Docker-User-Guide-17-08_v1_NOV01_Joshpark.pdf
##  EXAMPLE OF DOCKER USE IN DGX-1

VERSION=`lsb_release -sr`
echo -e "\e[91mStart checking Ubuntu $VERSION package \e[39m\n"

OSVERSION=`lsb_release -a`
echo -e "\e[91m $OSVERSION \e[39m\n"


INSTALL_DOCKER_CE(){
   CHECK_PKG=`dpkg -l | grep docker`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed docker by dpkg"
   else
        sudo apt install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
        sudo apt update
        READ=`apt-cache policy docker-ce`
        echo -e "$READ" 
        sudo apt install docker-ce
        READ=`sudo systemctl status docker`
        echo -e "$READ" 
   fi
}


INSTALL_NVIDIA_DOCKER2(){

# - https://docs.nvidia.com/deeplearning/frameworks/user-guide/index.html	
# - https://github.com/NVIDIA/nvidia-docker
# - https://forums.docker.com/t/unit-docker-service-not-found/75817

   CHECK_PKG=`dpkg -l | grep nvidia-container-toolkit`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
        echo "alreadly installed NVIDIA Docker2"
   else
	#   
        # try to remove NVIDIA Docker version1 if have NVIDIA Docker version 1
	#
        echo "remove NVIDIA Docker version 1"
        docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
        sudo apt-get purge nvidia-docker
	#
        # install NVIDIA Docker Version2  	
	#
        echo "start installing NVIDIA Docker Version 2"
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
        sudo systemctl restart docker

        sudo apt-get install nvidia-docker2
        sudo pkill -SIGHUP dockerd
   fi 
}


CHECK_DOCKER_IMAGE(){

    CHECK=`sudo docker ps -a`
    echo "Check Docker Containter $CHECK"

    CHECK=`sudo docker images`
    echo "Check Docker Images $CHECK"

    CHECK=`sudo docker version`
    echo "Check Docker VERSION $CHECK"

    CHECK=`sudo nvidia-docker version`
    echo "Check NVIDIA Docker VERSION $CHECK"
}




NVIDIA_DOCKERS(){
   
    echo -e "\e[91m>>> Do you want to install Docker-CE?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       INSTALL_DOCKER_CE
    fi

    echo -e "\e[91m>>> Do you want to install NVIDIA Docker 2?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       INSTALL_NVIDIA_DOCKER2
    fi

    echo -e "\e[91m>>> Do you want to check Docker Images and Status\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       CHECK_DOCKER_IMAGE
    fi
}


NVIDIA_DOCKERS

echo -e "\e[91m>>> finished installing/chekcing NVIDIA DOCKERS for x86 \e[39m"

