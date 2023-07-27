# configure-custom-dnf

This role is used to configure .repo file in a node.

This role was originally created to run on RHEL 8 nodes but it can be used on RHEL 7 nodes as well.

**Variable** 
- **repofiles:** An array of objects representing .repo files.
- **repodiles[n].name:** the file name of the .repo file.
- **repodiles[n].repo_sections:** An array of objects each representing a section with a dnf repository configuration.
- **repodiles[n].repo_sections[n].name:** The repository name.
- **repodiles[n].repo_sections[n].url:** The repository url.
- **repodiles[n].repo_sections[n].enabled:** The repository is enabled or not (default: 1).
- **repodiles[n].repo_sections[n].gpgcheck:** Perform a gpgcheck on the repository (default: 0).
- **repodiles[n].repo_sections[n].gpgkey:** The path for the repository gpgkey (default: '').

**Example Group Vars:**
```
repofiles:
  - name: "rhel-8"
    repo_sections:
      - name: "rhel-8-appstream-rpms"
        url: "https://yum.example.com/rhel8.4/rhel-8-for-x86_64-appstream-rpms/"
      - name: "rhel-8-baseos-rpms"
        url: "https://yum.example.com/rhel8.4/rhel-8-for-x86_64-baseos-rpms/"

  - name: "epel"
    repo_sections:
      - name: "epel"
        url: "https://yum.example.com/current/epel/"
        enabled: 0
        gpgcheck: 1
        gpgkey: "https://yum.example.com/keys/RPM-GPG-KEY-EPEL"
```

**Example Playbook:**
```
- hosts: blk
  roles:
    - configure-custom-dnf
  become: true
```