param(
    [Parameter(Mandatory=$true)]
    [string]$registryName
)

# Se connecter au registre Azure
az acr login --name $registryName

# Construire l'image
docker build -t "${registryName}.azurecr.io/laravel-app:latest" .

# Pousser l'image
docker push "${registryName}.azurecr.io/laravel-app:latest" 