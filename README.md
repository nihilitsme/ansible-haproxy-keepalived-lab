# Homelab DevOps

Production-style homelab built using:

- Proxmox
- LXC Containers
- Ansible
- Nginx
- HAProxy
- Keepalived
- VRRP

---

## Architecture

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
       +------+------+------+------+
       |      |      |      |      |
     web01  web02  web03  web04  web05


✔ Infrastructure as Code

✔ Automated Nginx Deployment

✔ Automated HAProxy Deployment

✔ Automated Keepalived Deployment

✔ Virtual IP Failover

✔ HAProxy Health Check

✔ Active / Passive Load Balancer

✔ Recovery from Configuration Drift

✔ Inventory Driven Configuration


Deploy:

ansible-playbook playbooks/site.yml -K


Failover Test:

systemctl stop haproxy

Expected:

VIP migrates to backup node

Traffic continues

Downtime ≈ 3-5 seconds

Failover Test:
1. Start traffic script
2. Stop HAProxy on MASTER
3. Keepalived detects failure
4. VIP moves to BACKUP
5. Traffic continues

Observed failover interruption
~5-7 seconds

Current Tuning:
interval = 1
fall = 1
rise = 1

Project Structure:
inventories/
playbooks/
roles/
