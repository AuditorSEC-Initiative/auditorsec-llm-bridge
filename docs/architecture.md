# AuditorSEC LLM-Bridge: Architecture

## Overview

The LLM-Bridge orchestrator is a three-layer system:

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                          │
│  Telegram Bot  │  REST API (FastAPI)  │  Web Portal      │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                 ORCHESTRATION LAYER                      │
│  n8n Workflows  │  Celery/Temporal Workers  │  Scheduler │
│  OPA/Rego Policy Engine  │  LLM Context Manager         │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│               INFRASTRUCTURE LAYER                       │
│  K3s Cluster  │  NATS JetStream  │  PostgreSQL           │
│  Prometheus   │  Grafana         │  ArgoCD / Kyverno     │
└─────────────────────────────────────────────────────────┘
```

## Components

### 1. Audityzer Scanner
- Language: TypeScript + Python
- Rules engine: 15+ rules (reentrancy, unchecked calls, access control, integer overflow)
- Integrates: Slither, Mythril (optional)
- Output: Structured JSON findings with severity (CRITICAL/HIGH/MEDIUM/LOW)

### 2. LLM Reasoning Layer
- Model: OpenAI GPT-4o / Ollama (local) / custom fine-tuned
- Input: Audityzer JSON findings + protocol metadata
- Output: `meta.llmContext` with remediation, risk narrative, executive summary
- Queue: NATS JetStream stream `audits.llm.queue`

### 3. PQC Module
- Algorithms: ML-KEM-768 (FIPS 203), ML-DSA-65 (FIPS 204)
- Library: liboqs (Open Quantum Safe)
- Use cases: API channel encryption, report signing, webhook verification
- Benchmarks: Keygen 312ms, Encaps 287ms (ESP32-S3)

### 4. Policy Engine (OPA/Rego)
- Authorization for all API endpoints
- Audit rule weight configuration
- Rate limiting and tier enforcement (Free/Pro)
- Data: PostgreSQL-backed audit trail

### 5. Super Agents Layer
- Multi-agent orchestration for parallel audit pipelines
- Agents: ScanAgent, LLMAgent, PQCAgent, ReportAgent, NotifyAgent
- Coordination: NATS JetStream subjects + Temporal workflows

## Data Flow

```
User submits contract
    → POST /assess-risk
    → OPA authorization check
    → Audityzer scan (sync, <2s for basic)
    → Findings published to NATS: audits.findings.{chain}
    → LLM Worker consumes → generates meta.llmContext
    → PQC Module signs report
    → Report stored in PostgreSQL
    → Response returned to client + Telegram notification
```

## API Reference

### POST /assess-risk
```json
{
  "contract": "<solidity source or bytecode>",
  "chain": "ethereum|solana|cosmos",
  "options": {
    "deep_scan": false,
    "pqc_sign": true,
    "llm_context": true
  }
}
```

### Response
```json
{
  "risk_score": 8.4,
  "severity": "HIGH",
  "findings": [...],
  "meta": {
    "llmContext": {
      "executive_summary": "...",
      "remediation_priority": [...]
    },
    "pqc_signature": "..."
  }
}
```

## Kubernetes Namespaces

| Namespace | Services |
|-----------|----------|
| `auditorsec-core` | api, llm-worker, opa, summaries |
| `auditorsec-data` | postgresql, redis |
| `auditorsec-infra` | nats, prometheus, grafana |
| `fuel-analytics` | fuel-api, fuel-worker |

## Deployment

```bash
# Clone and deploy via ArgoCD
kubectl apply -f k8s/argocd-app.yaml

# Or local dev
docker compose up -d
```

## Related Docs

- [Quick Start](../README.md#quick-start)
- [PQC Benchmarks](pqc-benchmarks.md)
- [Grant Applications](grant-applications.md)
- [Case Studies](case-studies.md)
