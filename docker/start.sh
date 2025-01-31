#!/bin/bash

# Démarrage de PHP-FPM
php-fpm -D

# Démarrage de Nginx
nginx -g "daemon off;" 