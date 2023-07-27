Ansible Role: lldpad
====================

This role prepares the switch to have automatic configuration. It does couple of things:
1. Installs the lldpad package, which provides the userspace daemong and configuration tool for the Link Layer Discover Protocol (LLDP) agent.
2. Turn on the lldpad agent in all the interface on the server.
3. Crate a dictionary that wich interface connect to wich swich and the ports in the switch.



Supported and tested on EL6 and EL7.

Requirements
------------

Useful on physical hosts for determining uplink switch/switchport connections.

Role Variables
--------------

Enable LLDP on all active interfaces:

    lldpad_active_interfaces: true

Enable LLDP only on selected interfaces:

    lldpad_selected_interfaces: []

Dependencies
------------

None.

Example Playbook
----------------
    
    - hosts: server_name
      gather_facts: yes
      become: yes
      roles:
      - role: configure-lldpad  

License
-------

BSD

