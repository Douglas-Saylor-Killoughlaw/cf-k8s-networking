#!/usr/bin/env bash

set -euo pipefail

# ENV
: "${CF_DOMAIN:?}"
: "${CLUSTER_NAME:?}"
: "${CLOUDSDK_COMPUTE_REGION:?}"
: "${CLOUDSDK_COMPUTE_ZONE:?}"
: "${GCP_SERVICE_ACCOUNT_KEY:?}"
: "${GCP_PROJECT:?}"
: "${SHARED_DNS_ZONE_NAME:?}"


function destroy_cluster() {
    gcloud auth activate-service-account --key-file=<(echo "${GCP_SERVICE_ACCOUNT_KEY}") --project="${GCP_PROJECT}" 1>/dev/null 2>&1

    if gcloud container clusters describe ${CLUSTER_NAME} > /dev/null; then
        echo "Destroying ${CLUSTER_NAME}..."
        gcloud container clusters delete ${CLUSTER_NAME}
    fi
}

function delete_dns() {
  echo "Deleting DNS for: *.${CF_DOMAIN}"
  gcloud dns record-sets transaction start --zone="${SHARED_DNS_ZONE_NAME}"
  gcp_records_json="$( gcloud dns record-sets list --zone "${SHARED_DNS_ZONE_NAME}" --name "*.${CF_DOMAIN}" --format=json )"
  record_count="$( echo "${gcp_records_json}" | jq 'length' )"
  if [ "${record_count}" != "0" ]; then
    existing_record_ip="$( echo "${gcp_records_json}" | jq -r '.[0].rrdatas | join(" ")' )"
    gcloud dns record-sets transaction remove --name "*.${CF_DOMAIN}" --type=A --zone="${SHARED_DNS_ZONE_NAME}" --ttl=300 "${existing_record_ip}" --verbosity=debug
  fi

  echo "Contents of transaction.yaml:"
  cat transaction.yaml
  gcloud dns record-sets transaction execute --zone="${SHARED_DNS_ZONE_NAME}" --verbosity=debug
}

function main() {
    delete_dns
    destroy_cluster
}

main
