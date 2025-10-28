#!/bin/bash

# Script para configurar uma nova aplicação usando este template
# Uso: ./setup-app.sh <app-name> <repo-url> <image-repo> <image-tag> <domain> <app-port>

set -e

if [ $# -lt 5 ] || [ $# -gt 6 ]; then
    echo "Uso: $0 <app-name> <repo-url> <image-repo> <image-tag> <domain> [app-port]"
    echo "Exemplo: $0 minha-app https://github.com/user/repo.git myregistry/myapp latest example.com 8080"
    echo "Nota: app-port é opcional e usa 8080 como padrão"
    exit 1
fi

APP_NAME=$1
REPO_URL=$2
IMAGE_REPO=$3
IMAGE_TAG=$4
DOMAIN=$5
APP_PORT=${6:-8080}

echo "Configurando aplicação: $APP_NAME"
echo "Repositório: $REPO_URL"
echo "Imagem: $IMAGE_REPO"
echo "Tag da imagem: $IMAGE_TAG"
echo "Domínio: $DOMAIN"
echo "Porta da aplicação: $APP_PORT"

# Escapar caracteres especiais para sed
ESCAPED_REPO_URL=$(echo "$REPO_URL" | sed 's/[[\.*^$()+?{|]/\\&/g')
ESCAPED_IMAGE_REPO=$(echo "$IMAGE_REPO" | sed 's/[[\.*^$()+?{|]/\\&/g')

# Substituir variáveis nos arquivos
echo "Substituindo variáveis nos arquivos..."

# IMPORTANTE: Substituir IMAGE_REPOSITORY_TAG antes de IMAGE_REPOSITORY para evitar conflitos
find . -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "s/IMAGE_REPOSITORY_TAG/$IMAGE_TAG/g" {} \;
find . -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "s/APP_NAME/$APP_NAME/g" {} \;
find . -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "s|REPO_URL|$ESCAPED_REPO_URL|g" {} \;
find . -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "s|IMAGE_REPOSITORY|$ESCAPED_IMAGE_REPO|g" {} \;
find . -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "s/DOMAIN/$DOMAIN/g" {} \;
find . -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "s/APP_PORT/$APP_PORT/g" {} \;

# Substituir variáveis no Dockerfile
if [ -f "Dockerfile" ]; then
    sed -i "s/APP_NAME/$APP_NAME/g" Dockerfile
    sed -i "s/APP_PORT/$APP_PORT/g" Dockerfile
fi

# Substituir variáveis no package.json
if [ -f "package.json" ]; then
    sed -i "s/APP_NAME/$APP_NAME/g" package.json
fi

# Substituir variáveis no index.js
if [ -f "index.js" ]; then
    sed -i "s/APP_NAME/$APP_NAME/g" index.js
    sed -i "s/APP_PORT/$APP_PORT/g" index.js
fi

echo "Configuração concluída!"
echo ""
echo "Próximos passos:"
echo "1. Revise e ajuste os valores em charts/app/values*.yaml"
echo "2. Personalize os templates em charts/app/templates/ conforme necessário"
echo "3. Commit as mudanças no seu repositório Git"
echo "4. Aplique as aplicações ArgoCD:"
echo "   kubectl apply -f argocd/application-stg.yaml"
echo "   kubectl apply -f argocd/application-prd.yaml"