# ☸️ k8s-certificate-questions-handson

> **Closing the gaps on Kubernetes questions that come up in interviews — one hands-on lab at a time.**

A hands-on study companion for Kubernetes certification (CKA/CKAD/CKS) and DevOps
interviews. Every interview question is paired with a **runnable lab** on
[minikube](https://minikube.sigs.k8s.io/) (local) and [Fly.io](https://fly.io/)
(deployed), so you don't just read the answer — you *prove* it.

The project is organised with the **Delivery Pilot 7-stage framework** (problem →
environment → simulation → formula → code → reflection → testing).

## 🎯 The Problem

Engineers can recite Kubernetes definitions but freeze on the practical follow-up:
*"OK — now actually do it."* This repo turns each gap into a lab you can run.

## 📚 Question Index

| # | Question | Lab | Status |
|---|----------|-----|--------|
| 1 | [How the node Draining process works](5_Symbols/01_node_draining/README.md) | minikube + Fly.io | ✅ Ready |

> More questions are added as `5_Symbols/NN_topic/`. Each has a README, manifests, and a run script.

## 🗺️ 7-Stage Framework

1. **[1_Real_Unknown](1_Real_Unknown)** — The interview gaps & questions to answer
2. **[2_Environment](2_Environment)** — minikube, Fly.io, Azure Key Vault setup
3. **[3_Simulation](3_Simulation)** — Diagrams of what each lab demonstrates
4. **[4_Formula](4_Formula)** — Reasoning & step-by-step plans before coding
5. **[5_Symbols](5_Symbols)** — The actual labs (manifests + scripts)
6. **[6_Semblance](6_Semblance)** — Errors hit, workarounds, lessons learned
7. **[7_Testing_Known](7_Testing_Known)** — Proof each lab works

## 🚀 Quick Start

```bash
# 1. Start a 2-node local cluster
minikube start -p k8s-cert-qa --nodes 2

# 2. Run the first lab — node draining
cd 5_Symbols/01_node_draining
./run.sh
```

See [`2_Environment/setup_azure.md`](2_Environment/setup_azure.md) for secrets
(handled via the **existing** Azure Key Vault `dp-kv-deliverypilot` — never create a new one).

## 🔒 Secrets

All secrets come from the existing Azure Key Vault — never committed to git:

- **Vault:** `dp-kv-deliverypilot` · **RG:** `deliverypilot-rg` · **Sub:** `b85b029d-9f7c-4c5a-8939-819480780c5d`
- [Portal link](https://portal.azure.com/#@infodeliverypilot.onmicrosoft.com/resource/subscriptions/b85b029d-9f7c-4c5a-8939-819480780c5d/resourceGroups/deliverypilot-rg/providers/Microsoft.KeyVault/vaults/dp-kv-deliverypilot/secrets)

## Links

- **GitHub Pages:** [https://rifaterdemsahin.github.io/k8s-certificate-questions-handson/](https://rifaterdemsahin.github.io/k8s-certificate-questions-handson/)
- **GitHub:** [k8s-certificate-questions-handson](https://github.com/rifaterdemsahin/k8s-certificate-questions-handson)
- **LinkedIn:** [rifaterdemsahin](https://www.linkedin.com/in/rifaterdemsahin/)
- **YouTube:** [@RifatErdemSahin](https://www.youtube.com/@RifatErdemSahin)
