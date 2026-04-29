#!/usr/bin/env bash

##############################################################################################################
# DISCLAIMER : This script is made to be used with terraform provisioner local-exec present in cluster.tf file
#
# Expected environment variables:
#   MANIFEST_PATH  - path to the generated k0sctl YAML manifest
#   CLUSTER_NAME   - cluster name (used for kubeconfig naming)
#   NODE_IPS       - comma-separated list of all node IPs
#   SSH_USER       - username that will be used to connect to the VMs
#   SSH_KEY_PATH   - path to the private key used to connect to the VMs for bootstraping k0s 
##############################################################################################################

set -o errexit
set -o pipefail
set -o nounset

if [[ "${DEBUG:-false}" == "true" ]]; then
  set -o xtrace
  K0SCTL_DEBUG="--debug"
else
  K0SCTL_DEBUG=""
fi

K0S_KUBECONFIG="$HOME/.kube/${CLUSTER_NAME}.config"
K0S_KUBECONFIG_TODAY="$HOME/.kube/${CLUSTER_NAME}.config-$(date -I)"
SSH_TIMEOUT=120
SSH_INTERVAL=5
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

# --- SSH known_hosts cleanup and readiness check ---

IFS=',' read -ra IPS <<< "${NODE_IPS}"

for IP in "${IPS[@]}"; do
  # Cleanup known_hosts
  if ssh-keygen -F "${IP}" > /dev/null 2>&1; then
    echo "Removing old known_hosts entry for ${IP}"
    ssh-keygen -R "${IP}" > /dev/null 2>&1
  fi

  # Poll until SSH is ready
  echo -n "Waiting for SSH on ${IP} "
  elapsed=0
  until ssh -i "${SSH_KEY_PATH}" -l "${SSH_USER}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -o BatchMode=yes "${IP}" exit 2>/dev/null; do    elapsed=$((elapsed + SSH_INTERVAL))
    if [[ ${elapsed} -ge ${SSH_TIMEOUT} ]]; then
      _print_red "[FATAL] SSH not reachable on ${IP} after ${SSH_TIMEOUT}s"
      exit 1
    fi
    echo -n "."
    sleep ${SSH_INTERVAL}
  done
  echo " ready"
done

# Boostraping cluster 

if [[ -f "$K0S_KUBECONFIG" ]]; then
  echo "Found another kubeconfig file with the same name, appending today's date."
  k0sctl apply ${K0SCTL_DEBUG} --config "${MANIFEST_PATH}" --kubeconfig-out "${K0S_KUBECONFIG_TODAY}"
  _print_cyan "add this file to your KUBECONFIG variable ${K0S_KUBECONFIG_TODAY}"
else
  k0sctl apply ${K0SCTL_DEBUG} --config "${MANIFEST_PATH}" --kubeconfig-out "${K0S_KUBECONFIG}"
  _print_cyan "add this file to your KUBECONFIG variable ${K0S_KUBECONFIG}"
fi


