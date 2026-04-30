# Bakhmach Pilot Setup — AuditorSEC Diia.City Compliance

> **Pilot Region:** Bakhmach, Chernihiv Oblast, Ukraine
> **Programme:** Diia.City Digital Governance + EU4UA Anti-Corruption
> **Status:** Pilot Phase | **Started:** Q1 2026

## Overview

The Bakhmach pilot demonstrates AuditorSEC's end-to-end compliance stack for Ukrainian municipalities under Diia.City, integrating MySQL-backed audit trails, n8n orchestration, and Zapier Tables for grant/supplier monitoring aligned with NIS2/DORA and EU4UA BRAVE1 anti-corruption requirements.

---

## MySQL Schema — Sample Data

The following sample records are loaded into the pilot schema for demonstration and testing. See `mysql/schema.sql` for full DDL.

### Suppliers Sample
```sql
INSERT INTO suppliers (supplier_name, edrpou, sanctions_status, risk_score_affiliation, screening_status, country_of_registration) VALUES
('Bakhmach Digital Services', '12345678', 'clear', 25, 'approved', 'UA'),
('TechBud LLC', '87654321', 'flagged', 82, 'flagged', 'RU'),
('UA Defence Procurement Co', '11223344', 'under_review', 55, 'pending', 'UA');
```

### Contracts Sample
```sql
INSERT INTO contracts (contract_number, supplier_name, contract_value_uah, contract_date, compliance_status, iam_review_required) VALUES
('BAK-2026-001', 'Bakhmach Digital Services', 250000.00, '2026-01-15', 'compliant', FALSE),
('BAK-2026-002', 'TechBud LLC', 875000.00, '2026-02-20', 'non_compliant', TRUE),
('BAK-2026-003', 'UA Defence Procurement Co', 410000.00, '2026-03-01', 'under_review', TRUE);
```

### Price Benchmarks Sample
```sql
INSERT INTO price_benchmarks (item_description, supplier_name, market_price_uah, contract_price_uah, price_deviation_pct, review_status) VALUES
('Server Hardware (Dell R750)', 'Bakhmach Digital Services', 180000, 190000, 5.6, 'approved'),
('Network Switches (Cisco Catalyst)', 'TechBud LLC', 45000, 58500, 30.0, 'flagged'),
('Cybersecurity Software Licenses', 'UA Defence Procurement Co', 32000, 36800, 15.0, 'pending');
```

### Grants & Risk Dossiers Sample
```sql
INSERT INTO grants_risk_dossiers (recipient_organisation, grant_programme, amount_eur, gprc_status, iam_review_required, mfa_enforced, pqc_roadmap_submitted, crypto_inventory_done) VALUES
('Bakhmach City Council', 'EU4UA Digital Governance', 75000.00, 'in_review', TRUE, FALSE, FALSE, FALSE),
('UA Cyber Defence Lab', 'BRAVE1 Defence-Tech', 120000.00, 'approved', TRUE, TRUE, TRUE, FALSE),
('Diia.City Innovation Hub', 'EU4UA Anti-Corruption', 45000.00, 'pending', FALSE, FALSE, FALSE, FALSE);
```

---

## n8n Workflow Setup

### Prerequisites
- n8n v1.30+ (self-hosted or cloud)
- MySQL 8.0+ with `auditorsec_diia` database
- SMTP credentials for email reports

### Import Steps
1. In n8n, go to **Workflows** → **Import from file**
2. Select `n8n/diia_brave1_workflow.json`
3. Configure MySQL credential: `mysql_auditorsec`
   - Host: `localhost` (or your MySQL server)
   - Database: `auditorsec_diia`
   - User: `auditorsec_user`
   - Password: (set in environment)
4. Configure Email Send credential with SMTP settings
5. Activate workflow — runs every Monday at 08:00 UTC

### Workflow Nodes
| Node | Type | Purpose |
|---|---|---|
| Weekly Cron Trigger | Schedule | Monday 08:00 UTC |
| MySQL: High-Risk Suppliers | MySQL | Suppliers with risk >70 or sanctions_status='flagged' |
| MySQL: Price Deviations | MySQL | Price deviations >20% with pending review |
| MySQL: Pending Grant Dossiers | MySQL | Grants without approved GPRC status |
| Build BRAVE1 Report | Code | Aggregates all query results |
| Send Slack/Email Report | Email | HTML report to compliance@auditorsec.eu |

---

## Zapier Integration

Three Zapier Zaps are configured for real-time alerts (see Zapier Assets folder):

| Zap Name | Trigger | Action |
|---|---|---|
| EU4UA-BRAVE1 \| Supplier Risk Screening Alert | New record in Suppliers table | Filter: risk >70 or sanctions flagged → Email alert |
| EU4UA-BRAVE1 \| Price Deviation Flag (>20%) | New record in Price Benchmarks | Filter: deviation >20% → Email alert |
| EU4UA-BRAVE1 \| Grant Intake & NIS2 Dossier Alert | New record in Grants table | Email with NIS2/IAM/PQC checklist |

---

## NIS2/DORA Compliance Checklist (Bakhmach Pilot)

- [ ] IAM inventory completed for all pilot system users
- [ ] MFA enforced for municipality portal admin accounts
- [ ] Shared accounts eliminated from procurement system
- [ ] Crypto inventory: TLS certificates, signing keys catalogued
- [ ] PQC roadmap draft submitted (align with EU PQC Roadmap 2024)
- [ ] Quarterly access review scheduled
- [ ] n8n workflow tested with sample data
- [ ] Zapier Zaps activated and tested
- [ ] First weekly BRAVE1 report generated and reviewed

---

## Contact

- **Compliance Lead:** compliance@auditorsec.eu
- **Technical Lead:** tech@auditorsec.eu
- **Pilot Coordinator:** Bakhmach Digital Governance Office

*Last updated: 2026-04-29 | AuditorSEC Diia.City Team*
