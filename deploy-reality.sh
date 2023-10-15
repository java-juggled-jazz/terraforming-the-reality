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

mkdir -p outputs/ssh

timestamp=$(date +%F_%T)

ssh-keygen -f "outputs/ssh/key_$timestamp" -P ""
chmod 600 -R outputs/ssh

ssh_pub_key_dir=$(pwd)"/outputs/ssh/key_$timestamp.pub"

case $provider in
  "1")
  cd tf-twc
  terraform init -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="twc_token=$twc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform plan -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="twc_token=$twc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform apply -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="twc_token=$twc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  ;;
  "2")
  cd tf-yc

  echo -e "provider_installation {\n  network_mirror {\n    url = \"https://terraform-mirror.yandexcloud.net/\"\n    include = [\"registry.terraform.io/*/*\"]\n  }\n  direct {\n    exclude = [\"registry.terraform.io/*/*\"]\n  }\n}" > ~/.terraformrc

  terraform init -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_folder_id=$yc_folder_id" -var="yc_cloud_id=$yc_cloud_id" -var="yc_token=$yc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform plan -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_folder_id=$yc_folder_id" -var="yc_cloud_id=$yc_cloud_id" -var="yc_token=$yc_token"  -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  terraform apply -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_folder_id=$yc_folder_id" -var="yc_cloud_id=$yc_cloud_id" -var="yc_token=$yc_token" -var="ssh_pub_key_dir=$ssh_pub_key_dir"
  ;;
esac

cd ..
