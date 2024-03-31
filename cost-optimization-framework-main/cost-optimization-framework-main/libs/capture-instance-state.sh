#!/bin/bash
#
# csp,instance_name,instance_ip,instance_state,date,tags
#

# Ignore resource group created by Azure for managing network watcher service and log analytics storage workspace
# Provide pipe-seperated list to add resource group in ignore
IGNORE_RESOURCE_GROUPS="NetworkWatcherRG"

OUTPUT_CSV_FILE="instance-report.csv"

# Add header to cs file
echo "CSP,INSTANCE_NAME,INSTANCE_IP,INSTANCE_STATE,DATE,TAGS" > ${OUTPUT_CSV_FILE}

# ---------------------------------------
# AWS: Capture aws ec2 instance state 
# ---------------------------------------
for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do
  
  instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${instance_id}" --query "Tags[?Key=='Name'].Value" --output text)
  instance_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance_name}" --query 'Reservations[].Instances[].PrivateIpAddress' --output text)
  datestamp=$(date +%Y%m%d-%H%M%S)
  
  instance_state=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance_name}" --query 'Reservations[].Instances[].State.Name' --output text) 

  printf "Waiting for instance operation of ${instance_name}."

  while true; do
    if [[ ${instance_state} == "stopped" ]] || [[ ${instance_state} == "running" ]]; then
      break
    fi

    instance_state=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance_name}" --query 'Reservations[].Instances[].State.Name' --output text)
    printf "."
  done

  echo
  echo "aws,${instance_name},${instance_ip},${instance_state},${datestamp},shutdown" >> ${OUTPUT_CSV_FILE}
done

# -------------------------------------------
# Azure: Capture azure virtual machine state 
# --------------------------------------------
for rg_name in $(az group list --query "[].name" -o tsv | grep -vE "${IGNORE_RESOURCE_GROUPS}"); do
  for vm_name in $(az vm list -g ${rg_name} --query "[?tags.shutdown=='true'].name" -o tsv); do
    
    vm_ip=$(az vm show --name ${vm_name} -g ${rg_name} -d --query 'privateIps' -o tsv)
    vm_state=$(az vm show --name ${vm_name} -g ${rg_name} -d --query 'powerState' -o tsv | awk '{print $NF}')
    datestamp=$(date +%Y%m%d-%H%M%S)
    
  printf "Waiting for instance operation of ${vm_name}."

    while true; do
      if [[ ${vm_state} == "deallocated" ]] || [[ ${vm_state} == "running" ]]; then
        break
      fi

      vm_state=$(az vm show -d --name ${vm_name} -g gitlab-runner-rg --query 'powerState' -o tsv | awk '{print $NF}')
      printf "."
    done

    echo
    echo "azure,${vm_name},${vm_ip},${vm_state},${datestamp},shutdown" >> ${OUTPUT_CSV_FILE}
  done
done
