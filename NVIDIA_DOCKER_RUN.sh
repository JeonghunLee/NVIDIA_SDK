#!/bin/bash 
#
# Check for installing NVIDIA SDK Package
# it's convinient to install NVIDIA SDK Package 
# 
# 
# Author  : Jeonghun Lee
# Version : 0.1
#
# Refer to 
# 
# How to use NVIDIA SDK
# - https://medium.com/@sh.tsang/docker-tutorial-5-nvidia-docker-2-0-installation-in-ubuntu-18-04-cb80f17cac65
# - https://github.com/NVIDIA/nvidia-docker

# - https://github.com/nvidia/nvidia-container-runtime
# - https://www.nvidia.co.kr/content/apac/event/kr/deep-learning-day-2017/dli-1/Docker-User-Guide-17-08_v1_NOV01_Joshpark.pdf
##  EXAMPLE OF DOCKER USE IN DGX-1

VERSION=`lsb_release -sr`
echo -e "\e[91mStart checking Ubuntu $VERSION package \e[39m\n"


TENSORFLOW_LOC=

RUN_NVIDIA_DOCKERS(){

    echo -e "\e[91m>>> Do you want to run NVIDIA CUDA/cuDNN\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
         nvidia-docker run --rm -ti –u $(id –u):$(id –g) --name cuda nvcr.io/nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04 nvidia-smi
    fi

    echo -e "\e[91m Tensorflow need local directory so have to prepare for local directory \e[39m"
    echo -e "\e[91m>>> Do you want to run Tensorflow\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
         docker run --gpus all -it --rm -v local_dir:container_dir nvcr.io/nvidia/tensorflow:xx.xx-pyx
    fi

}



CHECK_NVIDIA_DOCKERS(){
    
   
    echo -e "\e[91m>>> Do you want to run NVIDIA DOCKER \nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       RUN_NVIDIA_DOCKERS
    fi    

    CHECK=`sudo docker ps -a`
    echo "Check Docker Containter $CHECK"

    CHECK=`sudo docker images`
    echo "Check Docker Images $CHECK"
    

}



CHECK_NVIDIA_DOCKERS

echo -e "\e[91m>>> finished chekcing NVIDIA SDK packages for x86 \e[39m"

