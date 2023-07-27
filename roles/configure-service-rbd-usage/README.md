# Configure Service Rbd Usage

This role create configure services to start after the rbd image mounted.
It is usefull to use after configuring rbd with lvm with the role configure-rbd-image https://gitlab.example.com/idfcts/storage/configure-rbd-image

**Variables in the role**  
- {+ service_name +} - The name of the service that the role works with.
- {+ service_path +} - The path to where the service file is. (default: /usr/lib/systemd/system/{{ service_name }}.service)
- {+ mount_point +} - Where the rbd that is used by the service is mounted.

Usage
----------------
### Requirements file
Import the next requirements file:
```
- src: https://gitlab.example.com/idfcts/storage/configure-service-rbd-usage.git
  scm: git
  name: configure-service-rbd-usage
```

```
ansible-galaxy install -r roles/requirements.yml
```

**Example Playbook:**
```yaml
---
- name: "configure rbd for service"
  hosts: rbd-host
  become: true
  roles:
    - configure-service-rbd-usage
```

### Example group_vars
```yaml
---
service_path: /usr/lib/systemd/system/{{ service_name }}.service
service_name: prometheus
mount_point: /var/lib/prometheus
```

### Run The Playbook
```
ansible-playbook -i inventory site.yml
```

Author Information
----------------
Dror Tal