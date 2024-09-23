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
# sed -i "s/<postgres-user>/$POSTGRES_USERNAME/" postgres-secret.yaml
# sed -i "s/<postgres-password>/$POSTGRES_PASSWORD/" postgres-secret.yaml

# apply initdb-configmap.yaml only if it doesn't exist
if ! kubectl get configmap initdb-configmap --namespace=$NAMESPACE >/dev/null 2>&1; then
    echo "Applying initdb-configmap.yaml..."
    kubectl apply -f initdb-configmap.yaml --namespace=$NAMESPACE
else
    echo "ConfigMap initdb-configmap already exists."
fi

# apply postgres-secret.yaml only if the secret doesn't exist
if ! kubectl get secret postgres-secret --namespace=$NAMESPACE >/dev/null 2>&1; then
    echo "Applying postgres-secret.yaml..."
    kubectl apply -f postgres-secret.yaml --namespace=$NAMESPACE
else
    echo "Secret postgres-secret already exists."
fi

# apply postgres-service.yaml only if the service doesn't exist
if ! kubectl get service postgres --namespace=$NAMESPACE >/dev/null 2>&1; then
    echo "Applying postgres-service.yaml..."
    kubectl apply -f postgres-service.yaml --namespace=$NAMESPACE
else
    echo "Service postgres-service already exists."
fi

# apply postgres-deployment.yaml only if the deployment doesn't exist
if ! kubectl get deployment postgres --namespace=$NAMESPACE >/dev/null 2>&1; then
    echo "Applying postgres-deployment.yaml..."
    kubectl apply -f postgres-deployment.yaml --namespace=$NAMESPACE
else
    echo "Deployment postgres-deployment already exists."
fi
