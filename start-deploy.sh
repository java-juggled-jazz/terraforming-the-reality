#!/bin/bash
PWD=$(pwd)

echo "Checking if Terraform is installed..."

if ! command -v terraform &> /dev/null
then
    echo "Terraform could not be found. Please install Terraform and try again."
    return
fi

echo -e "Let's deploy VM with Kubernetes and Gitlab. \e[4mPress Ctrl + C to stop.\e[0m"
echo "How much Disk space is required?"
read disk_space
echo "How many CPU cores is required?"
read cpu_cores
echo "How much RAM is required?"
read ram
echo "Select any provider to continue"
echo -e "\n\e[4mTimeweb Cloud (1)\e[0m\n\n\e[4mYandex Cloud (2)\e[0m\n"
read provider

case $provider in
  "1")
  cd tf-twc
  ;;
  "2")
  cd tf-yc
  ;;
esac

terraform init
