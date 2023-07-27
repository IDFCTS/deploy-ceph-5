Configure Ceph
=========

The role is used to set custom configuration for services of ceph.

Role Variables
--------------

`ceph_configuration` - Dictionary of services the configuration is intended for, the dictionary structure:

  - `service` - The service name of the configuration (mgr, mon etc), use regex when the service name is not known, for example: `rgw.*{{ inventory_hostname }}`, in that case, the service is searched by the automation.
  - `target`: The ansible host group that the configuration is relevent for (see group_vars example).
  - `configuration` - Dictionary of configuration, key and value pairs.   
  
Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: ceph-servers
      become: true
      serial: 1
      roles:
        - configure-ceph

Example group_vars
----------------
    ceph_configuration:
      - service: mgr
        target: obj
        configuration: 
          - key: mgr/dashboard/{{ inventory_hostname }}/server_addr
            value: "{{ inventory_hostname }}.example.com"
          - key: mgr/dashboard/ssl_server_port
            value: "8443"
      - service: "rgw.*{{ inventory_hostname }}" 
        target: obj
        configuration: 
          - key: rgw_dns_name
            value: "{{ inventory_hostname }}.example.com"
      - service: "global" 
        target: bootstraps
        configuration: 
          - key: mon_cluster_log_to_stderr
            value: false
