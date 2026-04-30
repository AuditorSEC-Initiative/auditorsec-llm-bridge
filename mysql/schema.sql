-- AuditorSEC Diia.City Compliance Ledger
-- MySQL 8.0+ | UTF8MB4 | Bakhmach IoT Sentinel Pilot
-- Generated: 2026-04-30 | RehabFund / BRAVE1 / NIS2

CREATE DATABASE IF NOT EXISTS auditorsec_diia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE auditorsec_diia;

-- ─── 1. DONATIONS ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS donations (
  id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tx_hash             VARCHAR(66)  NOT NULL UNIQUE COMMENT 'Blockchain TX or UUID',
  amount              DECIMAL(18,8) NOT NULL,
  currency            VARCHAR(10)  NOT NULL DEFAULT 'UAH',
  donor               VARCHAR(42)  DEFAULT NULL COMMENT 'Wallet address or pseudonym',
  source              VARCHAR(50)  NOT NULL DEFAULT 'RehabFund',
  actor               VARCHAR(255) DEFAULT NULL,
  consent_scope       ENUM('grant','donation','audit') NOT NULL DEFAULT 'grant',
  retention_class     ENUM('P1','P2','P3') NOT NULL DEFAULT 'P1',
  pqc_signature_state ENUM('pending','ML-DSA-signed','ML-KEM-encrypted') NOT NULL DEFAULT 'pending',
  brave1_tag          VARCHAR(100) DEFAULT NULL COMMENT 'BRAVE1 program reference',
  diia_city_ref       VARCHAR(100) DEFAULT NULL COMMENT 'Diia.City evidence ID',
  created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_tx        (tx_hash),
  INDEX idx_created   (created_at),
  INDEX idx_source    (source)
) ENGINE=InnoDB COMMENT='Donation ledger — Diia.City/BRAVE1 grant evidence';

-- ─── 2. AUDIT TRAIL (DevOps commits + IoT events) ───────────
CREATE TABLE IF NOT EXISTS audits (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  commit_hash       VARCHAR(40)  DEFAULT NULL COMMENT 'GitHub SHA',
  event_type        ENUM('push','deploy','iot_alert','flag','manual') NOT NULL DEFAULT 'push',
  actor             VARCHAR(255) DEFAULT NULL,
  ethics_flag       TINYINT(1)   NOT NULL DEFAULT 0,
  compliance_status ENUM('pass','review','fail') NOT NULL DEFAULT 'pass',
  report_data       JSON         DEFAULT NULL COMMENT 'Raw event payload',
  pqc_state         ENUM('ML-DSA-signed','unsigned') NOT NULL DEFAULT 'unsigned',
  iot_node_id       VARCHAR(50)  DEFAULT NULL COMMENT 'ESP32/Sentinel node ID for Bakhmach pilot',
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_commit  (commit_hash),
  INDEX idx_event   (event_type),
  INDEX idx_flag    (ethics_flag)
) ENGINE=InnoDB COMMENT='Immutable DevOps + IoT audit trail — NIS2/DORA';

-- ─── 3. COMPLIANCE FLAGS ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS compliance_flags (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  flag_type     ENUM('ethics','financial','security','iot') NOT NULL,
  severity      ENUM('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  description   TEXT         DEFAULT NULL,
  related_tx    VARCHAR(66)  DEFAULT NULL,
  owner_email   VARCHAR(255) DEFAULT NULL,
  resolved      TINYINT(1)   NOT NULL DEFAULT 0,
  resolved_at   TIMESTAMP    NULL DEFAULT NULL,
  payload       JSON         DEFAULT NULL COMMENT 'ethics_flag.json payload',
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_severity (severity),
  INDEX idx_resolved (resolved)
) ENGINE=InnoDB COMMENT='Compliance flags — EthicsGovTech / Diia.City control';

-- ─── 4. WEEKLY TRANSPARENCY REPORTS ─────────────────────────
CREATE TABLE IF NOT EXISTS reports (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  report_type       ENUM('weekly','monthly','annual','brave1') NOT NULL DEFAULT 'weekly',
  period_start      DATE         NOT NULL,
  period_end        DATE         NOT NULL,
  total_donations   DECIMAL(18,8) NOT NULL DEFAULT 0,
  audit_count       INT UNSIGNED NOT NULL DEFAULT 0,
  flag_count        INT UNSIGNED NOT NULL DEFAULT 0,
  pdf_path          VARCHAR(500) DEFAULT NULL,
  csv_path          VARCHAR(500) DEFAULT NULL,
  submitted         TINYINT(1)  NOT NULL DEFAULT 0,
  submitted_at      TIMESTAMP   NULL DEFAULT NULL,
  diia_evidence     JSON        DEFAULT NULL COMMENT 'Structured evidence for Diia.City annual report',
  etherscan_hash    VARCHAR(66) DEFAULT NULL,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_period  (period_start, period_end),
  INDEX idx_type    (report_type)
) ENGINE=InnoDB COMMENT='Donor transparency reports — weekly_balance_report';

-- ─── 5. IOT SENTINEL METRICS (Bakhmach Pilot) ────────────────
CREATE TABLE IF NOT EXISTS iot_metrics (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  node_id     VARCHAR(50)  NOT NULL COMMENT 'ESP32 device ID',
  metric_type VARCHAR(50)  NOT NULL COMMENT 'e.g. vibration, temp, motion',
  value       DECIMAL(10,4) NOT NULL,
  unit        VARCHAR(20)  DEFAULT NULL,
  alert       TINYINT(1)  NOT NULL DEFAULT 0,
  pqc_signed  TINYINT(1)  NOT NULL DEFAULT 0,
  recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_node    (node_id),
  INDEX idx_alert   (alert),
  INDEX idx_ts      (recorded_at)
) ENGINE=InnoDB COMMENT='IoT Sentinel telemetry — Bakhmach municipal pilot';

-- ─── SAMPLE DATA (Bakhmach Pilot Mock) ───────────────────────
INSERT INTO donations (tx_hash, amount, currency, donor, source, consent_scope, retention_class, pqc_signature_state, brave1_tag, diia_city_ref)
VALUES
  ('0xabc001bakhmach2026sentinel00000000000000000000000000000001', 5000.00, 'UAH', '0xDonor1', 'RehabFund', 'grant', 'P1', 'ML-DSA-signed', 'BRAVE1-2026-UA', 'DIIA-EVD-001'),
  ('0xabc002bakhmach2026sentinel00000000000000000000000000000002', 12500.00, 'UAH', '0xDonor2', 'RehabFund', 'grant', 'P1', 'ML-DSA-signed', 'BRAVE1-2026-UA', 'DIIA-EVD-002'),
  ('0xabc003bakhmach2026sentinel00000000000000000000000000000003', 3200.00, 'USDT', '0xDonor3', 'Horizon-EU',  'grant', 'P2', 'pending',        NULL,             'DIIA-EVD-003');

INSERT INTO iot_metrics (node_id, metric_type, value, unit, alert, pqc_signed)
VALUES
  ('ESP32-BCH-001', 'vibration', 0.0023, 'g',   0, 1),
  ('ESP32-BCH-001', 'temp',      22.50,  'C',   0, 1),
  ('ESP32-BCH-002', 'motion',    1.0000, 'bool', 1, 0);
