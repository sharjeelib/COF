#!/bin/bash
#
#
# filename: csp-authentication.sh
# 

CREDENTIAL_FILE=""
DEFAULT_CREDENTIAL_LOCATIONS=(
  "${BASE_DIR}/.cof/csp_auth.yaml"
  "$HOME/.cof/csp_auth.yaml"
)

if [[ ${1} == "--auth-file" ]]; then
  CREDENTIAL_FILE="${2}"

else
  echo "INFO: Authentication file not provided at runtime checking file at default locations."

  for file in "${DEFAULT_CREDENTIAL_LOCATIONS[@]}"; do
    if [[ -f ${file} ]]; then
      echo "INFO: Authentication file found at default location ${file}"
      CREDENTIAL_FILE=${file}
      break
    fi
  done
fi

if [[ -z ${CREDENTIAL_FILE} ]]; then
  echo "ERROR: Credential file doesn't exist or not found"
  exit 1
fi

# Check if yq is installed, if not then install it.
if ! command -v yq >/dev/null; then
  echo "INFO: Installing yq command"
  wget -q https://github.com/mikefarah/yq/releases/download/v4.40.3/yq_linux_amd64
  chmod +x yq_linux_amd64
  mv yq_linux_amd64 /usr/local/bin/yq
fi

# ----------------------------------
# Set AWS authentication variable
# ----------------------------------
echo "INFO: Reterving AWS authentication information from YAML file"
AWS_REGION=$(yq -r ".auth_configs.aws.region" ${CREDENTIAL_FILE})
AWS_OUTPUT=$(yq -r ".auth_configs.aws.output" ${CREDENTIAL_FILE})
AWS_ACCESS_KEY_ID=$(yq -r ".auth_configs.aws.access_key" ${CREDENTIAL_FILE})
AWS_SECRET_ACCESS_KEY=$(yq -r ".auth_configs.aws.secret_access_key" ${CREDENTIAL_FILE})

# Configure aws cli and authentication aws cli
echo "INFO: Configure AWS authentication and CLI options"
aws configure set region ${AWS_REGION}
aws configure set output ${AWS_OUTPUT}
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}

# Validate authentication
if aws sts get-caller-identity >/dev/null 2>&1; then
  IAM_USER_NAME=$(aws sts get-caller-identity --query 'Arn' --output text | awk -F"/" '{print $NF}')
  echo "INFO: Successfully logged in with IAM User ${IAM_USER_NAME}"
else
  echo "ERROR: Unexpected error occured while authenticating with IAM User"
  exit 1
fi

# ----------------------------------
# Set Azure authentication variable
# ----------------------------------
# Configure azure cli and authenticate azure cli
echo "INFO: Configure Azure authentication and CLI options"

AZURE_TENANT_ID=$(yq -r ".auth_configs.azure.tenant_id" ${CREDENTIAL_FILE})
AZURE_CLIENT_ID=$(yq -r ".auth_configs.azure.client_id" ${CREDENTIAL_FILE})
AZURE_CLIENT_SECRET=$(yq -r ".auth_configs.azure.client_secret" ${CREDENTIAL_FILE})
AZURE_SUBSCRIPTION_ID=$(yq -r ".auth_configs.azure.subscription_id" ${CREDENTIAL_FILE})

az login --service-principal \
  -u ${AZURE_CLIENT_ID} \
  -p ${AZURE_CLIENT_SECRET} \
  --tenant ${AZURE_TENANT_ID} \
  --allow-no-subscriptions >/dev/null

# Set active subscription 
az account set --subscription "${AZURE_SUBSCRIPTION_ID}"

if az account show >/dev/null 2>&1; then

  AZURE_APP_NAME=$(az ad sp show --id "$(az account show --query 'user.name' -o tsv)" --query appDisplayName -o tsv)
  echo "INFO: Successfully logged in with Azure App ${AZURE_APP_NAME}"
else
  echo "ERROR: Unexpected error occured while authenticating with AZ CLI command."
  exit 1
fi
