#!/bin/bash
#
#


echo "INFO: Installing azure command line utilities."

# Check if aws cli is installed
command -v az > /dev/null

RETURN_CODE=${?}


if [[ ${RETURN_CODE} -ne 0 ]]; then
  echo "INFO: Installing az cli..."

  # Install pre-requisites tool
  apt-get update -y > /dev/null
  apt-get install curl -y > /dev/null

  # Download installation script
  mkdir /opt/scripts

  curl -sL https://aka.ms/InstallAzureCLIDeb > /opt/scripts/install_az.sh
  chmod +x /opt/scripts/install_az.sh

  /opt/scripts/install_az.sh > /dev/null

  # Post installation-check
  if command -v az > /dev/null; then
    echo "INFO: Az cli successfully installed."
  else
    echo "ERROR: Az cli installation failed."
    exit 1
  fi

else
  echo "INFO: Az cli is already installed, skipping installation."
fi
