# Test de l'Installation Laravel avec Monitoring

## 1. Infrastructure Docker

### Services principaux
- [x] Traefik (Port 8081:80, 8080:8080)
  - Dashboard: http://traefik.localhost:8081
  - Status: ✅ Running

- [x] Laravel (Port 8000)
  - URL: http://laravel.localhost:8081
  - Status: ❌ Exited (1)
  - Points à vérifier:
    - Configuration de la base de données
    - Clé d'application
    - Migrations

- [x] MySQL (Port 33060:3306)
  - Status: ✅ Running (Healthy)
  - Credentials:
    - Database: laravel
    - User: laravel_user
    - Password: laravel_password

- [x] PHPMyAdmin
  - URL: http://pma.localhost:8081
  - Status: ✅ Running

### Stack de Monitoring

#### Métriques
- [x] Prometheus
  - URL: http://prometheus.localhost:8081
  - Status: ✅ Running
  - Configuration: /monitoring/prometheus/prometheus.yml

- [x] Grafana
  - URL: http://grafana.localhost:8081
  - Status: ✅ Running
  - Credentials:
    - User: admin
    - Password: admin

- [x] cAdvisor
  - URL: http://cadvisor.localhost:8081
  - Status: ✅ Running (Healthy)

- [x] Node Exporter
  - Status: ✅ Running
  - Port: 9100

#### Logs
- [x] Loki
  - URL: http://loki.localhost:8081
  - Status: ❌ Exited (1)
  - Points à vérifier:
    - Configuration dans /monitoring/loki/local-config.yaml
    - Permissions des volumes

- [x] Promtail
  - Status: ✅ Running
  - Configuration: /monitoring/promtail/config.yml

#### Alertes
- [x] Alertmanager
  - URL: http://alertmanager.localhost:8081
  - Status: ✅ Running
  - Configuration: /monitoring/alertmanager/alertmanager.yml

## 2. Points à Corriger

### Laravel
1. Erreur de démarrage du conteneur Laravel :
   ```
   Unable to set application key. No APP_KEY variable was found in the .env file.
   SQLSTATE[42S02]: Base table or view not found: 1146 Table 'laravel.cache' doesn't exist
   ```

   Solutions :
   - [x] Vérifier la présence de APP_KEY dans le docker-compose.yml
   - [ ] Exécuter les migrations pour créer la table cache :
     ```bash
     php artisan cache:table
     php artisan migrate
     ```
   - [ ] Vérifier que le .env est correctement configuré

2. Vérifier les logs de l'application
3. Confirmer que toutes les migrations sont exécutées

### Loki
1. Simplifier la configuration de Loki
2. Vérifier les permissions des volumes
3. Tester la collecte des logs

## 3. Plan d'Action

1. Laravel
   ```bash
   # Dans le conteneur Laravel
   php artisan cache:table
   php artisan migrate
   php artisan config:cache
   php artisan route:cache
   php artisan view:cache
   ```

2. Base de données
   ```sql
   -- Vérifier les tables existantes
   SHOW TABLES;
   
   -- Vérifier les migrations
   SELECT * FROM migrations;
   ```

3. Configuration
   ```bash
   # Vérifier la configuration
   php artisan config:clear
   php artisan config:cache
   ```

## 4. Tests à Effectuer

### Base de données
```sql
-- Test de connexion à la base de données
mysql -h localhost -P 33060 -u laravel_user -p laravel
```

### Laravel
```bash
# Test des migrations
php artisan migrate:status

# Test de la clé d'application
php artisan key:status
```

### Monitoring
1. Vérifier les métriques dans Prometheus
2. Configurer un dashboard Grafana
3. Tester la collecte des logs dans Loki
4. Vérifier les alertes dans Alertmanager

## 5. URLs de Test

- Application: http://laravel.localhost:8081
- Traefik Dashboard: http://traefik.localhost:8081
- PHPMyAdmin: http://pma.localhost:8081
- Prometheus: http://prometheus.localhost:8081
- Grafana: http://grafana.localhost:8081
- Alertmanager: http://alertmanager.localhost:8081
- cAdvisor: http://cadvisor.localhost:8081
- Loki: http://loki.localhost:8081

## 6. Volumes Docker

### Volumes Nommés
- laravel_mysql_data
- laravel_prometheus_data
- laravel_grafana_data
- laravel_loki_data
- laravel_alertmanager_data
- laravel_promtail_data

### Points de Montage
- Tous les volumes sont correctement nommés
- Les permissions sont configurées en lecture seule quand nécessaire
- Les données persistantes sont stockées dans des volumes nommés

## 7. Réseau Docker

- Réseau: laravel_network
- Type: bridge
- Tous les services sont connectés au même réseau 