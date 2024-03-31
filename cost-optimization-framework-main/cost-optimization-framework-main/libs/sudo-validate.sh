#!/bin/bash

####################################################################################
# 
# AUTHOR: Shehzad Shaikh shaikhsh01@rtlab.com
# DATE: 04-11-2023
# VERSION: 1.0.0
# DESCRIPTION: Validate if user has sudo privileges
# 
####################################################################################
# CHANGELOG:
# 
#
####################################################################################
#
# set -x 

ROOT_USER_ID="0"
LOGGED_IN_USER=$(id -u)

echo "INFO: Logged in user id: ${LOGGED_IN_USER}"


if [[ ${ROOT_USER_ID} -eq ${LOGGED_IN_USER} ]]; then
  # true statement
  echo "INFO: User with sudo privileg detected, proceeding with further execution."
else 
  # false statement
  echo "ERROR: Please execute the script with sudo privilege user."
  exit 1
fi
