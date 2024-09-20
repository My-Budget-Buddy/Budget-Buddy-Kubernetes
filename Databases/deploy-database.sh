#!/bin/bash

cd kubernetes
sed -i "s/<postgres-user>/$DATABASE_USERNAME/" postgres-secret.yaml
sed -i "s/<postgres-password>/$DATABASE_PASSWORD/" postgres-secret.yaml
kubectl delete -f initdb-configmap.yaml --namespace=$1
kubectl delete -f postgres-deployment.yaml --namespace=$1
kubectl delete -f postgres-service.yaml --namespace=$1
kubectl delete -f postgres-secret.yaml --namespace=$1
kubectl apply -f initdb-configmap.yaml --namespace=$1
kubectl apply -f postgres-secret.yaml --namespace=$1
kubectl apply -f postgres-service.yaml --namespace=$1
kubectl apply -f postgres-deployment.yaml --namespace=$1
kubectl describe pods --namespace=$1