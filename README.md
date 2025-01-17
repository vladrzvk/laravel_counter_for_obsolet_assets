# Laravel Counter for Obsolete Assets

Application de gestion et de suivi des actifs obsolètes développée avec Laravel.

## Configuration requise

- Docker et Docker Compose
- Git

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

- **Laravel** : Application PHP (http://laravel.localhost:8081)
- **MySQL** : Base de données
- **phpMyAdmin** : Interface d'administration MySQL (http://pma.localhost:8081)
- **Traefik** : Reverse proxy et load balancer (http://traefik.localhost:8081)

### Stack de Monitoring

- **Prometheus** : Collecte de métriques (http://prometheus.localhost:8081)
- **Grafana** : Visualisation des métriques et logs (http://grafana.localhost:8081)
- **Loki** : Agrégation de logs
- **Promtail** : Collecteur de logs
- **cAdvisor** : Métriques des conteneurs (http://cadvisor.localhost:8081)
- **Node Exporter** : Métriques système
- **AlertManager** : Gestion des alertes (http://alertmanager.localhost:8081)

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

Tous les services sont accessibles via Traefik sur le port 8081 :

- Application : http://laravel.localhost:8081
- Grafana : http://grafana.localhost:8081
- phpMyAdmin : http://pma.localhost:8081
- Traefik Dashboard : http://traefik.localhost:8081
- Prometheus : http://prometheus.localhost:8081
- AlertManager : http://alertmanager.localhost:8081
- cAdvisor : http://cadvisor.localhost:8081

## Contribution

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request



## ajouter les differents forwarding dans le fichier hosts 

sous windows C:\Windows\System32\drivers\etc\

127.0.0.1  laravel.localhost
127.0.0.1  traefik.localhost
127.0.0.1  pma.localhost
127.0.0.1  grafana.localhost
...