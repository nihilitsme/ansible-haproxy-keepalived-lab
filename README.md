# High Availability Load Balancer Homelab

Production-style homelab project built to learn Infrastructure Automation, Load Balancing, and High Availability concepts using Ansible.

---

# Overview

This project simulates a highly available web platform consisting of:

* 2 HAProxy Load Balancers
* 5 Nginx Backend Servers
* Keepalived Virtual IP Failover
* Ansible Automation

The objective is to understand how production environments handle redundancy, failover, configuration management, and infrastructure recovery.

---

# Architecture

```text
                    VIP
                10.0.2.234
                      |
          +-----------+-----------+
          |                       |
       lb01                    lb02
      MASTER                  BACKUP
          |                       |
          +-----------+-----------+
                      |
                HAProxy Layer
                      |
       +------+------+------+------+------+
       |      |      |      |      |
     web01  web02  web03  web04  web05
```

---

# Features

* Infrastructure as Code (IaC)
* Inventory Driven Configuration
* Automated Nginx Deployment
* Automated HAProxy Deployment
* Automated Keepalived Deployment
* HAProxy Backend Auto-Discovery
* Virtual IP (VIP) Failover
* Active / Passive Load Balancer Architecture
* Configuration Drift Recovery
* Health Check Based Failover

---

# Infrastructure

## Load Balancers

| Host | Role   |
| ---- | ------ |
| lb01 | MASTER |
| lb02 | BACKUP |

---

## Backend Servers

| Host  |
| ----- |
| web01 |
| web02 |
| web03 |
| web04 |
| web05 |

---

# Repository Structure

```text
.
├── inventories
├── playbooks
├── roles
│   ├── nginx
│   ├── haproxy
│   └── keepalived
├── docs
└── README.md
```

---

# Deployment

Deploy entire environment:

```bash
ansible-playbook playbooks/site.yml -K
```

Deploy HAProxy only:

```bash
ansible-playbook playbooks/haproxy.yml -K
```

Deploy Keepalived only:

```bash
ansible-playbook playbooks/keepalived.yml -K
```

---

# Failover Validation

Traffic generation script:

```bash
./fail-lb.sh
```

Simulate failure:

```bash
systemctl stop haproxy
```

Expected sequence:

1. HAProxy process stops
2. Keepalived health check detects failure
3. Priority drops
4. VIP migrates to backup node
5. Traffic resumes through backup load balancer

---

# Failover Evidence

## Topology

![Topology](docs/topology.png)

---

## Failover Test Result

![Failover Test](docs/failover-test.png)

---

## Raw Failover Log

Available at:

```text
docs/fail_lb_20260612_100533.log
```
---

# Observed Results

Successful failover observed.

Example:

```text
10:06:00 | FAILED
10:06:02 | FAILED
10:06:03 | FAILED
10:06:04 | lb02 | web01
```

Result:

* VIP migrated successfully
* Traffic resumed automatically
* Temporary interruption observed during VRRP election

Observed behavior:

```text
- HAProxy on MASTER failed
- Keepalived detected service failure
- VIP migrated to BACKUP node
- Traffic resumed automatically

Observed downtime:
~3-5 seconds
```

---

# Current Keepalived Tuning

```text
interval = 1
fall = 1
rise = 1
advert_int = 1
weight = -150
```

Purpose:

* Faster HAProxy failure detection
* Faster VIP migration
* Reduced failover downtime

---

---
# Why This Project Exists

The goal of this project is to gain practical experience with infrastructure automation, high availability, and operational reliability by building and maintaining a production-style environment using open-source technologies.

Rather than focusing solely on service deployment, this homelab emphasizes:

* Infrastructure as Code
* Repeatable automation
* High Availability design
* Configuration management
* Failover validation
* Operational visibility
* Recovery-oriented infrastructure practices

The project serves as a hands-on environment for understanding how production systems handle redundancy, service failures, and operational recovery.

---

# Deployment Logging

This project includes a custom deployment logging framework implemented through:

```bash
./scripts/deploy.sh
```

Every deployment automatically generates operational evidence and audit artifacts.

Generated artifacts:

| Directory    | Purpose                                   |
| ------------ | ----------------------------------------- |
| deployments/ | Raw Ansible execution logs                |
| metadata/    | Deployment metadata and audit information |
| reports/     | Human-readable deployment summaries       |

Captured deployment metadata includes:

* Deployment ID
* Deployment Timestamp
* Operator
* Controller Host
* Git Branch
* Git Commit Hash
* Git Commit Message
* Deployment Duration
* Deployment Status
* SHA256 Log Checksum

Runtime-generated deployment artifacts are intentionally excluded from version control.

Only the directory structure is tracked in Git.

This framework was introduced to improve deployment traceability, troubleshooting, auditability, and operational visibility.

---

# Lessons Learned

This project provided practical experience in:

* Building Infrastructure as Code using Ansible
* Designing High Availability architectures
* Implementing Virtual IP failover using VRRP
* Managing traffic distribution with HAProxy
* Building reusable Ansible roles and templates
* Creating inventory-driven deployments
* Recovering from configuration drift through automation
* Performing failover testing and validation
* Troubleshooting distributed infrastructure issues
* Designing deployment logging and audit-trail mechanisms
* Documenting operational procedures and infrastructure behavior

Most importantly, this project reinforced the value of repeatable automation, operational visibility, and recovery-focused infrastructure design.

---

# Future Improvements

Planned enhancements include:

* Terraform Proxmox Provider Integration
* Automated LXC Provisioning
* Dynamic Inventory Generation
* Infrastructure Lifecycle Management
* Prometheus Monitoring Stack
* Grafana Dashboards
* Automated Infrastructure Validation
* CI/CD Deployment Pipelines
* Automated Failover Testing
* Infrastructure Compliance Reporting

---

# Project Status

Current Status:

✅ Core High Availability Platform Completed

Implemented capabilities:

* Automated Infrastructure Deployment
* Inventory-Driven Configuration Management
* HAProxy Load Balancing
* Keepalived VIP Failover
* Configuration Drift Recovery
* Deployment Logging Framework
* Failover Validation Testing

This repository serves as the foundation for future infrastructure automation initiatives involving Terraform, Proxmox, Prometheus, Grafana, and CI/CD workflows.

Built as part of an ongoing DevOps Homelab Journey.


