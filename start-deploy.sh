#!/bin/bash
echo "Checking if Terraform is installed..."

if ! command -v terraform &> /dev/null
then
    echo "Terraform could not be found. Please install Terraform and try again."
    return
fi

echo -e "Let's deploy VM with Kubernetes and Gitlab. \e[4mPress Ctrl + C to stop.\e[0m"
echo "How much Disk space in GiB is required?"
read disk_space
echo "How many CPU cores is required?"
read cpu_cores
echo "How much RAM in GiB is required?"
read ram
echo "Select any provider to continue"
echo -e "\n\e[4mTimeweb Cloud (1)\e[0m\n\n\e[4mYandex Cloud (2)\e[0m\n"
read provider

source credentials

mkdir outputs > /dev/null
mkdir outputs/ssh > /dev/null

ssh-keygen -f outputs/ssh/key -P ""
chmod 700 -R outputs/ssh

ssh_pub_key_dir=$(pwd)"/outputs/ssh/key"

case $provider in
  "1")
  cd tf-twc
  terraform init -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="twc_token=$twc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform plan -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="twc_token=$twc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform apply -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="twc_token=$twc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  ;;
  "2")
  cd tf-yc
  terraform init -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_service_account_id=$yc_service_account_id" -var="yc_public_key=$yc_public_key" -var="yc_private_key=$yc_private_key" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform plan -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform apply -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  ;;
esac

cd ..
