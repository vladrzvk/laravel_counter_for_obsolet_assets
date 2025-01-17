# Laravel Counter for Obsolete Assets

Application de gestion et de suivi des actifs obsolètes développée avec Laravel.

## Configuration requise

- Docker et Docker Compose
- Git

## Description des Services

### Services Principaux

- **Laravel (app)** : 
  - Framework PHP pour le développement de l'application web
  - Gère la logique métier et les interfaces utilisateur
  - Expose l'application sur http://laravel.localhost

- **MySQL (db)** : 
  - Système de gestion de base de données relationnelle
  - Stocke toutes les données de l'application
  - Optimisé pour les performances avec des volumes persistants

- **phpMyAdmin** : 
  - Interface web d'administration pour MySQL
  - Permet de gérer la base de données visuellement
  - Accessible sur http://pma.localhost

- **Traefik** : 
  - Reverse proxy moderne et load balancer
  - Gère le routage des requêtes vers les différents services
  - Fournit des URLs propres pour chaque service
  - Dashboard disponible sur http://traefik.localhost

### Stack de Monitoring

- **Prometheus** : 
  - Système de collecte et stockage de métriques
  - Récupère les données de performance de tous les services
  - Permet la définition de règles d'alertes
  - Interface disponible sur http://prometheus.localhost

- **Grafana** : 
  - Plateforme de visualisation et d'analyse
  - Crée des dashboards interactifs
  - Affiche les métriques de Prometheus et les logs de Loki
  - Interface sur http://grafana.localhost (login: admin/admin)

- **Loki** : 
  - Système d'agrégation de logs inspiré de Prometheus
  - Stocke et indexe les logs de tous les conteneurs
  - Permet des requêtes et des recherches efficaces
  - API accessible sur http://loki.localhost

- **Promtail** : 
  - Agent de collecte de logs pour Loki
  - Récupère les logs des conteneurs Docker
  - Ajoute des labels et des métadonnées aux logs
  - Interface de statut sur http://promtail.localhost

- **cAdvisor** : 
  - Analyse les performances des conteneurs
  - Fournit des métriques sur l'utilisation des ressources
  - Historique d'utilisation CPU, mémoire, réseau
  - Interface sur http://cadvisor.localhost

- **Node Exporter** : 
  - Exporte les métriques du système hôte
  - Collecte les données CPU, mémoire, disque, réseau
  - Fournit des métriques au format Prometheus

- **AlertManager** : 
  - Gère les notifications et les alertes
  - Regroupe et route les alertes
  - Gère les silences et les inhibitions
  - Interface sur http://alertmanager.localhost

## Installation

1. Clonez le dépôt :
```bash
git clone https://github.com/vladrzvk/laravel_counter_for_obsolet_assets.git
cd laravel_counter_for_obsolet_assets
```

2. Configurez l'environnement :
```bash
cp .env.example .env
```
Modifiez le fichier `.env` avec vos paramètres (mots de passe, etc.)

3. Démarrez les services :
```bash
docker-compose up -d
```

## Architecture

Le projet utilise une architecture moderne basée sur Docker avec les services suivants :

- **Laravel** : Application PHP (http://laravel.localhost)
- **MySQL** : Base de données
- **phpMyAdmin** : Interface d'administration MySQL (http://pma.localhost)
- **Traefik** : Reverse proxy et load balancer (http://traefik.localhost)

### Stack de Monitoring

- **Prometheus** : Collecte de métriques (http://prometheus.localhost)
- **Grafana** : Visualisation des métriques et logs (http://grafana.localhost)
- **Loki** : Agrégation de logs (http://loki.localhost)
- **Promtail** : Collecteur de logs (http://promtail.localhost)
- **cAdvisor** : Métriques des conteneurs (http://cadvisor.localhost)
- **Node Exporter** : Métriques système
- **AlertManager** : Gestion des alertes (http://alertmanager.localhost)

## Dashboards Grafana

Trois dashboards sont préconfigurés :

1. **Logs** : 
   - Visualisation des logs de tous les conteneurs
   - Filtrage par conteneur
   - Recherche en temps réel

2. **System Resources** :
   - Utilisation CPU
   - Utilisation mémoire
   - Métriques système

3. **Docker Containers** :
   - Utilisation CPU par conteneur
   - Utilisation mémoire par conteneur
   - Performance des conteneurs

## Système d'Alertes

Le projet inclut un système d'alertes complet basé sur Prometheus et AlertManager.

### Alertes configurées

1. **Ressources Système** :
   - CPU > 80% pendant 5 minutes
   - Mémoire > 80% pendant 5 minutes

2. **Conteneurs** :
   - CPU conteneur > 80% pendant 5 minutes
   - Mémoire conteneur > 80% pendant 5 minutes

### Configuration des alertes

- Groupement par nom d'alerte
- Délai d'attente : 10 secondes
- Intervalle de répétition : 1 heure
- Inhibition des alertes redondantes

## Gestion des secrets

1. Le fichier `.env.example` sert de modèle et ne contient pas de mots de passe réels
2. Pour l'installation :
   - Copiez `.env.example` vers `.env`
   - Modifiez les mots de passe dans `.env`
   - Ne committez JAMAIS le fichier `.env`
3. Bonnes pratiques :
   - Utilisez des mots de passe forts et uniques
   - Ne partagez pas le fichier `.env`
   - Utilisez un gestionnaire de secrets sécurisé pour le partage en équipe

## Accès aux services

Tous les services sont accessibles via Traefik :

- Application : http://laravel.localhost
- Grafana : http://grafana.localhost (login: admin/admin)
- phpMyAdmin : http://pma.localhost
- Traefik Dashboard : http://traefik.localhost
- Prometheus : http://prometheus.localhost
- AlertManager : http://alertmanager.localhost
- cAdvisor : http://cadvisor.localhost
- Loki : http://loki.localhost
- Promtail : http://promtail.localhost

## Configuration du fichier hosts

Ajoutez les entrées suivantes dans votre fichier hosts :
- Windows : `C:\Windows\System32\drivers\etc\hosts`
- Linux/Mac : `/etc/hosts`

```
127.0.0.1  laravel.localhost
127.0.0.1  traefik.localhost
127.0.0.1  pma.localhost
127.0.0.1  grafana.localhost
127.0.0.1  prometheus.localhost
127.0.0.1  alertmanager.localhost
127.0.0.1  cadvisor.localhost
127.0.0.1  loki.localhost
127.0.0.1  promtail.localhost
```

## Contribution

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request