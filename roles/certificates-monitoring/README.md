Certificates Monitoring
=========

This role is used to monitor certificates expiration using bash script and node_exporter textfile collector.
The role also prints the host,issuer,CN,expiration date and serial number and saves it in /var/lib/custom-metrics directory.
Once a day there will be a cronjob that executes the monitoring script on the requested certificates. 
The role makes sure that the file exists before adding monitoring to it, certificate path will be skipped and the exececution won't fail.                 

Role Variables
--------------

You can either add group_vars or configure it in the playbook itself. 
Whichever way you decide, the variable should be called certificates_list and it should include all the certificates you'd like to monitor on your host.
For example:

```
certificates_list:
- /etc/pki/vdsm/certs/cacert.pem
- /etc/pki/vdsm/certs/vdsmcert.pem
```

Example Playbook
----------------
```
---

- hosts: pre-rhv
  become: true
  vars:
    certificates_list:
    - /etc/pki/vdsm/certs/cacert.pem
    - /etc/pki/vdsm/certs/vdsmcert.pem
  roles:
  - certificates-monitoring
...
```
