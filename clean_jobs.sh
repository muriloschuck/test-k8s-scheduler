#!/bin/bash

echo "[INFO] Cleaning job pods"
for pod in $(kubectl -n run-job get pods -o custom-columns=:metadata.name | grep ${1})
do
  kubectl -n run-job delete pod "$pod"
done