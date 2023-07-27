Role name - Configure Haproxy
=========

This role configures an **object-haproxy** inside a VM


Requirements
------------

*  Make sure a new VM is already up and running, the OS is updated, and that the vm is a member of the domain.


Variables
------------
```
yum_endpoint: yum.example.com
var_log_vg: rootvg
var_log_lv: var_loglv
pv_disks: /dev/sda2,/dev/sdb

proxy_path: /etc/haproxy/haproxy.cfg
dedicated_cpu_num: 7

binds:
  - port: 443
    use_https: true
    cert_name: certificate_file_name
    cert: | cert_value
    interface: eth0 - interface to listen on
  - port: 9090
    use_https: false

backends:
  - name: regular
    servers:
      - address: '192.168.4.64'
        port: '80'
        name: 'pre-gw01'
      - address: '192.168.4.65'
        port: '80'
        name: 'pre-gw02'
  - name: cache
    servers:
      - address: '192.xx.xx.xx'
        port: '80'
        name: ''

special_clients:
  - name: dror
    access_key: some_access_key
    priority_class: 1 (lower value means higher priority)

cache_clients:
  - name: dror
    access_key: some_access_key

cache_backend: cache
logs_server: log01
```


Example Playbook
----------------

Here is an example for a playbook - 
```
- hosts: haproxy_servers
  gather_facts: True
  become: True
  roles:
  - configure-haproxy

```

Example Inventory
----------------
```
[haproxy_servers:vars]
site = site

[haproxy_servers:children]
haproxy_servers-mm

[haproxy_servers-mm]
objprox0
```

Author Information
------------------

Dror Tal, Dolev Orgad.
