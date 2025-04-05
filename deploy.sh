#!/bin/bash

echo "Démarrage du script de déploiement..."

# 1. Déploiement de Redis
echo "Déploiement de Redis..."
cd redis
kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-replica-deployment.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-replica-service.yaml
cd ..

# 2. Déploiement du Backend Node.js
echo "Déploiement du Backend..."
cd backend
kubectl apply -f nodejs-deployment.yaml
kubectl apply -f nodejs-service.yaml
cd ..

# 3. Déploiement du Frontend React
echo "Déploiement du Frontend..."
cd frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
cd ..

# 4. Déploiement de Prometheus
echo "Déploiement de Prometheus..."
cd prometheus
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
cd ..

# 5. Déploiement de Node Exporter
echo "Déploiement de Node Exporter..."
cd prometheus
kubectl apply -f node-exporter.yaml
kubectl apply -f node-exporter-service.yaml
cd ..

# 6. Déploiement de Redis Exporter
echo "Déploiement de Redis Exporter..."
kubectl create namespace monitoring

cd prometheus
kubectl apply -f redis-exporter.yaml
kubectl apply -f redis-exporter-service.yaml
cd ..

# 7. Déploiement de Grafana
echo "Déploiement de Grafana..."
cd grafana
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
cd ..

echo "Déploiement terminé avec succès !"

# 8. Affichage des services disponibles
echo "✅ Services exposés (NodePort) :"
kubectl get services

echo "✅ Services monitoring :"
kubectl get pods -n monitoring

echo "Accede en premier au frontend en local :"
echo "Accede ../frontend et execute yarn start "

echo "✅ Puis tu peux accéder à :"
echo "➡ Frontend       : http://$(minikube ip):30000"
echo "➡ Backend (API)  : http://$(minikube ip):32180"
echo "➡ Prometheus     : http://$(minikube ip):32190"
echo "➡ Grafana        : http://$(minikube ip):32000"
