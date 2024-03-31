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
# Bootstrap scripts executes the initialization phase of application/program.
#

# ------------- FUNCTION ----------------------
# NAME: script_usage
# DESCRIPTION: Print the usage of the script.
# --------------------------------------------
script_usage(){
  echo ""
  echo "USAGE:"
  echo "  sudo ./$0 --action <start|stop>" 
}

# ========================================================================
# =================== MAIN PROGRAM EXECUTION =============================
# =========================================================================
BASE_DIR="$(pwd)"

MAIL_RECIPIENT="shehzadshaik91@gmail.com,shaikhsh01.dso@gmail.com"
MAIL_FROM="noreply-cof@rtlab.com"
MAIL_COTENT="${BASE_DIR}/rendered-email-content.html"


# Validate if script is executed with sudo privileges
. ${BASE_DIR}/libs/sudo-validate.sh

# If no argument passed to script exit the execution.
if [[ ${#} -eq 0 ]]; then
  echo "ERROR: Missing require script parameter."
  
  script_usage
  exit 1
fi

if [[ ${1} == "--action" ]]; then
  ACTION=${2}
else
  echo "ERROR: Unrecognized parameter supplied to script, ${2}"

  script_usage
  exit 1  
fi

# Install cloud cli tools
. ${BASE_DIR}/libs/install-aws-cli.sh
. ${BASE_DIR}/libs/install-az-cli.sh

# Authenticate to cloud
. ${BASE_DIR}/libs/csp-authentication.sh

# Perform instance/vm start or stop action
if [[ ${ACTION} == "stop" ]]; then
  . ${BASE_DIR}/libs/shutdown-instances.sh

elif [[ ${ACTION} == "start" ]]; then
  . ${BASE_DIR}/libs/start-instances.sh

else
  echo "ERROR: Wrong value provided for parameter --action: ${ACTION}"
  script_usage
  exit 1
fi

# Capture instance state and create csv report
. ${BASE_DIR}/libs/capture-instance-state.sh

# Generate HTML status report for email notification
. ${BASE_DIR}/libs/generate-html-report.sh

# ----------------------------------
# Send email notification
# ----------------------------------
if [[ ! -f ${MAIL_COTENT} ]]; then
  echo "ERROR: Email template file '${MAIL_COTENT}' missing/not found."
  exit 1
fi

sendmail $MAIL_RECIPIENT <<EOF
From: $MAIL_FROM
To: $MAIL_RECIPIENT
Subject: Daily Instance Schedule Report
Content-Type: text/html

$(cat ${MAIL_COTENT})
EOF
