# Template de Aplicação ArgoCD

Este template fornece uma estrutura base para deploy de aplicações no ArgoCD usando Helm charts, com separação de ambientes.

## Estrutura do Projeto

```
template-app/
├── .github/
│   └── workflows/
│       └── docker-build.yml      # Workflow para build e push de imagens Docker
├── charts/
│   └── app/                      # Helm chart da aplicação
│       ├── Chart.yaml
│       ├── values.yaml           # Valores padrão
│       ├── values-stg.yaml       # Valores específicos para staging
│       ├── values-prd.yaml       # Valores específicos para produção
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── ingress.yaml
│           └── hpa.yaml
├── argocd/
│   ├── application-stg.yaml      # Aplicação ArgoCD para staging
│   └── application-prd.yaml      # Aplicação ArgoCD para produção
├── Dockerfile                     # Dockerfile da aplicação
└── README.md
```

## Como usar este template

1. **Clone ou copie este template** para o repositório da sua aplicação
2. **Personalize os valores** nos arquivos `values*.yaml` conforme sua aplicação
3. **Ajuste o Dockerfile** conforme o stack da sua aplicação
4. **Configure os secrets do GitHub** para Docker Hub:
   - `DOCKERHUB_USERNAME`: Seu usuário do Docker Hub
   - `DOCKERHUB_TOKEN`: Token de acesso do Docker Hub
5. **Ajuste os manifestos** nos templates conforme necessário
6. **Configure as aplicações ArgoCD** editando os arquivos em `argocd/`
7. **Aplique no cluster** usando `kubectl apply -f argocd/`

## CI/CD com Docker

Este template inclui um workflow GitHub Actions que automaticamente:
- Builda a imagem Docker a cada commit nas branches `develop` e `main`
- Faz push da imagem para o Docker Hub
- Gera tags apropriadas baseadas no ambiente (stg/prd)

### Tags de Imagem Geradas

- `username/repo:latest` - Última versão
- `username/repo:SHA` - Versão específica do commit
- `username/repo:stg-latest` ou `username/repo:prd-latest` - Última versão por ambiente
- `username/repo:stg-SHA` ou `username/repo:prd-SHA` - Versão específica por ambiente

## Configuração de Ambientes

### Staging (STG)
- Branch: `develop`
- Namespace: `app-name-stg`
- Recursos reduzidos
- Configurações de desenvolvimento

### Produção (PRD)
- Branch: `main`
- Namespace: `app-name-prd` 
- Recursos otimizados
- Configurações de produção
- HPA habilitado

## Variáveis a serem substituídas

Ao usar este template, substitua as seguintes variáveis:

- `APP_NAME`: Nome da sua aplicação
- `REPO_URL`: URL do repositório Git da aplicação
- `IMAGE_REPOSITORY`: Repositório da imagem Docker
- `DOMAIN`: Domínio para o ingress
- `APP_PORT`: Porta da aplicação

## Exemplo de uso

```bash
# Substituir variáveis no template
sed -i 's/APP_NAME/minha-app/g' argocd/*.yaml charts/app/*.yaml
sed -i 's/REPO_URL/https:\/\/github.com\/user\/repo.git/g' argocd/*.yaml
```

## Criação Automática de Repositório Docker Hub

Quando uma nova aplicação é criada usando o script `new_app.py`, um repositório no Docker Hub é automaticamente criado com o mesmo nome do repositório GitHub. Para isso, configure as variáveis de ambiente:

- `DOCKERHUB_USERNAME`: Seu usuário do Docker Hub
- `DOCKERHUB_TOKEN`: Token de acesso do Docker Hub (gere em Account Settings > Security)