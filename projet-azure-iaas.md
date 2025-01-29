📌 Étape 1 : Aller dans les GitHub Secrets
Va sur ton dépôt GitHub
Clique sur Settings (en haut à droite)
Dans le menu latéral, sélectionne Secrets and variables > Actions
Clique sur New repository secret pour ajouter chaque variable.


📌 Étape 2 : Ajouter les Secrets Terraform
Ajoute ces variables une par une dans GitHub Secrets :

Nom du Secret	Valeur à copier depuis terraform.tfvars
AZURE_CREDENTIALS xxxx
LAB_VIRTUAL_NETWORK_ID	/subscriptions/1eb5e572-df10-47a3-977e-b0ec272641e4/resourcegroups/t-clo-901-rns-0/providers/microsoft.devtestlab/labs/t-clo-901-rns-0/virtualnetworks/t-clo-901-rns-0
ALGORITHM_TYPE	xxxx
USERNAME_APP	xxxx
PASSWORD_APP	xxxx
ANSIBLE_LARAVEL_REPO	xxxx
DB_CONNECTION	xxxx
DB_HOST	xxxx
DB_PORT	xxxx
DB_DATABASE	xxxx
DB_USERNAME	xxxx
DB_PASSWORD	xxxx
DB_ROOT_PASSWORD	xxxx
APP_KEY	(laisse vide si tu veux que Laravel la génère lors du déploiement)


📌 Étape 3 : Lancer le deploiement 
 Initialize Terraform : terraform init
 Destroy Previous Infrastructure : terraform destroy -auto-approve
 Plan Deployment : terraform plan -out=tfplan
 Apply Deployment : terraform apply -auto-approve tfplan