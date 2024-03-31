#!/bin/bash
#
#
#
#

# Ignore resource group created by Azure for managing network watcher service and log analytics storage workspace
# Provide pipe-seperated list to add resource group in ignore
IGNORE_RESOURCE_GROUPS="NetworkWatcherRG"


for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do
  
  instance_state=$(aws ec2 describe-instances --instance-id ${instance_id} --query "Reservations[].Instances[].State.Name" --output text)

  if [[ ${instance_state} == "stopped" ]]; then
    echo "INFO: Instance is in stopped state, starting instance ${instance_id}..."

    aws ec2 start-instances --instance-ids ${instance_id} > /dev/null
  else
    echo "INFO: Instance ${instance_id} is already in running state."
  fi
done

for rg_name in $(az group list --query "[].name" -o tsv | grep -vE "${IGNORE_RESOURCE_GROUPS}"); do

  for vm_name in $(az vm list -g ${rg_name} --query "[?tags.shutdown=='true'].name" -o tsv); do
    
    vm_state=$(az vm show -d --name ${vm_name} -g gitlab-runner-rg --query 'powerState' -o tsv | awk '{print $NF}')

    if [[ ${vm_state} == "deallocated" ]]; then
      echo "INFO: VM is in deallocated state, starting azure vm ${vm_name}..."
      
      az vm start --name ${vm_name} --resource-group ${rg_name} --no-wait
    else
      echo "INFO: Azure VM ${vm_name} is already in running state."
    fi
  done
done
