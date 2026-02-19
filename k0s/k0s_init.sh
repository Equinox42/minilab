#!/usr/bin/env bash

##############################################################################################################
# DISCLAIMER : This script is made to be used with terraform provisioner local-exec present in cluster.tf file
##############################################################################################################

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

K0S_KUBECONFIG="$HOME/.kube/${CLUSTER_NAME}.config"

# Function to print in red
_print_red() {
  echo -e "\033[0;31m$1\033[0m"
}

_print_cyan() {
  echo -e "\033[0;36m$1\033[0m"
}

cat <<EOF
===========================================
STARTING KUBERNETES CLUSTER CONFIGURATION
===========================================
EOF

# Test if k0sctl binary is present 

if ! command -v k0sctl >/dev/null 2>&1; then
  _print_red "[FATAL] 'k0sctl' binary could not be found. Please install it or add it to your PATH variable."
  exit 1
fi
# Test if the k0sctl manifest is present

if [[ ! -f "${MANIFEST_PATH}" ]]; then
  _print_red "[FATAL] k0sctl manifest is missing at ${MANIFEST_PATH}"
  exit 1
fi

# Cleaning up ~/.ssh/known_host 

echo "Cleaning up already existant hosts in $HOME/.ssh/known_hosts"

for IP in "${CONTROLLER_IP}" "${WORKER1_IP}" "${WORKER2_IP}" "${WORKER3_IP}"; do
  

  if [[ -n "${IP}" ]] && ssh-keygen -F "${IP}" > /dev/null 2>&1; then
    echo "cleaning entry for '${IP}' previous entry will be found at $HOME/.ssh/known_hosts.old"
    ssh-keygen -R "${IP}" > /dev/null 2>&1
  else
    echo "no entry was found for '${IP}'"
  fi

done

sleep 5

# Boostraping cluster 

if [[ -f "$K0S_KUBECONFIG" ]]; then
  echo "Found another kubeconfig file with the same name, appending today's date."
  k0sctl apply --config "${MANIFEST_PATH}" --kubeconfig-out "${K0S_KUBECONFIG}-$(date -I)"
  _print_cyan "add this file to your KUBECONFIG variable "${K0S_KUBECONFIG}-$(date -I)"
else
  k0sctl apply --config "${MANIFEST_PATH}" --kubeconfig-out "${K0S_KUBECONFIG}"
  _print_cyan "add this file to your KUBECONFIG variable ${K0S_KUBECONFIG}"
fi

