#!/bin/bash

set -e

clustername=$1

if [ $# -eq 0 ]; then
  echo "Cluster name argument is required."
  exit 1
fi

aws=/usr/local/bin/aws
flynn=/usr/local/bin/flynn

echo "flynnbackup for $clustername starting at $(date)"

timestamp=$(date +"%Y-%m-%dT%H-%M-%S")
backup_folder="$clustername"
backup_path="$backup_folder/$timestamp.tar"

mkdir -p "/tmp/$backup_folder"

$flynn -c $clustername cluster backup --file "/tmp/$backup_path"

$aws --region "{{ backups_s3_bucket_region }}" s3 cp "/tmp/$backup_path" "s3://{{ backups_s3_bucket_name }}/$backup_path"

echo "Backup for Flynn $clustername created: $timestamp.tar"

json_file_size=$(tar tvf "/tmp/$backup_path" | grep "/flynn.json" | awk '{print $3}')
echo "JSON file size is $json_file_size"
if [ "$json_file_size" == "0" ]; then
  echo "ERROR: JSON file is empty"
  exit 2
fi
