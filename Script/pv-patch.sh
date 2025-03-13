#!/bin/bash

# RECLAIM POLICY가 'Retain'인 모든 PV 가져오기
pv_list=$(kubectl get pv --no-headers -o custom-columns=":metadata.name,:spec.persistentVolumeReclaimPolicy" | awk '$2=="Retain" {print $1}')

# PV 목록이 비어있다면 종료
if [[ -z "$pv_list" ]]; then
    echo "No PVs found with Retain policy."
    exit 0
fi

echo "Updating reclaim policy for the following PVs:"
echo "$pv_list"

# 각 PV의 Reclaim Policy를 Delete로 변경
for pv in $pv_list; do
    echo "Patching PV: $pv"
    kubectl patch pv "$pv" -p '{"spec":{"persistentVolumeReclaimPolicy":"Delete"}}'
done

echo "All applicable PVs have been updated to Delete."
