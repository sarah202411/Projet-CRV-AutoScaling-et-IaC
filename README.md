# Projet Full-Stack Kubernetes - Redis, Node.js, React, Prometheus & Grafana

Ce projet est une application full-stack moderne déployée dans un cluster Kubernetes local avec Minikube. Il comprend :
- Un **frontend React**
- Un **backend Node.js**
- Une base de données **Redis** (Master/Replicas)
- Un système de **monitoring** avec Prometheus et Grafana

---
##  Prérequis

- Docker
- Minikube
- Kubectl
- Accès à Docker Hub (pour push des images)
---

##  Installation et Déploiement

### 1. Installer et Démarrer Minikube

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
minikube start





###2. Cloner et lancer deploy.sh
git clone https://github.com/sarah202411/Projet-CRV-AutoScaling-et-IaC.git
cd Projet-CRV-AutoScaling-et-IaC/
cd frontend/
yarn install
cd ..
kubectl create namespace monitoring
chmod +x deploy.sh
./deploy.sh




Ce script déploie automatiquement :

Redis Master/Replicas

Le backend Node.js

Le frontend React

Prometheus et Grafana







-------------------------installer yarn ----------------------------
cd frontend/

sudo apt update
sudo apt install ntpdate -y
sudo apt install cmdtest
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn 
yarn install
yarn start
-----------------------------------------------------------------------------






------------- Configuration manuelle--------------
Pour un déploiement manuelle passer directement a cette partie 
 
kubectl get nodes

###2. Déploiement de Redis

a. Appliquer les fichiers YAML

cd redis 
kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-replica-deployment.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-replica-service.yaml

b. Vérifier les ressources

kubectl get pods
kubectl get services

###3. Déploiement du Backend Node.js

a. Créer et pousser l'image Docker

cd backend
docker build -t mon-backend:latest .
docker tag mon-backend:latest <dockerhub_username>/mon-backend:latest
docker push <dockerhub_username>/mon-backend:latest

b. Appliquer les fichiers YAML

kubectl apply -f nodejs-deployment.yaml
kubectl apply -f nodejs-service.yaml

###4. Déploiement du Frontend React

a. Créer et pousser l'image Docker

cd frontend
docker build -t mon-frontend:latest .
docker tag mon-frontend:latest <dockerhub_username>/mon-frontend:latest
docker push <dockerhub_username>/mon-frontend:latest

b. Appliquer les fichiers YAML

kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

c. Lancer l'application en local ( obligatoire pour que le reste marche )

yarn install
yarn start

-------------------------------------------------------
###5. Configuration des URLs entre Frontend et Backend

a. Fichier conf.js (Frontend)

export const URL = "http://<minikube_ip>:<NodePort du backend>";


b. Fichier main.js (Backend)

Redis URL : 127.0.0.1:6379
API exposée sur http://<minikube_ip>:<NodePort du backend>

###6. Monitoring avec Prometheus & Grafana
a. Creer autre namespace

kubectl create namespace monitoring

b. Déploiement de Prometheus

cd Prometheus
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f node-exporter.yaml
kubectl apply -f node-exporter-service.yaml
kubectl apply -f redis-exporter.yaml
kubectl apply -f redis-exporter-service.yaml


Accès :

http://$(minikube ip):<NodePort de Prometheus >

c. Déploiement de Grafana

cd Grafana
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml

Accès :

http://$(minikube ip):<NodePort de Grafana>

c. Configuration de Grafana

Ajouter Prometheus comme source de données

Créer des dashboards personnalisés avec PromQL

---- Accès à l’application----

Frontend : http://<minikube_ip>:<NodePort du frontend>

Backend API : http://<minikube_ip>:<NodePort du backend>

Prometheus : http://<minikube_ip>:<NodePort de Prometheus>

Grafana : http://<minikube_ip>:<NodePort de Grafana>


---- Structure du projet----


projet-fullstack/
│
├── backend/
│   ├── Dockerfile
│   ├── main.js
│   ├── package.json
│   ├── redis-client.js
│   ├── backend-deployment.yaml
│   └── backend-service.yaml
│
├── frontend/
│   ├── Dockerfile
│   ├── src/
│   │   ├── App.js
│   │   ├── conf.js
│   │   └── ...
│   ├── package.json
│   ├── frontend-deployment.yaml
│   └── frontend-service.yaml
│
├── redis/
│   ├── redis-master-deployment.yaml
│   ├── redis-replica-deployment.yaml
│   ├── redis-master-service.yaml
│   └── redis-replica-service.yaml
│
├── prometheus/
│   ├── prometheus-configmap.yaml
│   ├── prometheus-deployment.yaml
│   ├── prometheus-service.yaml
│   ├── node-exporter.yaml
│   ├── node-exporter-service.yaml
│   ├── redis-exporter.yaml
│   └── redis-exporter-service.yaml
│
├── grafana/
│   ├── grafana-deployment.yaml
│   └── grafana-service.yaml
│
├── deploy.sh                # Script Bash d’automatisation du déploiement
└── README.md                # Documentation complète du projet




-------Auteurs--------

$ Mouaci Sarah
$ Naer Farah
