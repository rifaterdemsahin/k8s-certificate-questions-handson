#!/usr/bin/env bash
# Lab 01 — Node draining demo on minikube.
# Cordons + drains one node and shows pods being rescheduled onto the other.
#
# Usage: ./run.sh
set -euo pipefail

PROFILE="${MINIKUBE_PROFILE:-k8s-cert-qa}"
NODES="${MINIKUBE_NODES:-2}"
# Pin a driver so minikube doesn't auto-pick virtualbox (unsupported on darwin/arm64).
# Override with DRIVER=... ; docker is the default on macOS (needs Docker Desktop running).
DRIVER="${DRIVER:-docker}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step() { printf '\n\033[1;36m▶ %s\033[0m\n' "$*"; }

step "1/7 Start a ${NODES}-node minikube cluster (profile: ${PROFILE}, driver: ${DRIVER})"
minikube start -p "$PROFILE" --nodes "$NODES" --driver "$DRIVER"

step "2/7 Apply the demo Deployment + PodDisruptionBudget"
kubectl apply -f "$HERE/deployment.yaml"
kubectl apply -f "$HERE/pdb.yaml"

step "3/7 Wait for the rollout"
kubectl rollout status deploy/draining-demo --timeout=120s

step "4/7 Where are the pods now?"
kubectl get pods -l app=draining-demo -o wide

# Choose the node currently hosting a demo pod (avoid draining an empty node).
NODE="$(kubectl get pods -l app=draining-demo -o jsonpath='{.items[0].spec.nodeName}')"
step "5/7 Draining node: ${NODE}  (cordon + evict)"
# --force is needed to evict pods with no controller (e.g. kube-system/storage-provisioner);
# --ignore-daemonsets skips DaemonSet pods; --delete-emptydir-data allows evicting pods using emptyDir.
kubectl drain "$NODE" --ignore-daemonsets --delete-emptydir-data --force --timeout=120s

step "6/7 Node is now SchedulingDisabled; pods rescheduled onto the other node"
kubectl get nodes
kubectl get pods -l app=draining-demo -o wide

step "7/7 Maintenance done — uncordon ${NODE}"
kubectl uncordon "$NODE"
kubectl get nodes

printf '\n\033[1;32m✓ Drain demo complete.\033[0m Cleanup with:\n'
printf '   kubectl delete -f %s -f %s\n' "$HERE/pdb.yaml" "$HERE/deployment.yaml"
printf '   minikube delete -p %s\n' "$PROFILE"
