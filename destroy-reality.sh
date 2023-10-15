#!/bin/bash
echo "Now, I am become Death, the destroyer of worlds."

ssh_pub_key_dir=$pwd"/outputs/ssh"

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

  terraform init -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_folder_id=$yc_folder_id" -var="yc_cloud_id=$yc_cloud_id" -var="yc_tok>
  terraform plan -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_folder_id=$yc_folder_id" -var="yc_cloud_id=$yc_cloud_id" -var="yc_tok>
  terraform apply -var="disk_space=$disk_space" -var="cpu_cores=$cpu_cores" -var="ram=$ram" -var="yc_id=$yc_id" -var="yc_folder_id=$yc_folder_id" -var="yc_cloud_id=$yc_cloud_id" -var="yc_to>
  ;;
esac
