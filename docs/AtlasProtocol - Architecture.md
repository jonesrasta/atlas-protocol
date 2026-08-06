# Atlas Protocol — Architecture Documentation

> **Version:** 1.0.0
> **Status:** Treasury Foundation (Sprint 3.4)
> **Language:** Solidity 0.8.30
> **Development Framework:** Foundry

---

# Table of Contents

1. Overview
2. Design Philosophy
3. Repository Structure
4. System Architecture
5. Access Control
6. Common Layer
7. Atlas Token
8. Treasury Foundation
9. Security Architecture
10. Development Standards
11. Testing Strategy
12. Continuous Integration
13. Security Tooling
14. Audit Readiness
15. Roadmap
16. Future Modules
17. Contributing
18. Current Status

---

# 1. Overview

Atlas Protocol is a modular DeFi protocol built with Solidity following modern smart contract engineering practices.

The architecture prioritizes:

* Security
* Auditability
* Maintainability
* Scalability
* Separation of Responsibilities
* Reusability

Every protocol module is developed independently while sharing a common security and access-control layer.

---

# 2. Design Philosophy

Atlas Protocol is designed around one fundamental principle:

> **Small, independent, auditable modules.**

Instead of concentrating all business logic into a single contract, each protocol component owns a single responsibility.

Benefits:

* easier audits
* lower attack surface
* simpler testing
* isolated upgrades
* reusable components

The protocol follows a **security-first architecture** where every new module must inherit the same development standards.

---

# 3. Repository Structure

```text
atlas-protocol/

packages/
└── contracts/
    ├── src/
    ├── test/
    ├── script/
    ├── security/
    ├── foundry.toml
    ├── remappings.txt
    └── README.md
```

Current source tree:

```text
src/

├── access/
│   ├── AccessManager.sol
│   ├── IAccessManager.sol
│   ├── Roles.sol
│   └── AccessEvents.sol
│
├── common/
│   ├── AccessControlled.sol
│   ├── CommonErrors.sol
│   ├── Validation.sol
│   ├── Constants.sol
│   ├── Types.sol
│   ├── Math.sol
│   └── Version.sol
│
├── token/
│   ├── AtlasToken.sol
│   ├── AtlasTokenBase.sol
│   ├── AtlasTokenStorage.sol
│   ├── IAtlasToken.sol
│   └── TokenEvents.sol
│
└── treasury/
    ├── Treasury.sol
    ├── ITreasury.sol
    ├── TreasuryStorage.sol
    ├── TreasuryEvents.sol
    └── TreasuryErrors.sol
```

---

# 4. System Architecture

```text
                         Atlas Protocol

                    ┌────────────────────┐
                    │  AccessManager     │
                    └─────────┬──────────┘
                              │
                    AccessControlled Layer
                              │
      ┌─────────────┬──────────┴────────────┬─────────────┐
      │             │                       │             │
 AtlasToken     Treasury               Staking      Governance
      │             │                       │             │
      └─────────────┴───────────────────────┴─────────────┘
               Shared Common Libraries
```

Every protocol module inherits the same authorization model.

---

# 5. Access Control

Atlas Protocol does **not** use Ownable.

Instead, authorization is centralized through **AccessManager**.

```text
Admin

↓

AccessManager

↓

AccessControlled Modules
```

Every module inherits:

```solidity
AccessControlled
```

Authorization never depends on contract ownership.

---

## Role Hierarchy

```text
DEFAULT_ADMIN_ROLE

        │

PROTOCOL_ADMIN_ROLE

        │

──────────────────────────────

TREASURY_MANAGER_ROLE

MINTER_ROLE

BURNER_ROLE

PAUSER_ROLE

POOL_MANAGER_ROLE

VAULT_MANAGER_ROLE

ORACLE_MANAGER_ROLE
```

Each module only consumes the roles it requires.

---

# 6. Common Layer

Shared protocol libraries.

## AccessControlled

Provides centralized authorization.

## Validation

Input validation helpers.

Examples:

* zero address
* invalid amount
* expired deadline

---

## CommonErrors

Shared custom errors.

Benefits:

* lower gas consumption
* standardized error handling
* easier debugging

---

## Math

Protocol math helpers.

Future modules should reuse this library instead of implementing duplicate arithmetic.

---

## Version

Central protocol version identifier.

---

# 7. Atlas Token

AtlasToken is the governance token of Atlas Protocol.

Inheritance:

```text
AtlasToken

↓

AtlasTokenBase

↓

ERC20

ERC20Permit

ERC20Votes

↓

AccessControlled
```

Current features:

* ERC20
* Permit (EIP-2612)
* Voting power
* Mint
* Burn
* Role-based permissions

Roles:

* MINTER_ROLE
* BURNER_ROLE

Minting and burning are fully controlled through AccessManager.

---

# 8. Treasury Foundation

The Treasury is the financial foundation of the protocol.

Responsibilities:

* custody protocol ETH
* receive deposits
* execute withdrawals
* emit accounting events
* prepare future DeFi integrations

Architecture:

```text
Treasury

↓

ITreasury

↓

TreasuryStorage

↓

TreasuryEvents

↓

TreasuryErrors

↓

AccessControlled
```

---

## Deposit Flow

```text
User

↓

deposit()

↓

Treasury

↓

Deposit Event
```

Anyone may deposit.

---

## Withdrawal Flow

```text
Treasury Manager

↓

withdraw()

↓

Permission Check

↓

Transfer ETH

↓

Withdrawal Event
```

Only:

```text
TREASURY_MANAGER_ROLE
```

may withdraw assets.

---

# 9. Security Architecture

Atlas Protocol follows a layered security model.

```text
Layer 1

AccessManager

↓

Layer 2

Validation Library

↓

Layer 3

Custom Errors

↓

Layer 4

Static Analysis

↓

Layer 5

Unit Tests

↓

Layer 6

Coverage

↓

Layer 7

Audit Preparation
```

---

## Address Validation

Every external address must validate:

```solidity
address != address(0)
```

---

## Amount Validation

Every financial operation validates:

```solidity
amount > 0
```

---

## Safe ETH Transfer

Transfers use:

```solidity
(bool success,) = receiver.call{value: amount}("");

if (!success) {
    revert TransferFailed();
}
```

---

# 10. Development Standards

Every module follows exactly the same architecture.

```text
IModule.sol

↓

ModuleStorage.sol

↓

ModuleEvents.sol

↓

ModuleErrors.sol

↓

Module.sol
```

Rules:

* no Ownable
* no require strings
* use custom errors
* separated storage
* centralized authorization
* isolated interfaces
* complete unit tests

---

# 11. Testing Strategy

```
test/

└── unit/

    ├── access/
    ├── token/
    └── treasury/
```

Each module must include:

Constructor

* deployment
* initialization

Access

* authorized
* unauthorized

Events

* emitted correctly

Validation

* invalid inputs
* edge cases

State

* storage updates
* invariants

---

# 12. Continuous Integration

Every Pull Request must pass:

```text
Developer

↓

forge fmt --check

↓

forge build

↓

forge test

↓

forge coverage

↓

solhint

↓

slither

↓

aderyn

↓

GitHub Actions

↓

Merge
```

No code is merged unless every security stage succeeds.

---

# 13. Security Tooling

| Tool           | Purpose                  |
| -------------- | ------------------------ |
| Foundry        | Build & Testing          |
| Forge Coverage | Code Coverage            |
| Solhint        | Solidity Style Guide     |
| Slither        | Static Security Analysis |
| Aderyn         | Security Detector        |
| GitHub Actions | Continuous Integration   |

Security reports are automatically generated before merging.

---

# 14. Audit Readiness

Current checklist:

```text
✓ Modular Architecture

✓ Centralized Access Control

✓ Custom Errors

✓ Validation Library

✓ Separated Storage

✓ Static Analysis

✓ Unit Tests

✓ GitHub Actions

✓ Slither

✓ Aderyn

✓ Solhint

────────────────────────────

□ Integration Tests

□ Fuzz Tests

□ Invariant Tests

□ Formal Verification

□ External Security Audit
```

Atlas Protocol is currently in the **Audit Preparation Phase**.

---

# 15. Roadmap

Completed

* AccessManager
* Roles System
* AccessControlled
* AtlasToken
* Security Pipeline

Current

* Treasury Foundation

Next

* Treasury ERC20 Support
* Vault
* Rewards
* Staking
* Governance
* DAO
* Timelock
* Oracle
* Lending
* Liquidation Engine

---

# 16. Future Modules

Target architecture:

```text
Atlas Protocol

├── Access
├── Token
├── Treasury
├── Vault
├── Staking
├── Rewards
├── Governance
├── DAO
├── Timelock
├── Oracle
├── Lending
├── Liquidation
└── Risk Engine
```

All modules will share the same architecture pattern.

---

# 17. Contributing

Clone:

```bash
git clone <repository>
```

Install:

```bash
npm install
```

Build:

```bash
forge build
```

Run tests:

```bash
forge test
```

Before opening a Pull Request:

```bash
forge fmt --check

forge build

forge test

forge coverage

npx solhint --config security/solhint.json "src/**/*.sol"

slither . \
  --config-file security/slither.config.json \
  --exclude timestamp,pragma,unimplemented-functions

aderyn .
```

Every check must pass successfully.

---

# 18. Current Status

## Project State

**Architecture**

* Modular
* Security-first
* Audit-oriented

**Implemented Modules**

* AccessManager
* AtlasToken
* Common Layer
* Treasury Foundation (in progress)

**Testing**

* 42 unit tests passing

**Coverage**

* ~76%

**Security**

* Slither: 0 findings
* Aderyn: no critical findings
* Solhint: style warnings only

**Continuous Integration**

* GitHub Actions
* Foundry
* Slither
* Aderyn
* Solhint

---

# Conclusion

Atlas Protocol is built around modular smart contract architecture with security as its primary design goal.

Every protocol component follows standardized engineering practices that improve maintainability, simplify external audits, and enable future expansion.

As new modules are introduced—including Treasury, Vaults, Staking, Governance, Rewards, and DAO—they will inherit the same architectural principles, ensuring consistency, scalability, and long-term protocol resilience.
