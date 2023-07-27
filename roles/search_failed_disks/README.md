Failed Disks Exporter
=========

This role configures the failed disks exporter.

It should be deployed on storage servers of all types (block, object).

The exporter looks for critical hardware errors in dmesg log. That error indicates that the specified disk is in failed state.
Example for a metric:

`dmesg_medium_errors_count{failed_disks="sdc, sdai"} 2`

Requirements
------------

[Node exporter](https://gitlab.example.com/idfcts/configure-node-exporter) must be configured on the servers before using this role. Otherwise, prometheus won't scrap these servers' metrics and no alerts will be presented in Grafana.


Usage
--------------

### requirements file

Import the next requirements file:

```
- src: https://gitlab.example.com/idfcts/storage/failed-disks-exporter.git
  scm: git
  name: search_failed_disks
```

```
ansible-galaxy install -r roles/requirements.yml
```

Role Variables
--------------

None.

Example Playbook
----------------

```
---
- hosts: blk
  become: yes
  become_method: sudo
  roles:
    - { role: search_failed_disks }
```

Example Inventory
----------------
```
---
[blk]
mblk04
blk05

```


Author Information
------------------

Written by Dolev Orgad.
