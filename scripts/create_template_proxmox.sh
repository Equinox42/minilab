#!/usr/bin/env bash
set -eu

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <image_url> <vmid> <template_name>" >&2
  exit 1
fi

IMAGE_URL="$1"
VMID="$2"
TEMPLATE_NAME="$3"
STORAGE=local-lvm
IMAGE_PATH="/tmp/$TEMPLATE_NAME-$VMID.qcow2"

if ! command -v virt-customize >/dev/null 2>&1; then
  echo "Error: virt-customize is not installed. Install it with: apt install libguestfs-tools" >&2
  exit 1
fi

if [[ "$IMAGE_URL" != *.qcow2 ]]; then
  echo "Error: image URL must point to a .qcow2 file" >&2
  exit 1
fi

if qm status "$VMID" >/dev/null 2>&1; then
  echo "Error: VM/template with ID $VMID already exists" >&2
  exit 1
fi

wget -O "$IMAGE_PATH" "$IMAGE_URL"
virt-customize -a "$IMAGE_PATH" --install qemu-guest-agent

qm create "$VMID" --name "$TEMPLATE_NAME" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0 --agent enabled=1
qm importdisk "$VMID" "$IMAGE_PATH" "$STORAGE" --format qcow2
qm set "$VMID" --scsihw virtio-scsi-pci --scsi0 "$STORAGE:vm-$VMID-disk-0"
qm set "$VMID" --ide2 "$STORAGE:cloudinit"
qm set "$VMID" --boot c --bootdisk scsi0
qm set "$VMID" --serial0 socket --vga serial0
qm template "$VMID"

rm -f "$IMAGE_PATH"