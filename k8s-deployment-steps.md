# AgriSmart Kubernetes Deployment Guide

This guide outlines the steps to deploy the AgriSmart microservices platform on a self-managed Kubernetes cluster on AWS EC2.

## Prerequisites

* Self-managed Kubernetes cluster (kubeadm or Minikube) running on EC2.
* `kubectl` and `helm` installed and configured.
* HAProxy installed on the EC2 host.

## Step 1: Install Envoy Gateway

Envoy Gateway is used as the Gateway API implementation.

```bash
# Add Envoy Gateway Helm repository
helm repo add envoy-gateway https://helm.envoyproxy.io
helm repo update

# Install Envoy Gateway
helm install eg envoy-gateway/envoy-gateway \
  -n envoy-gateway-system \
  --create-namespace
```

Wait for the Envoy Gateway pods to be ready:
```bash
kubectl get pods -n envoy-gateway-system
```

## Step 2: Deploy AgriSmart Helm Chart

Deploy the entire microservices stack using the umbrella chart.

```bash
# Navigate to the platform directory
cd smartcrop-platform

# Install the chart
helm install agrismart ./helm
```

## Step 3: Verify Resources

Check the status of the deployments and gateway resources.

```bash
# Check pods
kubectl get pods

# Check Gateway API resources
kubectl get gateway
kubectl get httproute
```

## Step 4: Configure HAProxy on EC2 Host

Get the IP address of the Envoy Gateway service. Since we are on a self-managed cluster without a LoadBalancer, you might need to check the Service type created by Envoy Gateway. By default, it might be `LoadBalancer`. You can change it to `NodePort` or `ClusterIP` if HAProxy is configured to route to it.

```bash
# Get Envoy Service IP (Look for the service created in the namespace where the Gateway is deployed)
kubectl get svc -n envoy-gateway-system
```

Update your `/etc/haproxy/haproxy.cfg` on the EC2 host with the service IP:

```haproxy
backend envoy_backend
    server envoy <ENVOY_SERVICE_IP>:80 check
```

Restart HAProxy:
```bash
sudo systemctl restart haproxy
```

## Step 5: Access the Application

The application should now be accessible via the Public IP of your EC2 instance on port 80.

* `/` -> Frontend
* `/api/v1/users` -> User Service
* `/api/v1/crops` -> Crop Advisory Service
* `/api/v1/market` -> Marketplace Service
