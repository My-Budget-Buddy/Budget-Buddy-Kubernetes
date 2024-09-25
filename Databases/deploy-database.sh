#!/bin/bash

# Check if the required number of arguments are provided
if [ "$#" -ne 3 ]; then
    # e.g.
    # deploy-database.sh user-test postgres postgres
    echo "Usage: $0 <namespace> <postgres-username> <postgres-password>"
    exit 1
fi

NAMESPACE=$1
POSTGRES_USERNAME=$2
POSTGRES_PASSWORD=$3

# check if namespace exists, create if it doesn't
if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo "Namespace $NAMESPACE does not exist. Creating it..."
    kubectl create namespace "$NAMESPACE"
    echo "Namespace $NAMESPACE created."
else
    echo "Namespace $NAMESPACE already exists."
fi

# MUTATES FILES!
# replace placeholders (<postgres-user>, <postgres-password>) in yamls with the passed arguments
sed -i "s/<postgres-user>/$POSTGRES_USERNAME/" postgres-secret.yaml
sed -i "s/<postgres-password>/$POSTGRES_PASSWORD/" postgres-secret.yaml

# apply initdb-configmap.yaml only if it doesn't exist
kubectl delete -f initdb-configmap.yaml --namespace=$NAMESPACE || true
kubectl apply -f initdb-configmap.yaml --namespace=$NAMESPACE

kubectl delete -f postgres-secret.yaml --namespace=$NAMESPACE || true
kubectl apply -f postgres-secret.yaml --namespace=$NAMESPACE

kubectl delete -f postgres-service.yaml --namespace=${NAMESPACE} || true
kubectl apply -f postgres-service.yaml --namespace=$NAMESPACE

kubectl delete -f postgres-deployment.yaml --namespace=$NAMESPACE || true
kubectl apply -f postgres-deployment.yaml --namespace=$NAMESPACE
