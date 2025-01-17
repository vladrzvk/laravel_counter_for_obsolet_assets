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
  - Identifiants par défaut :
    - Utilisateur : `admin`
    - Mot de passe : `admin`
  - Ces identifiants peuvent être modifiés dans le fichier `.env` :
    ```env
    GRAFANA_ADMIN_USER=votre_utilisateur
    GRAFANA_ADMIN_PASSWORD=votre_mot_de_passe
    ```
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

## Prérequis
- Docker Desktop installé et en cours d'exécution
- Git installé pour cloner le projet

Note : Vous n'avez pas besoin d'installer PHP, Composer ou MySQL sur votre machine locale. Tout est géré dans les conteneurs Docker.

### Ports requis disponibles :
- 8081 (Traefik)
- 8080 (Dashboard Traefik)
- 8000 (Application Laravel)
- 33060 (MySQL)

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

3. Créer les dossiers nécessaires pour le monitoring :
```bash
mkdir -p monitoring/prometheus monitoring/alertmanager
```

4. S'assurer que les fichiers de configuration sont présents :
- `monitoring/prometheus/prometheus.yml`
- `monitoring/alertmanager/alertmanager.yml`

5. Démarrer les services :
```bash
# Arrêter les conteneurs existants si nécessaire
docker-compose down

# Supprimer les volumes si vous voulez repartir de zéro
docker-compose down -v

# Démarrer tous les services
docker-compose up -d

# Vérifier les logs de l'application
docker-compose logs -f app
```

6. Vérifier que tous les services sont en cours d'exécution :
```bash
docker-compose ps
```

7. Accéder à l'application :
- Application Laravel : `http://laravel.localhost:8081`
- Les autres services sont accessibles aux URLs mentionnées dans la section "URLs d'Accès"

## Résolution des problèmes courants

### Erreur de dépendances PHP
Si vous voyez une erreur concernant `vendor/autoload.php`, les dépendances Composer ne sont pas installées. Solution :
```bash
# Redémarrer les conteneurs
docker-compose down && docker-compose up -d
```

### Erreur de connexion à la base de données
Vérifier que :
1. Le service MySQL est bien démarré
2. Les variables d'environnement dans le fichier `.env` sont correctes
3. Les migrations ont bien été exécutées

### Problèmes de ports
Si certains ports sont déjà utilisés, vous pouvez les modifier dans le `docker-compose.yml`

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

### Gestion des secrets
1. Le fichier `.env.example` fournit un modèle des variables nécessaires, mais ne contient PAS de vrais mots de passe
2. Lors de l'installation :
   ```bash
   # Copier le modèle
   cp .env.example .env
   
   # Éditer le fichier avec vos propres mots de passe sécurisés
   # IMPORTANT : Ne jamais commiter le fichier .env
   nano .env
   ```
3. Bonnes pratiques :
   - Utilisez des mots de passe forts et uniques pour chaque service
   - Ne partagez jamais le fichier `.env` contenant vos vrais mots de passe
   - Le fichier `.env` est déjà dans le `.gitignore` pour éviter les commits accidentels
   - Pour le partage en équipe, utilisez un gestionnaire de secrets sécurisé
