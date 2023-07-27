Role Name - Configure Keepalive
=========

This role configures the keepalived service on the HaProxy server. 


Role Variables
--------------

There are several parameters you need to define for the keepalived.conf template - 

- service_name - for the check script
- vip:
    name
    interface
    auth_pass
    address
    proxies_group


Dependencies
------------

This role should run after the haproxy installation and configuration role.


Example Playbook
----------------

    - hosts: haproxy_servers
      become: True
      roles:
         - proxy_keepalive



Author Information
------------------

Dror Tal