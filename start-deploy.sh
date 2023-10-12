#!/bin/bash
echo "How much Disk space is required?"
read disk_space
echo "How many CPU cores is required?"
read cpu_cores
echo "How much RAM is required?"
read ram
echo "Select any provider to continue"
echo -e "\n\033[4m1. Timeweb Cloud\033[m\n\n\033[4m2. Yandex Cloud\033[m\n"
read provider
