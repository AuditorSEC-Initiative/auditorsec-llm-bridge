# AuditorSEC NIS2/DORA IAM & Post-Quantum Cryptography (PQC) Controls

> **Status:** GPRC — In Progress | **Deadline:** 18 April 2026 | **Priority:** HIGH

## Overview

AuditorSEC operates under NIS2 (EU 2022/2555) and DORA (EU 2022/2554) obligations as a cybersecurity audit platform serving essential entities in Ukraine (Diia.City) and EU defence-tech programmes (EU4UA, BRAVE1). This document defines IAM and PQC control checkpoints, risk assessment, and immediate action items.

---

## IAM Controls (NIS2 Art.21 / DORA Art.9)

### Requirements
| Control | Requirement | Status | Owner |
|---|---|---|---|
| Centralised IAM | Single identity directory (no shadow accounts) | In Progress | IAM Lead |
| Least Privilege | Role-based access, quarterly reviews | In Progress | IAM Lead |
| MFA Enforcement | MFA mandatory for all privileged + remote access | URGENT | Security |
| Adaptive MFA | Context-based step-up auth for high-risk actions | Planned | Security |
| Access Reviews | Quarterly certification of all accounts | Not Started | Compliance |
| Shared Account Ban | Eliminate all shared/generic accounts | URGENT | IAM Lead |
| Persistent Access Expiry | VPN/PAM sessions expire; no standing access | In Progress | IAM Lead |
| Session Recording | Privileged session logs for audit trail | Planned | SOC |

### Immediate Actions (Week 1-4)
1. **IAM Inventory Audit** — Enumerate all accounts across systems (cloud, on-prem, SaaS)
2. **MFA Enforce** — Enable MFA for all admin/privileged roles within 2 weeks
3. **Shared Account Elimination** — Identify and convert shared accounts to individual
4. **Access Review Launch** — Initiate quarterly access certification cycle
5. **PAM Deployment** — Deploy Privileged Access Management for high-risk roles

---

## Post-Quantum Cryptography (PQC) Controls (NIS2 Art.21 / EU PQC Roadmap 2024)

### Requirements
| Control | Requirement | Status | Owner |
|---|---|---|---|
| Crypto Inventory | Catalogue all cryptographic algorithms in use | URGENT | CTO |
| PQC Roadmap | Documented transition plan aligned to EU PQC Roadmap | URGENT | CTO |
| Algorithm Assessment | Identify RSA/ECC uses for replacement prioritisation | In Progress | CTO |
| PQC Pilot | Test CRYSTALS-Kyber (KEM) / CRYSTALS-Dilithium (signature) | Planned | CTO |
| TLS/PKI Upgrade | Plan TLS 1.3+ with PQC hybrid mode for external services | Planned | Infra |
| Log Archive Review | Review long-term archives (>5yr) for harvest-now attacks | In Progress | Security |
| EU Roadmap Sync | Align with ENISA/ECCC quarterly updates | Ongoing | CTO |

### Immediate Actions (Week 1-4)
1. **Crypto Inventory** — Audit all cryptographic uses: TLS, signing, storage encryption
2. **PQC Roadmap Document** — Draft transition plan per EU PQC Roadmap 2024
3. **High-Risk Log Review** — Identify >5yr log archives with sensitive data for PQC protection
4. **Algorithm Risk Scoring** — Score all RSA/ECC uses by sensitivity and exposure

---

## Risk Assessment

| Risk ID | Description | Likelihood | Impact | Level | Mitigation |
|---|---|---|---|---|---|
| R-IAM-01 | Shared accounts used for privileged access | High | High | **HIGH** | Immediate elimination + PAM |
| R-IAM-02 | No MFA on critical systems | High | High | **HIGH** | MFA enforce within 2 weeks |
| R-IAM-03 | No quarterly access reviews | Medium | High | **MEDIUM-HIGH** | Launch review cycle |
| R-PQC-01 | RSA/ECC in critical signing without transition plan | High | High | **HIGH** | Crypto inventory + roadmap |
| R-PQC-02 | Long-term archives vulnerable to harvest-now attacks | Medium | High | **MEDIUM-HIGH** | Review & PQC-protect archives |
| R-SOC-01 | SOC/MDR expansion adding shared accounts | Medium | High | **MEDIUM-HIGH** | Freeze expansions pending IAM design |

---

## GPRC Status Block (ClickUp)

```
GPRC Block — NIS2/DORA IAM & PQC
Status: IN PROGRESS
Owner: Compliance Lead
Deadline: 2026-04-18

Checkpoints:
[ ] IAM inventory complete
[ ] MFA enforced (all privileged roles)
[ ] Shared accounts eliminated
[ ] Crypto inventory complete
[ ] PQC roadmap submitted to ENISA
[ ] Quarterly access review cycle launched
[ ] PAM deployed for high-risk roles
[ ] PQC pilot (Kyber/Dilithium) tested

Freezes Active:
- SOC/MDR expansion (no new third-party integrations)
- Shared accounts (no new generic accounts)
- Persistent VPN/PAM access without expiry
- Long-term log archives >5yr without PQC review
```

---

## Zapier Tables Mapping

NIS2/DORA controls are operationalised in Zapier Tables:

| Table | Key Fields | Controls |
|---|---|---|
| EU4UA-BRAVE1 \| Suppliers | `sanctions_status`, `risk_score_affiliation` | IAM access control for supplier portal |
| EU4UA-BRAVE1 \| Contracts | `compliance_status`, `iam_review_required` | Contract IAM review gating |
| EU4UA-BRAVE1 \| Price Benchmarks | `price_deviation_pct`, `review_status` | Audit trail for procurement |
| EU4UA-BRAVE1 \| Grants & Risk Dossiers | `mfa_enforced`, `pqc_roadmap_submitted`, `crypto_inventory_done`, `gprc_status` | Direct NIS2/DORA grant compliance |

---

*Last updated: 2026-04-29 | AuditorSEC Compliance Team*
