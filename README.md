# SmartHarvest Helm Charts — GitOps Repository

Production-grade Helm repository for the SmartHarvest agricultural platform, managed via **ArgoCD App-of-Apps** pattern.

---

## 📁 Repository Structure

```
SmartHarvest-HelmCharts/
│
├── argocd-apps/                    # ArgoCD Application manifests
│   ├── root-app.yaml               # App-of-Apps entry point
│   ├── dev/                         # Dev environment apps → namespace: dev
│   └── prod/                        # Prod environment apps → namespace: prod
│
├── microservices/                   # Helm charts for application services
│   ├── user-service/
│   ├── crop-advisory-service/
│   ├── marketplace-service/
│   └── frontend/
│
├── infrastructure/                  # Helm charts for platform dependencies
│   ├── gateway/                     # Gateway API (Envoy Gateway)
│   ├── postgres/                    # PostgreSQL database
│   └── redis/                       # Redis cache
│
├── values/                          # Centralized configuration (single source of truth)
│   ├── values.yaml                  # Global defaults + all service configs
│   ├── values-dev.yaml              # Dev environment overrides
│   └── values-prod.yaml             # Prod environment overrides
│
└── README.md
```

---

## 🏗️ Architecture

### GitOps Flow

```
CI builds image → pushes to registry
        ↓
CD template runs: yq -i ".services.<svc>.image.tag = \"<tag>\"" values/values-<env>.yaml
        ↓
Git commit + push to this repo
        ↓
ArgoCD detects change → syncs affected service automatically
```

### Environment Isolation

| Environment | Namespace | Values Files                             |
|-------------|-----------|------------------------------------------|
| Development | `dev`     | `values.yaml` + `values-dev.yaml`        |
| Production  | `prod`    | `values.yaml` + `values-prod.yaml`       |

Both environments run in the **same cluster**, isolated by namespace. Zero config overlap.

---

## 🔧 Centralized Values Design

All configuration lives in `values/`. **No per-chart values.yaml files exist.**

### Hierarchy

```yaml
global:          # Shared defaults (imagePullPolicy, resources, autoscaling, probes)
services:        # Per-service config (image, ports, replicas, health)
infrastructure:  # Platform dependencies (postgres, redis, gateway)
shared:          # Cross-service config (JWT, API keys)
```

### CI/CD Compatibility

The CI pipeline updates image tags using:

```bash
yq -i ".services.<service-name>.image.tag = \"<new-tag>\"" values/values-<env>.yaml
```

Service keys: `user-service`, `crop-advisory-service`, `marketplace-service`, `frontend-service`

---

## 🚀 Deployment

### Prerequisites

- Kubernetes cluster (kubeadm / EKS / GKE)
- ArgoCD installed
- Envoy Gateway installed

### Bootstrap ArgoCD

```bash
# Apply the root app — this deploys EVERYTHING
kubectl apply -f argocd-apps/root-app.yaml
```

ArgoCD will recursively discover all apps in `argocd-apps/dev/` and `argocd-apps/prod/`.

### Manual Helm (without ArgoCD)

```bash
# Deploy a single service to dev
helm install user-service ./microservices/user-service \
  -f values/values.yaml \
  -f values/values-dev.yaml \
  -n dev --create-namespace

# Deploy infrastructure
helm install postgres ./infrastructure/postgres \
  -f values/values.yaml \
  -f values/values-dev.yaml \
  -n dev
```

### Validate Templates

```bash
helm template user-service ./microservices/user-service \
  -f values/values.yaml \
  -f values/values-dev.yaml
```

---

## 📋 Services

| Service                  | Port | Description                              |
|--------------------------|------|------------------------------------------|
| `user-service`           | 8001 | User authentication and management       |
| `crop-advisory-service`  | 8002 | Crop advisory and weather intelligence   |
| `marketplace-service`    | 8003 | Agricultural marketplace                 |
| `frontend-service`       | 80   | Frontend application (Nginx)             |
| `postgres`               | 5432 | PostgreSQL database                      |
| `redis`                  | 6379 | Redis cache                              |
| `gateway`                | 80   | Envoy Gateway (Gateway API)              |

---

## 🛣️ API Routes (Gateway)

| Path               | Backend                |
|--------------------|------------------------|
| `/api/v1/users`    | `user-service:8001`    |
| `/api/v1/crops`    | `crop-advisory:8002`   |
| `/api/v1/market`   | `marketplace:8003`     |
| `/` (catch-all)    | `frontend:80`          |

---

## ➕ Adding a New Service

1. Create chart in `microservices/<service-name>/`
2. Add service config to `values/values.yaml` under `services.<service-name>`
3. Add env overrides to `values-dev.yaml` and `values-prod.yaml`
4. Create ArgoCD apps in `argocd-apps/dev/` and `argocd-apps/prod/`
5. Commit and push — ArgoCD auto-syncs
