#!/bin/bash 
#
# Check for installing NVIDIA NGC DOCKER
# 
# Author  : Jeonghun Lee
# Version : 0.1
#
# Refer to 

OSVERSION=`lsb_release -a`
echo -e "\e[91m $OSVERSION \e[39m\n"


INSTALL_PYTHON23(){

   echo -e "\e[91m>>> check python/python3 \e[39m"

   CHECK_PKG=`dpkg -l | grep python`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed python/python3"
   else
        sudo apt install python3-pip
        sudo apt install python-pip
   fi

   VER=`python2 --version`
   echo  "$VER"
   VER=`python3 --version`
   echo  "$VER"
}

INSTALL_JUPYTER(){

   echo -e "\e[91m>>> check jupyter notebook for python2/3 \e[39m"

   CHECK_PKG=`pip list | grep notebook`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed jupyter notebook for python2/3"
   else
        sudo pip install notebook
        sudo pip3 install notebook
   fi
}
   
INSTALL_ANACONDA(){

   echo -e "\e[91m>>> check anaconda for python2/3 \e[39m"
   ID=`whoami`
   CHECK_PKG="/home/$ID/anaconda3"

   if [ -d $CHECK_PKG  ]; then
        echo "alreadly installed Anaconda"
   else
        echo "start downloading Anaconda package"
        wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
        CHECKSUM=`mdsum Anaconda3-2019.07-Linux-x86_64.sh`
        if [ CHECKSUM -eq "63f63df5ffedf3dbbe8bbf3f56897e07"]; then
               echo " try to install"
        fi
   fi

}



INSTALL_PYTHON_PKG(){
   
    echo -e "\e[91m>>> Do you want to install Python2,3?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       INSTALL_PYTHON23
    fi

    echo -e "\e[91m>>> Do you want to install JUPYTER NOTEBOOK?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       INSTALL_JUPYTER
    fi

    echo -e "\e[91m>>> Do you want to install ANACONDA?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       INSTALL_ANACONDA
    fi
}


INSTALL_PYTHON_PKG

echo -e "\e[91m>>> finished installing/chekcing python package for x86 \e[39m"

