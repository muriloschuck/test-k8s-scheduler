#!/bin/bash

_jobs_file_path="/tmp/jobs.yaml"
_job_template_file_name="job-template.yaml"
_job_index=1

create_job() {
  _job_name="workload-$_job_index"
  _job_duration=$1
  _request_memory=$2
  _request_memory_in_mb="${_request_memory%Mi}M"
  _request_cpu=$3
  _request_storage=$4

  sed -e "s/JOB_NAME_PLACEHOLDER/$_job_name/g" \
      -e "s/TIMEOUT_PLACEHOLDER/$_job_duration/g" \
      -e "s/MEMORY_PLACEHOLDER/$_request_memory/g" \
      -e "s/MEMORY_STRESS_PLACEHOLDER/$_request_memory_in_mb/g" \
      -e "s/CPU_PLACEHOLDER/$_request_cpu/g" \
      -e "s/EPHEMERAL_STORAGE_PLACEHOLDER/$_request_storage/g" \
      $_job_template_file_name >> $_jobs_file_path
  
  ((_job_index+=1))
}

rm $_jobs_file_path
create_job "30s" "1000Mi" "1" "2Gi"
create_job "27s" "382Mi" "1" "3Gi"
create_job "13s" "900Mi" "1" "3Gi"
create_job "37s" "1300Mi" "1" "3Gi"
create_job "18s" "1200Mi" "1" "5Gi"
create_job "40s" "952Mi" "2" "6Gi"
create_job "8s" "600Mi" "1" "5Gi"
create_job "30s" "900Mi" "1" "2Gi"
create_job "20s" "1300Mi" "1" "6Gi"
create_job "25s" "700Mi" "2" "8Gi"
create_job "13s" "600Mi" "1" "3Gi"

echo "[INFO] The jobs yaml file is available at $_jobs_file_path"
echo "[INFO] Deploying resources in the cluster..."

kubectl -n run-job apply -f $_jobs_file_path
