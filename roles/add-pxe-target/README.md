add-pxe-target
=========

The role purpose is to add pxe target to cobbler, in order to allow the host to PXE boot. 

Role Variables
--------------

**NOTE** - cobbler_pass is the password for cobbler, can be watched in

The default values for the role are located as a dictionary named "defaults".
```
---
cobbler_pass: the value is inside vault, thus there is a need to decrypt it.
defaults:  # default values for the pxe target 
  state: present # state of the pxe target (can be absent or query)
  cobbler_server: vrcobbler01.example.com # the cobbler server in which the pxe target would be configured  
  cobbler_profile: rhel-7.9-x86_64 # the profile choosed for the pxe target  
  name: "{{ inventory_hostname }}" # the name for the pxe target, used for further edit of the target
  properties: 
    hostname: "{{ inventory_hostname }}" # chosen hostname for the pxe target
    netboot_enabled: yes # makes sure the pxe booting is allowed by cobbler
```
The defaults are combined with a dictionary named "pxe_configuration"

pxe_configuration dictionary
----------------
for example group_vars/pxe_targets.yml
```
pxe_configuration:
  properties:
    profile: rhel-7.9-x86_64
    gateway: <ip>
    kickstart: /var/lib/cobbler/kickstarts/sample_end.ks
  interfaces: 
    eth0: # can be any interfacee name you want, eno1 for workstations for example
      static: yes
      macaddress: "{{ mac }}"
      ipaddress: "{{ ip }}"
      netmask: 255.255.255.0
```
when mac and ip is defined per host in inventory file:
```
[pxe_targets]
example01 mac="" ip="192.168.10.9"
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
```
- hosts: pxe_targets
  gather_facts: False
  connection: local
  serial: 1
  roles: 
    - add-pxe-target
```

