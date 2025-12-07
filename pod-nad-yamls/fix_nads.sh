#!/bin/bash
for f in nad-n3-*.yaml nad-n4-*.yaml nad-n6-*.yaml nad-dsf-*.yaml; do
  [[ ! "$f" =~ yamlov ]] || continue
  name=$(basename "$f" .yaml | sed 's/nad-//')
  vlan=$(echo "$name" | grep -o '[0-9]\+' | head -1)
  cat > "$f" << NADEOF
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: $name
  annotations:
    k8s.v1.cni.cncf.io/resourceName: aws-cse-lc-bundle/mlnx_sriov_netdevice 
spec:
  config: '{
  "type": "sriov",
  "cniVersion": "0.3.1",
  "name": "sriov-network",
  "vlan": $vlan,
  "logLevel": "debug",
  "ipam": {
        "type": "static",
        "addresses": [{"address": "169.30.1.100/24"}]
      }
}'
NADEOF
done
