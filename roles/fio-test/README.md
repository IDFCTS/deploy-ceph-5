Role name - fio-test
=========

This role can be used to run FIO tests before add them into the cluster.

Requirements
------------

*  Make sure your server have yum configured - ca.bundle require

Role Variables
--------------
Those are the variables and their default values.
In order to learn more about the different values that each variable can get please read about FIO utility.

```
bs: 4k
ioengine: libaio
iodepth: 1
size: 10G
direct: 1
time_based: 1
runtime: 900
filename: /dev/sdb
fsync: 1

rand_read_require: What is the minimum required random read from the server? Lower value will failed the playbook.
seq_write_require: What is the minimum required sequential write from the server? Lower value will failed the playbook.
```

Dependencies
------------

None

Example Playbook
----------------
Here is an example for a playbook - 
```
---
- hosts: mon
  become: yes
  vars:
    rand_read_require: 100
    seq_write_require: 15000
  roles:
    - fio-test
...
```

License
-------

BSD

Author Information
------------------

Daniel Harit - s8222015