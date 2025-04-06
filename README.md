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
sudo chmod +x /usr/local/bin/minikube
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
minikube start
```


### 2. Cloner et lancer deploy.sh

```bash
git clone https://github.com/sarah202411/Projet-CRV-AutoScaling-et-IaC.git
```



-------------------------installer yarn ----------------------------
```bash
cd Projet-CRV-AutoScaling-et-IaC/
cd frontend/

sudo apt update
sudo apt install ntpdate -y
sudo apt install cmdtest

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn 
yarn install
yarn start
```
-------------------------------------------------------------------------------------------------------

-------------------------Configuration automatique  ----------------------------
```bash

cd Projet-CRV-AutoScaling-et-IaC
kubectl create namespace monitoring
chmod +x deploy.sh
./deploy.sh
```

-------------------------Configuration Nginx  ----------------------------
```bash
cd frontend
echo "Copie du fichier default.conf dans le pod à l'emplacement de nginx..."
# Récupère dynamiquement le nom du pod frontend
POD_NAME=$(kubectl get pods -l app=frontend -o jsonpath="{.items[0].metadata.name}")
# Copie du fichier default.conf dans le pod à l'emplacement de nginx
kubectl cp default.conf "$POD_NAME":/etc/nginx/conf.d/default.conf
# Redémarre nginx pour appliquer la nouvelle configuration
kubectl exec "$POD_NAME" -- nginx -s reload
cd ..
```


Ce script déploie automatiquement :

Redis Master/Replicas

Le backend Node.js

Le frontend React

Prometheus et Grafana


-------------------------------------------------------------------------------------------------------


------------- Configuration manuelle--------------

Pour un déploiement manuelle passer directement a cette partie 
 

### 3. Déploiement de Redis


a. Appliquer les fichiers YAML
```bash
cd redis 
kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-replica-deployment.yaml
kubectl apply -f redis-master-service.yaml
kubectl apply -f redis-replica-service.yaml
```
b. Vérifier les ressources
```bash
kubectl get pods
kubectl get services
```
###3. Déploiement du Backend Node.js

a. Créer et pousser l'image Docker
```bash
cd backend
docker build -t mon-backend:latest .
docker tag mon-backend:latest <dockerhub_username>/mon-backend:latest
docker push <dockerhub_username>/mon-backend:latest
```
b. Appliquer les fichiers YAML
```bash
kubectl apply -f nodejs-deployment.yaml
kubectl apply -f nodejs-service.yaml
```
### 4. Déploiement du Frontend React

a. Créer et pousser l'image Docker
```bash
cd frontend
docker build -t mon-frontend:latest .
docker tag mon-frontend:latest <dockerhub_username>/mon-frontend:latest
docker push <dockerhub_username>/mon-frontend:latest
```
b. Appliquer les fichiers YAML
```bash
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```
c. Lancer l'application en local ( obligatoire pour que le reste marche )
```bash
yarn install
yarn start
```
-------------------------------------------------------
### 5. Configuration des URLs entre Frontend et Backend
```bash
# Copie du fichier default.conf dans le pod à l'emplacement de nginx
kubectl cp default.conf <POD_FRONTEND_NAME>:/etc/nginx/conf.d/default.conf

# Redémarre nginx pour appliquer la nouvelle configuration
kubectl exec <POD_FRONTEND_NAME> -- nginx -s reload
```

a. Fichier conf.js (Frontend)
```bash
export const URL = "http://<minikube_ip>:<NodePort du backend>";
```

b. Fichier main.js (Backend)
```bash
Redis URL : 127.0.0.1:6379
API exposée sur http://<minikube_ip>:<NodePort du backend>
```
### Modification du fichier default.conf (nginx)###
```bash
cd frontend/

```

### 6. Monitoring avec Prometheus & Grafana
a. Creer autre namespace
```bash
kubectl create namespace monitoring
```
b. Déploiement de Prometheus
```bash
cd Prometheus
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus.yaml
kubectl apply -f node-exporter.yaml
kubectl apply -f node-exporter-service.yaml
kubectl apply -f redis-exporter.yaml
kubectl apply -f redis-exporter-service.yaml

```
Accès :
```bash
http://$(minikube ip):<NodePort de Prometheus >
```
c. Déploiement de Grafana
```bash
cd Grafana
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
```
Accès :
```bash
http://$(minikube ip):<NodePort de Grafana>
```
c. Configuration de Grafana

Ajouter Prometheus comme source de données

Créer des dashboards personnalisés avec PromQL

---- Accès à l’application----

Frontend : http://<minikube_ip>:<NodePort du frontend>

Backend API : http://<minikube_ip>:<NodePort du backend>

Prometheus : http://<minikube_ip>:<NodePort de Prometheus>

Grafana : http://<minikube_ip>:<NodePort de Grafana>


---- Structure du projet----
```bash

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

```


-------Auteurs--------

$ Mouaci Sarah

$ Naer Farah
