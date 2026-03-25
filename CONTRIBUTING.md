# Contributing to AuditorSEC LLM-Bridge

Thank you for your interest in contributing to AuditorSEC LLM-Bridge.
This document outlines how to contribute effectively.

## Code of Conduct

Be respectful, constructive, and collaborative. We follow the
[Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct.

## How to Contribute

### Reporting Bugs
1. Check [existing issues](../../issues) first.
2. Open a new issue using the **Bug Report** template.
3. Include: OS, Python version, stack trace, and steps to reproduce.

### Suggesting Features
1. Open an issue using the **Feature Request** template.
2. Describe the problem it solves and your proposed solution.

### Submitting Code

```bash
# 1. Fork the repo
git fork https://github.com/AuditorSEC-Initiative/auditorsec-llm-bridge

# 2. Create a feature branch
git checkout -b feat/your-feature-name

# 3. Make your changes, add tests
# 4. Lint
pip install ruff
ruff check . --fix

# 5. Test
pytest tests/ -v

# 6. Commit (conventional commits)
git commit -m 'feat: add your feature'

# 7. Push and open a PR
git push origin feat/your-feature-name
```

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `ci:` CI/CD changes
- `refactor:` Code refactor
- `test:` Tests only
- `chore:` Maintenance

## Development Setup

```bash
git clone https://github.com/AuditorSEC-Initiative/auditorsec-llm-bridge
cd auditorsec-llm-bridge
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
docker compose up -d  # Start supporting services
```

## Areas We Need Help With

- New Audityzer scan rules (Solidity, CosmWasm, Move)
- LLM prompt engineering for better remediation output
- PQC module benchmarks on new hardware
- Multi-chain support (Solana, TON, Cosmos)
- Documentation and tutorials
- GraphQL API extensions

## Security Vulnerabilities

Please DO NOT open public issues for security bugs.
See [SECURITY.md](SECURITY.md) for responsible disclosure.

## Questions?

- Telegram: [@audityzerbot](https://t.me/audityzerbot)
- Email: romanchaa997@auditorsec.com
- Notion: [AuditorSEC Hub](https://www.notion.so/auditorsec)
