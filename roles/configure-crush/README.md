configure_crush
=========

This role creates crush buckets, crush rules and pools for ceph. 


Role_variables
----------------
Example group_vars/cluster_variables.yml

```yaml
  
crush_hierarchy:
  - name: default #the_name_of_the_root_bucket
    type: root
    children:
      - name: AZ-A
        type: zone #optional_bukcet_type_under_the_root_bucket
        children:
          - name: blk01 
            type: host
          - name: blk02
            type: host
      - name: AZ-B
        type: zone 
        children:
          - name: blk03
            type: host
          - name: blk04
            type: host

rules:
  - name: host-a
    type: replicated
    seperation: host 
    root: AZ-A

  - name: host-b
    type: replicated
    seperation: host
    root: AZ-B

pools:
  - name: a
    pgs: 1024
    application: "rbd"
    autoscale_mode: "warn"
    mode: replicated
    replicate: 2
    rule_name: host-a

  - name: b
    pgs: 1024
    application: "rbd"
    autoscale_mode: "warn"
    mode: replicated
    replicate: 2
    rule_name: host-b
```
Every time you want to add another bucket that containts other buckets you need to add childrens.

Example Playbook
----------------

In the playbook you just need to call the role:

```yaml
- hosts: bootstraps
  roles:
    - configure-crush
  become: true
```

