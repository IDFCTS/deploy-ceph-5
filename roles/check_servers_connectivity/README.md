Check Network Connectivity
=========

This role checks that the firewall is deactivated and disabled.

It also pings all servers that are part of the cluster that the new server need to join to.

Requirements
------------

None.

Add role to requirements
------------
```
- src: https://gitlab.example.com/idfcts/storage/check_servers_connectivity.git
  scm: git
  name: check_servers_connectivity
```

Role Variables
--------------

`mon` - The mon that act as the supplier for the ip lists the hosts needs to ping.

`teams` - The list of teams that are configured and need to be tested, their names, mtus, subnet and types.

Example Group Vars
----------------
```
---
mons: obj
teams:
  - team_name: "sync"
    mtu: 8792
    type: "lacp"
    subnet: 192.168.4
  - team_name: "storage"
    mtu: 8792
    type: "lacp"
    subnet: 192.168.4
```

Example Playbook
----------------

```
---
- hosts: new-server-site-object
  gather_facts: no
  become: true
  roles:
  - role: storage-network-connectivity

```

Example Inventory
----------------
```
---
[new-server-site-object]
obj123
obj456

```


Author Information
------------------

Written by Dolev Orgad, Dror Tal.
~                         
