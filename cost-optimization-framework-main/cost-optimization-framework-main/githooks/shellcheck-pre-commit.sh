#!/bin/bash
#
#
#

# Install shellcheck utility
if ! command -v shellcheck > /dev/null; then
  SHELLCHECK_VERSION="shellcheck-v0.9.0"
  SHELLCHECK_BINARY="/tmp/${SHELLCHECK_VERSION}/shellcheck"

  if [[ ! -f ${SHELLCHECK_BINARY} ]]; then
    wget -q https://github.com/koalaman/shellcheck/releases/download/v0.9.0/${SHELLCHECK_VERSION}.linux.x86_64.tar.xz -O /tmp/${SHELLCHECK_VERSION}.tar.xz

    tar -xvf /tmp/${SHELLCHECK_VERSION}.tar.xz -C /tmp > /dev/null
    rm -f /tmp/${SHELLCHECK_VERSION}.tar.xz
  fi
else
  SHELLCHECK_BINARY=$(command -v shellcheck)
fi


# Run against all .sh files or shellscripts that are in staging area
SHELL_FILES=$(git diff --cached --name-only | grep -E '.sh$')

if [[ -n ${SHELL_FILES} ]]; then

  # shellcheck disable=SC2046
  ${SHELLCHECK_BINARY} $(echo ${SHELL_FILES}) --severity=warning

  if [[ $? -ne 0 ]]; then
    echo -e "\nERROR: shellcheck detected warnings or errors, please see above and fix the issue(s).\n"
    exit 1
  fi
fi



