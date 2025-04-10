
# Ansible Hands-on Project

This repository provides a structured approach to writing and running Ansible playbooks for automating package installation, hosting a website, managing MinIO buckets, and clean uninstallation.

---

### Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [Running the Playbook](#running-the-playbook)
- [Roles Overview](#roles-overview)
- [Useful Commands](#useful-commands)
- [Notes](#notes)
- [Question](#questions)
- [Conclusion](#conclusion)
- [Reference Links](#reference-links)
- [Author](#author)

---

### Overview

This project automates:

- Installing necessary packages like Docker, Git, Vim, etc.
- Cloning and deploying a website from GitHub using PM2.
- Managing MinIO buckets (create, upload, delete).
- Uninstalling packages and cleaning up.

---

### Directory Structure

```
├── ansible.cfg
├── inventory
├── main.yml
├── README.md
├── requirements.yml
├── resources
│   ├── docker-compose-minio.yml
│   └── index.html
├── roles
│   ├── host_website
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── vars
│   │       └── main.yml
│   ├── install_packages
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── vars
│   │       └── main.yml
│   ├── minio
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── vars
│   │       └── main.yml
│   └── uninstall_packages
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── tasks
│       │   └── main.yml
│       ├── tests
│       │   ├── inventory
│       │   └── test.yml
│       └── vars
│           └── main.yml
└── vars
    └── main.yml
```

---

### Prerequisites

- Python and Ansible installed on the control node
- Python installed on managed nodes
- SSH access from control node to managed nodes
- Run to install necessary collections
```bash
  ansible-galaxy install -r requirements.yml
```
- Set all variables in [vars/main.yml](vars/main.yml)
- If `minio: true` is set in [vars/main.yml](vars/main.yml):
  - Set `minio_access_key` and `minio_secret_key` in [roles/minio/vars/main.yml](roles/minio/vars/main.yml)
  - Encrypt the file using:  
    ```bash
    ansible-vault encrypt roles/minio/vars/main.yml
    ```

---

### Running the Playbook
- Set the IP in [inventory](inventory)
- With vault password:
  ```bash
  ansible-playbook -i inventory main.yml --ask-vault-password
  ```
- Without vault password:
  ```bash
  ansible-playbook -i inventory main.yml
  ```

---

### Roles Overview

### [install_packages](roles/install_packages)
- Ping hosts
- Update apt cache
- Install:
  - vim
  - git
  - net-tools
  - curl
  - npm
  - docker.io

### [host_website](roles/host_website)
- Clone [urbio-blog](https://github.com/ssunils/urbio-blog)
- Install npm dependencies
- Install `pm2` globally
- Start dev server using pm2
- Wait for server initialization
- Verify pm2 process is running
- Stop and delete pm2 process

### [minio](roles/minio)
- Create bucket
- Upload object
- Delete bucket

### [uninstall_packages](roles/uninstall_packages)
- Uninstall:
  - vim
  - git
  - net-tools
  - curl
  - npm
- Stop Docker service
- Uninstall `docker.io`
- Validate and confirm Docker removal

---

### Useful Commands

```
ansible                # Run ad-hoc commands
ansible-playbook       # Execute playbooks
ansible-config         # Manage Ansible config
ansible-console        # Interactive console
ansible-doc            # View module documentation
ansible-galaxy         # Manage roles and collections
ansible-inventory      # View inventory
ansible-pull           # Pull and run playbook from VCS
ansible-vault          # Encrypt/decrypt files
```

---

### Notes

- To print all gathered Ansible facts for a host (useful for debugging or dynamic variable usage), add the following task in any play:

  ```yaml
  - name: Print all ansible facts
    ansible.builtin.debug:
      var: ansible_facts
  ```

---

### Questions

### What is a Control Node and Managed Node?
- **Control Node**: The machine where Ansible is installed and playbooks are executed from.
- **Managed Node**: The target machine(s) that Ansible manages. Ansible connects via SSH to configure or deploy to them.

### What are the prerequisites for Managed Nodes?
- The **managed nodes must have Python installed**, since Ansible modules run via Python by default.
- You do **not** need to install Ansible on managed nodes.
- Ensure passwordless SSH access from the control node to each managed node.

### What is Ansible Galaxy?
- A **repository for sharing Ansible roles and collections**.
- You can install third-party or community-created automation code.
- Example:
  ```bash
  ansible-galaxy install -r requirements.yml
  ```

### What is ansible-vault?
- A tool to **encrypt sensitive variables/files** (like API keys or passwords).
- Example:
  ```bash
  ansible-vault encrypt roles/minio/vars/main.yml
  ```

### What is Jinja2 in Ansible?
- Jinja2 is the **templating engine** used by Ansible to evaluate variables and expressions.
- Example:
  ```yaml
  message: "Hello, {{ user_name }}"
  ```

### How are modules executed?
- Ansible **copies the required module code to the managed node**, runs it using **Python**, and returns the result.
- Modules are **not installed** permanently; they're executed as needed.

### What are Handlers in Ansible?
- Handlers are **tasks triggered only when notified** by another task.
- They are useful for actions like restarting services **only when changes occur**.
- Handlers run **at the end** of a play by default, even if multiple tasks notify them.
- To run them immediately:
  ```yaml
  - meta: flush_handlers
  ```

---

### Conclusion

This project is a hands-on lab for learning and practicing Ansible automation in a structured, modular format using roles and tasks.

---

### Reference Links

- [Ansible Docs](https://docs.ansible.com/ansible/latest/)
- [Ansible Blocks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#block-error-handling)
- [AWS Collection for Ansible](https://docs.ansible.com/ansible/latest/collections/amazon/aws/index.html)
- [Ansible Zero to Hero Playlist](https://youtube.com/playlist?list=PLdpzxOOAlwvLxd5nmtmORCmhD5jkrNbuE&si=OFmuX7JvIm_sf4Op)
- [Playlist Git Project](https://github.com/iam-veeramalla/ansible-zero-to-hero)
- [Website GitHub Repo](https://github.com/ssunils/urbio-blog)

---

### Author

**Prashant Jeet Singh** - DevOps Learner  
_This project was built as part of a personal hands-on journey with Ansible and is created for learning and practice purposes._
