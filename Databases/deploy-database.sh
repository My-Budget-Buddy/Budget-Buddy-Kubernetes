#!/bin/bash

# Check if the required number of arguments are provided
if [ "$#" -ne 4 ]; then
    # e.g.
    # deploy-database.sh user-test user postgres postgres
    # service-name should be the same as defined in the yaml metadata
    # metadata:
    # name: user
    echo "Usage: $0 <namespace> <service-name> <postgres-username> <postgres-password>"
    exit 1
fi

NAMESPACE=$1
SERVICE_NAME=$2
POSTGRES_USERNAME=$3
POSTGRES_PASSWORD=$4

cd kubernetes

# replace placeholders (<service-name>) in yamls with the passed arguments
sed -i "s/<postgres-user>/$POSTGRES_USERNAME/" postgres-secret.yaml
sed -i "s/<postgres-password>/$POSTGRES_PASSWORD/" postgres-secret.yaml
sed -i "s/<service-name>/$SERVICE_NAME/" postgres-secret.yaml
sed -i "s/<service-name>/$SERVICE_NAME/" postgres-deployment.yaml
sed -i "s/<service-name>/$SERVICE_NAME/" postgres-service.yaml
sed -i "s/<service-name>/$SERVICE_NAME/" initdb-configmap.yaml

# apply kubectl commands using the arg namespace
kubectl delete -f initdb-configmap.yaml --namespace=$NAMESPACE
kubectl delete -f postgres-deployment.yaml --namespace=$NAMESPACE
kubectl delete -f postgres-service.yaml --namespace=$NAMESPACE
kubectl delete -f postgres-secret.yaml --namespace=$NAMESPACE

kubectl apply -f initdb-configmap.yaml --namespace=$NAMESPACE
kubectl apply -f postgres-secret.yaml --namespace=$NAMESPACE
kubectl apply -f postgres-service.yaml --namespace=$NAMESPACE
kubectl apply -f postgres-deployment.yaml --namespace=$NAMESPACE

kubectl describe pods --namespace=$NAMESPACE
