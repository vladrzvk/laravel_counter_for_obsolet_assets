# TERRACLOUD - Infrastructure de Test Azure

## Description du Projet
Ce projet s'inscrit dans le cadre d'une mission d'infrastructure cloud visant à :
- Déployer une application dans un environnement de test Azure
- Étudier et comparer deux modèles de cloud computing (IaaS et PaaS)
- Analyser les performances des infrastructures en termes de coût et d'évolutivité
- Implémenter une approche Infrastructure as Code (IaC) pour garantir la reproductibilité
- Gérer efficacement les différents états des environnements
- Automatiser le processus de déploiement

Le projet utilise une application Laravel conteneurisée avec une stack de monitoring complète pour :
- Surveiller les performances en temps réel
- Collecter et analyser les métriques
- Gérer les alertes de manière centralisée
- Assurer une maintenance proactive
- Optimiser les ressources cloud

## Stack Technique

### Application
- **Framework** : Laravel (PHP)
- **Base de données** : MySQL 8.0
- **Reverse Proxy** : Traefik (latest)
- **Conteneurisation** : Docker & Docker Compose

### Stack de Monitoring
1. **Prometheus & Grafana**
   - Collecte et visualisation des métriques
   - Prometheus : Collecte de données
   - Grafana : Tableaux de bord et visualisation

2. **cAdvisor**
   - Surveillance des conteneurs Docker
   - Métriques de performance des conteneurs
   - Utilisation des ressources

3. **Node-Exporter**
   - Métriques système de l'hôte
   - Surveillance des ressources matérielles
   - Métriques du système d'exploitation

4. **AlertManager**
   - Gestion des alertes
   - Routage des notifications
   - Regroupement et inhibition des alertes

5. **Loki**
   - Agrégation centralisée des logs
   - Intégration avec Grafana
   - Requêtage des logs en temps réel

## URLs d'Accès

### Application
- Application Laravel : `http://laravel.localhost:8081`
- PHPMyAdmin : `http://pma.localhost:8081`
  - Identifiants : Voir fichier .env ou contacter l'administrateur
- Traefik Dashboard : `http://traefik.localhost:8081`

### Monitoring
- Grafana : `http://grafana.localhost:8081`
  - Identifiants : Voir fichier .env ou contacter l'administrateur
- Prometheus : `http://prometheus.localhost:8081`
- AlertManager : `http://alertmanager.localhost:8081`
- cAdvisor : `http://cadvisor.localhost:8081`
- Loki : `http://loki.localhost:8081`

## Structure du Projet
```
.
├── demo/                  # Application Laravel
├── monitoring/           # Configurations de monitoring
│   ├── prometheus/      # Configuration Prometheus
│   └── alertmanager/    # Configuration AlertManager
└── docker-compose.yml   # Configuration des services
```

## Configuration

### Base de Données
- Host : `db`
- Port : `3306` (interne), `33060` (externe)
- Identifiants : Voir fichier .env ou contacter l'administrateur

### Volumes Docker
- `mysql_data` : Données MySQL
- `prometheus_data` : Données Prometheus
- `grafana_data` : Données Grafana

## Installation et Démarrage

1. Cloner le repository :
```bash
git clone https://github.com/vladrzvk/laravel_counter_for_obsolet_assets.git
cd laravel_counter_for_obsolet_assets
```

2. Configurer les variables d'environnement :
```bash
cp .env.example .env
# Éditer le fichier .env avec les identifiants appropriés
```

3. Démarrer les services :
```bash
docker-compose up -d
```

4. Accéder à l'application via : `http://laravel.localhost`

## Monitoring

### Configuration de Prometheus
- Intervalle de scraping : 15s
- Cibles surveillées :
  - Application Laravel
  - Conteneurs Docker (via cAdvisor)
  - Métriques système (via Node-Exporter)
  - Prometheus lui-même

### Configuration d'AlertManager
- Groupement des alertes par : `alertname`
- Intervalle de groupement : 10s
- Intervalle de répétition : 1h

### Dashboards Grafana
- Métriques système
- Métriques des conteneurs
- Métriques de l'application
- Visualisation des logs (via Loki)

## Maintenance

### Logs
- Accès aux logs des conteneurs :
```bash
docker-compose logs [service]
```

### Sauvegarde
- Les données sont persistées via des volumes Docker
- Base de données : Volume `mysql_data`
- Métriques : Volume `prometheus_data`
- Dashboards Grafana : Volume `grafana_data`

## Sécurité
- Traefik en tant que reverse proxy
- Authentification sécurisée pour tous les services
- Isolation des réseaux Docker
- Variables d'environnement pour les données sensibles
