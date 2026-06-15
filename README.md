# High Availability Load Balancer Homelab

Production-style homelab built with Infrastructure as Code principles using Ansible.

The objective of this project is to deploy and manage a highly available web platform consisting of multiple Nginx backend servers, HAProxy load balancers, and Keepalived-based Virtual IP failover.

---

## Technologies

* Proxmox VE
* LXC Containers
* Ansible
* Nginx
* HAProxy
* Keepalived
* VRRP

---

## Architecture

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

## Features

* Infrastructure as Code (IaC)
* Automated Nginx deployment
* Automated HAProxy deployment
* Automated Keepalived deployment
* Inventory-driven configuration
* Virtual IP (VIP) failover
* HAProxy health monitoring
* Active/Passive load balancer architecture
* Configuration drift recovery using Ansible

---

## Inventory

### Load Balancers

| Host | Role   |
| ---- | ------ |
| lb01 | MASTER |
| lb02 | BACKUP |

### Web Servers

| Host  |
| ----- |
| web01 |
| web02 |
| web03 |
| web04 |
| web05 |

---

## Deployment

Deploy the entire environment:

```bash
ansible-playbook playbooks/site.yml -K
```

Deploy only HAProxy:

```bash
ansible-playbook playbooks/haproxy.yml -K
```

Deploy only Keepalived:

```bash
ansible-playbook playbooks/keepalived.yml -K
```

---

## Failover Validation

Start traffic generation:

```bash
./fail-lb.sh
```

Simulate load balancer failure:

```bash
systemctl stop haproxy
```

Expected behavior:

1. HAProxy health check fails
2. Keepalived decreases node priority
3. VIP migrates to backup node
4. Traffic resumes through backup load balancer

---

## Observed Results

Observed failover interruption:

```text
~3-5 seconds
```

Reason:

```text
VRRP health-check timing
interval=1
fall=1
rise=1
```

Traffic automatically resumed after VIP migration.

---

## Lessons Learned

* Ansible Roles and Templates
* Inventory as Source of Truth
* HAProxy Backend Automation
* VRRP Fundamentals
* Keepalived Failover
* Virtual IP Management
* Infrastructure Recovery
* Configuration Drift Remediation

---

## Future Improvements

* Terraform Proxmox Provider
* Automated LXC Provisioning
* Dynamic Inventory
* Monitoring Stack (Prometheus + Grafana)
* CI/CD Validation Pipeline
