# ☁️ Azure Key Vault & Credentials Setup Guide

> **Stage 2: Environment** — Configuration and onboarding instructions for secrets management.

---

## 🔒 Azure Key Vault Setup

All environment variables and secrets are loaded dynamically from an **existing Azure Key Vault** at runtime.

> ⚠️ **Do NOT create a new Key Vault.** This project reuses the shared vault below.

| Setting | Value |
|---------|-------|
| **Vault name** | `dp-kv-deliverypilot` |
| **Resource group** | `deliverypilot-rg` |
| **Subscription ID** | `b85b029d-9f7c-4c5a-8939-819480780c5d` |
| **Tenant** | `infodeliverypilot.onmicrosoft.com` |
| **Portal** | [Open vault secrets](https://portal.azure.com/#@infodeliverypilot.onmicrosoft.com/resource/subscriptions/b85b029d-9f7c-4c5a-8939-819480780c5d/resourceGroups/deliverypilot-rg/providers/Microsoft.KeyVault/vaults/dp-kv-deliverypilot/secrets) |

### 1. Azure Authentication
```bash
# Log in to Azure account
az login

# Set the active subscription to the Delivery Pilot subscription
az account set --subscription "b85b029d-9f7c-4c5a-8939-819480780c5d"
```

### 2. Use the existing Key Vault (no provisioning)
```bash
# Confirm the vault is reachable
az keyvault show --name dp-kv-deliverypilot --query "name" -o tsv

# List existing secrets
az keyvault secret list --vault-name dp-kv-deliverypilot --query "[].name" -o tsv
```

### 3. Registering / Reading Secrets
```bash
# Add (or update) a secret in the vault
az keyvault secret set --vault-name dp-kv-deliverypilot \
  --name "K8S-CERT-QA-DEMO" --value "hello-from-handson"

# Read a secret back out
az keyvault secret show --vault-name dp-kv-deliverypilot \
  --name "K8S-CERT-QA-DEMO" --query "value" -o tsv
```

---

## 🔑 GitHub Actions Integration
To pull secrets into GitHub workflows, the repository needs Azure Service Principal credentials:

1. Create a Service Principal scoped to the existing resource group:
   ```bash
   az ad sp create-for-rbac --name "k8s-cert-qa-github-sp" --role contributor \
       --scopes /subscriptions/b85b029d-9f7c-4c5a-8939-819480780c5d/resourceGroups/deliverypilot-rg \
       --sdk-auth
   ```
2. Store the JSON output as a GitHub Repository Secret named `AZURE_CREDENTIALS`.
3. In workflows, use the action:
   ```yaml
   - name: Azure Login
     uses: azure/login@v1
     with:
       creds: ${{ secrets.AZURE_CREDENTIALS }}
   ```

---

## ☸️ Why secrets matter for the k8s hands-on

The minikube and Fly.io examples in [`5_Symbols/`](../5_Symbols/) never hardcode credentials.
Fly deploy tokens and any registry creds are pulled from the vault and injected as
environment variables (`fly secrets set ...`) — see [`fly_io.md`](./fly_io.md).

---

## 🧪 Verification Checklist
- [ ] Azure CLI successfully authenticated (`az account show`)
- [ ] Active subscription is `b85b029d-9f7c-4c5a-8939-819480780c5d`
- [ ] `dp-kv-deliverypilot` is reachable and secrets list returns
- [ ] A demo secret can be set and read back
- [ ] Zero secret configurations committed to source files
