------------------------------------------------------------------------------------------------------------------------------------------------------------
                                       Ansible Rough book
------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
                                Ansible Cheat Sheet

https://lzone.de/cheat-sheet/Ansible

Playbooks
ansible-playbook <YAML>                   # Run on all hosts defined
ansible-playbook <YAML> -f 10             # Run 10 hosts parallel
ansible-playbook <YAML> --verbose         # Verbose on successful tasks
ansible-playbook <YAML> -C                # Test run
ansible-playbook <YAML> -C -D             # Dry run
ansible-playbook <YAML> -l <host>         # Run on single host

Run Infos
ansible-playbook <YAML> --list-hosts
ansible-playbook <YAML> --list-tasks



Syntax Check

ansible-playbook --syntax-check <YAML>
Remote Execution
ansible all -m ping
Execute arbitrary commands

ansible <hostgroup> -a <command>
ansible all -a "ifconfig -a"


List facts and state of a host

ansible <host> -m setup                            # All facts for one host
ansible <host> -m setup -a 'filter=ansible_eth*'   # Only ansible fact for one host
ansible all -m setup -a 'filter=facter_*'          # Only facter facts but for all hosts
Save facts to per-host files in /tmp/facts

ansible all -m setup --tree /tmp/facts

----------------------------------------------------------------------------------------------------------------------------

## Ansible Playbook
# [::kafka]root@5e090907e089:kafka_compartment # cd /root/infra/playbooks/inventories/
# ./org_inventory.py --list | jq '."tag_componentType=kafka-dev"'   
#./org_inventory.py --list | jq '."tag_componentType=kafka"'

# ansible all -u opc -i inventories/$ENVIRONMENT.$REGION/org_inventory.py -e target_group=tag_componentType=kafka -m shell -a 'df -h' -l "10.2.10.21, 10.2.10.19"

## To Run ansible on a Single Instance (10.5.8.8)
# ansible-playbook -u opc -i stageiad.us-ashburn-1/org_inventory.py -e target_group='."tag_componentType=kafka" | .hosts[0]' ../install-jmxkafka-exporter.yml --limit 10.5.8.8
# ansible-playbook -u opc -i stageiad.us-ashburn-1/org_inventory.py -e target_group=tag_componentType=kafka ../install-jmxkafka-exporter.yml --limit 10.5.8.133

## To Run ansible on a Group of Instances (kafka-dev)
# ansible-playbook -u opc -i inventories/stageiad.us-ashburn-1/org_inventory.py -e target_group=tag_componentType=kafka-dev  install-kafka.yml --tags vm_swappiness
# ansible-playbook -u opc -i stageiad.us-ashburn-1/org_inventory.py -e target_group=tag_componentType=kafka ../install-jmxkafka-exporter.yml

## Kafka Status
## ansible all -u opc -i ./$ENVIRONMENT.$REGION/org_inventory.py -e target_group=tag_componentType=kafka -m shell -a 'sudo systemctl status kafka'


---
- name: "Enable root_ca"
  hashivault_secret_enable:
    name: "root_ca"
    backend: "pki"
    url: "{{ vault_config_url }}"
    ca_path: "{{ vault_tls_ca_file }}"
    token: "{{ vault_config_token }}"
    config:
      max_lease_ttl: 315360000   #10 Years in seconds (apparently the module won't update this if it changes...)
    description: "Root CA"


- block:
  - name: Try and grab the vault_config_token if we dont already have it.
    shell: "sops -d --extract '[\"encrypted_vault_config_token\"]' {{ vault_secrets_file }}"
    register: vault_config_token_decrypt_results

  - name: Set vault_config_token fact
    set_fact:
      vault_config_token: "{{ vault_config_token_decrypt_results.stdout }}"

  when: vault_config_token is not defined
  delegate_to: localhost
  run_once: true

------------------------------------------------------------------------------

SETUP BELOW FOR RUNNING ANSIBLE FROM COMMAND LINE for TEST 

FOR TESTCORP:

export REGION=us-ashburn-1
export ENVIRONMENT=corp

unset ANSIBLE_SSH_ARGS
echo $ANSIBLE_SSH_ARGS

[corp:corp:kafka]root@e53b65eb82fb:inventories # env | grep ANSIBLE
ANSIBLE_HOST_KEY_CHECKING=False
ANSIBLE_REMOTE_USER=opc
ANSIBLE_VERSION=2.8
ANSIBLE_SSH_RETRIES=2
ANSIBLE_CONFIG=/tmp/ansible.cfg

      SET the below COMPARTMENT for TESTCORP > 

export PARENT_COMPARTMENT=orgd1.compartment.oc1..aaaaaaaalvgffjfqb34o4w4bsp3a4jup2msafbg24jx3r45unkab34v5mdfa
export COMPARTMENT=orgd1.compartment.oc1..aaaaaaaag2gahx34rfzvent4mxe4xrfzozkbmdkokcpw6gu3v3l5vext5soa

○ → export ANSIBLE_CONFIG=/Users/azhekhan/TEST/-cloud-ms/ansible/corp/ansible.cfg

[corp:corp:kafka]root@e53b65eb82fb:inventories # cat /tmp/ansible.cfg
[defaults]
host_key_checking = False
inventory=/tmp/hosts

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False



○ → cat ./hosts
[corpkafka]
10.111.88.41
10.111.88.42
DONE - 10.111.88.51
10.111.88.54
10.111.88.50
DONE - 10.111.88.38
10.111.88.56
10.111.88.37
10.111.88.43

cat playbooks/install-jmxkafka-exporter.yml
---
- hosts: all
  become: true
  #become: yes
  vars_files:
    - "vars/defaults.yml"
    - "vars/envs/{{ env }}.yml"
    - "vars/regions/{{ region }}.yml"
  roles:
    - jmx_exporter
    - jmx_exporter_kafka

[corp:corp:kafka]root@e53b65eb82fb:inventories # ansible-playbook -u opc  /root/repo/repo-infra/playbooks/install-jmxkafka-exporter.yml  --limit 10.111.88.38

------------------------------------------------------------------------------
                Running Ansible Manually for certain instances

[stage:integ:kafka]root@a42d9efeee07:inventories # vi /tmp/ansible.cfg
[stage:integ:kafka]root@a42d9efeee07:inventories # vi /tmp/hosts
[stage:integ:kafka]root@a42d9efeee07:inventories # cat /tmp/ansible.cfg
[defaults]
inventory=/tmp/hosts


[stage:integ:kafka]root@a42d9efeee07:inventories # export ANSIBLE_CONFIG=/tmp/ansible.cfg
[stage:integ:kafka]root@a42d9efeee07:inventories # cat /tmp/hosts
[kafkainteg]
10.2.10.82
10.2.10.81
10.2.10.80
10.2.10.151
10.2.10.83
10.2.10.17
10.2.10.85
10.2.10.153
10.2.10.16
10.2.10.152

[stage:integ:kafka]root@a42d9efeee07:inventories # ansible kafkainteg -m ping

[stage:integ:kafka]root@a42d9efeee07:inventories #ansible kafkainteg -m shell -a 'sudo ls -ltr /etc/consul.d/kafka_exporter.json'

[stage:integ:kafka]root@a42d9efeee07:inventories #ansible kafkainteg -m shell -a 'sudo rm -f /etc/consul.d/kafka_exporter.json'

sudo rm -f /etc/consul.d/kafka_exporter.json
sudo ls -ltr /etc/consul.d/kafka_exporter.json
sudo systemctl restart consul
sudo systemctl status consul



------------------------------------------------------------------------------
        TESTPROD VAULT

[dev:devphx:kafka]root@677eb66eaac9:ansible_ # cat /root/repo/ansible_/ansible.cfg
[defaults]
host_key_checking = False
inventory=/root/repo/ansible_/hosts_dev-phx

[privilege_escalation]
become=True
become_method=sudo
become_user=opc
become_ask_pass=False

##export ANSIBLE_CONFIG=/root/repo/ansible_/ansible.cfg
[dev:devphx:kafka]root@677eb66eaac9:ansible_ # cat /root/repo/ansible_/hosts_dev-phx
[vault_devphx]
10.4.4.50
10.4.4.54
10.4.4.58

[dev:devphx:kafka]root@677eb66eaac9:ansible_ # ansible -u opc vault_devphx -m ping
10.4.4.58 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}

Run Ansible command with sudo (-k) privileges and one by one (-f)
[dev:devphx:kafka]root@677eb66eaac9:ansible_ # ansible -u opc vault_devphx -m shell -a ' uptime' -k -f 1

[dev:devphx:kafka]root@677eb66eaac9:ansible_ # ansible -u opc vault_devphx -m shell -a ' uptime' -f 1

while true; do echo "-----------"; ansible -u opc vault_devphx -m shell -a ' uptime; df -kh | grep "/dev/"' -f 1 ; sleep 100s; done



------------------------------------------------------------------------------
                Ansible Training        03 Feb 2020
------------------------------------------------------------------------------
Trainer: Harpreet Singh

SECRET FOR EVERY TRAINING and TECHNOLOGY LEARNING:
Behave Like the Technology that you are working with is a Living Thing
Try to give it an Identity so that we can better understand how they work
Understand the First Principle behind everything/every Object

------------------------------------------------------------------------------
Day 1:

Introducing ansible 
deploying ansible
implementing playbooks


Ansible Controller: ssh vagrant@192.168.3.5

[vagrant@app1 ~]$ hostnamectl

[vagrant@app1 ~]$ sudo su -
[root@app1 ~]#  yum clean all ; yum repolist

[root@app1 ~]# yum list all | grep ansible
ansible.noarch                              2.4.2.0-2.el7              extras   
ansible-doc.noarch                          2.4.2.0-2.el7              extras   
centos-release-ansible26.noarch             1-3.el7.centos             extras   
[root@app1 ~]# yum install epel-release -y

[root@app1 ~]# yum install ansible -y
[root@app1 ~]# ansible --version
ansible 2.9.2
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, Apr  9 2019, 14:30:50) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
[root@app1 ~]#

#Python 2.x  Ansible 2.6 or >
#Python 3.x  Ansible 3.5 or >

[root@app1 ~]# useradd devops

[vagrant@app1 ~]$ ssh vagrant@192.168.3.6 "echo 'redhat' | sudo passwd --stdin devops"
Changing password for user devops.
passwd: all authentication tokens updated successfully.
[vagrant@app1 ~]$ ssh vagrant@192.168.3.7 "echo 'redhat' | sudo passwd --stdin devops"
Changing password for user devops.
passwd: all authentication tokens updated successfully.

[root@app1 ~]# echo "devops ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/devops
[root@app1 ~]# cat /etc/sudoers.d/devops 
devops ALL=(ALL) NOPASSWD: ALL


##AD-HOC
#ansible <host> -m <module> -a <argument>
ansible 192.168.3.6 -m yum -a "name=httpd state=installed"

[devops@app1 ~]$ sudo vi /etc/ansible/hosts 
[devops@app1 ~]$ ansible all -m ping
192.168.3.7 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
192.168.3.6 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}

[devops@app1 ~]$ ansible all --list-hosts
  hosts (2):
    192.168.3.6
    192.168.3.7

[devops@app1 ~]$ ll /etc/ansible/ansible.cfg 
[devops@app1 ~]$ ll /etc/ansible/hosts 
##Projects > Directory

Ansible Configuration Dir presidence (Priority Order)
#0. ## Ansible environment varibales have the highest precedence
#1. Current working dir > ansible.cfg
#2. Current users home DIR eg: /home/devops/.ansible.cfg | /root
#3. Global Config file > /etc/ansible/ansible.conf

[devops@app1 project]$ touch ansible.cfg
[devops@app1 ~]$ touch /home/devops/.ansible.cfg
[devops@app1 project]$ export ANSIBLE_CONFIG=/tmp/ansible.cfg

[devops@app1 project]$ cat ansible.cfg 
[defaults]
inventory=./hosts   ## /etc/ansible/hosts   --> Is an INI file
remote_user=devops  ## dont consider current user as a ssh one
ask_pass=False      ## Asks for: ssh password ask_pass: true
#Ansible uses the current user account used for ssh connection

## Ansible environment varibales can also be set instead

Groups for user accounts, instances,

[devops@app1 project]$ cat ansible.cfg 
[defaults]
inventory=./hosts
remote_user=devops
ask_pass=False

[privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False


[devops@app1 project]$ cat hosts
[webserver]
192.168.3.6

[dbserver]
192.168.3.7

[servers:children]
webserver
dbserver

# ansible <host> -m module -a argument
# ansible webserver -m yum -a CCCC
# ansible servers -m yum -a CCCC

ansible servers -m ping
ansible webserver -m ping
ansible dbserver -m ping


ansible-doc -l | grep -i org
ansible-doc -l | grep -i apt
ansible-doc -l | grep -i yum
ansible-doc yum

## Idempotent >> If the desired state is achieved, if you re-run the task ansible does not do anything
## Attributes of files: stats mtime
## USe Modules:

[devops@app1 project]$ #green: success
[devops@app1 project]$ #red: failure
[devops@app1 project]$ #purple: warnings
[devops@app1 project]$ #yellow: changed
[devops@app1 project]$ #blue: verbosity (debug)

## Command module runs a single command
##Command >> echo "hello" >> /tmp/file1.txt

## to run Nested commands use the SHELL module:
[devops@app1 project]$ ansible webserver -m shell -a "cat /etc/passwd | grep devops"

### Shell & Command Modules are not Idempotent --> as the state of the command cannot be maintained 

## Ansible uses the "STAT" for managing Files (module)
[devops@app1 project]$ stat hosts
  File: 'hosts'
  Size: 88          Blocks: 8          IO Block: 4096   regular file
Device: 801h/2049d  Inode: 67151448    Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1001/  devops)   Gid: ( 1001/  devops)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2020-02-03 09:24:48.854860875 +0000
Modify: 2020-02-03 09:23:57.282467412 +0000
Change: 2020-02-03 09:23:57.283467419 +0000
 Birth: -


## VIM Configurations
[devops@app1 project]$ cat ~/.vimrc 
set ai et ts=2 cursorcolumn


[devops@app1 project]$ cat playbook.yml
---
- name: play to deploy apache
  hosts: webserver
  tasks:
    - name: installing apache package
      yum:
        name: httpd
        state: present

    - name: install firewall package
      yum:
        name: firewalld
        state: latest

    - name: start apache service
      service:
        name: httpd
        state: started

    - name: starting firewall service
      service:
        name: firewalld
        state: started


    - name: allow 80 port in firewall
      firewalld:
        port: 80/tcp
        state: enabled

# HOST SCOPE           # TASK SCOPE
# ansible webserver -m yum -a "name=httpd state=present"
#  lists | dicrionary
#    key: value
#
#    key1:
#      - val1
#      - val2
#      - val3


---
- name: play to deploy apache
  hosts: webserver
  tasks:
    - name: installing apache package
      yum:
        name: httpd
        state: present
    - name: install firewall packagae
      yum:
        name: firewalld
        state: latest
    - name: start apache service
      service:
        name: httpd
        state: started
    - name: starating firewall service
      service:
        name: firewalld
        state: started
    - name: allow 80 port in firewall
      firewalld:
        port: 80/tcp
        state: enabled



    - name: copy index.html file
      copy:
        src: index.html
        dest: /var/www/html/index.html
- name: play to verify apache
  hosts: localhost
  tasks:
    - name: validate web server endpoint
      uri:
        url: http://192.168.56.102
        status_code: 200




[devops@app1 project]$ cat playbook.yml
---
- name: play to deploy apache
  hosts: webserver
  tasks:
    - name: installing apache package
      yum:
        name: httpd
        state: present

    - name: install firewall package
      yum:
        name: firewalld
        state: latest

    - name: start apache service
      service:
        name: httpd
        state: started

    - name: starting firewall service
      service:
        name: firewalld
        state: started

    - name: allow 80 port in firewall
      firewalld:
        port: 80/tcp
        state: enabled

    - name: copy index.html file
      copy:
        src: index.html
        dest: /var/www/html/index.html

- name: Play to verify apache
  hosts: localhost
  tasks:
    - name: validate web server endpoint
      uri:
        url: http://192.168.3.6
        status_code: 200





Ansible Managed Node1: ssh vagrant@192.168.3.6
[vagrant@app2 ~]$ ip addr
[vagrant@app2 ~]$ ping goo.gl
[vagrant@app2 ~]$ hostnamectl
[root@app1 ~]# useradd devops


Ansible Managed Node2: ssh vagrant@192.168.3.7
[vagrant@app3 ~]$ ping 8.8.8.8
[root@app1 ~]# useradd devops





------------------------------------------------------------------------------
Day 2:

Managing varibales and facts
implmenting ansible vault
implementing task conrol


#ansible all -m command -a "hostname" --private-key my_key.pem
## Ansible looks under ~/.ssh/ folder for private keys as id_rsa or id_dsa
## Use the scp-copy module to copy the ssh key to the private instance
#

yum:
  name: httpd
## Infra as a code >> code

#yaml >> variable
## Variable Scope
#1. Global Scope: execution Playbook   -e var=value1 
#2. Play Scope: Playbook level (inside)
#3. Host Scope: Inventory file

# var1=abc inventory   (./hosts)
# var1=xyz playbook    (.yaml)
#ansible-playbook playbook.yml -e var1=hello  (global)


## Variable will be interepreted by {{ var1 }} curly braces
## If the variable is called in between the sentance "" is not needed
- name: Play1             
  vars:                
    var1: httpd
    -name: Installing {{ pkg }} Package
      yum:           
        name: "{{ pkg }}"


[devops@app1 project]$ cat vars.yml 
---
- name: Play1
  hosts: webserver
  become: true
  vars_files:
    - var_file.yml
  #vars:
    #pkg: httpd
    #srv: httpd
    #rule: http
    ## a-z | _ | 0-9 var1 var_1 >> _vars  1var
  tasks:
    - name: Installing {{ pkg }} Package
      yum:
        name: "{{ pkg }}"
        state: latest

    - name: Starting {{ srv }} Service
      service:
        name: "{{ srv }}"
        state: started
        enabled: true

    - name: Allow {{ rule }} in Firewall
      firewalld:
        service: "{{ rule }}"
        state: enabled
        permanent: true
        immediate: true

[devops@app1 project]$ cat var_file.yml 
---
pkg:
  - httpd
  - firewalld
  - vim
  - elinks
  - git

srv: httpd
rule: http

Do we have these best practices documented anywhere ?
Yes, there are in ansoble-docs

#Play Scope: Plabook (inside{vars:} / external yml file{vars_files:})
#Host Scope: Inventory
#hosts

[devops@app1 project]$ cat hosts 
[webserver]
192.168.3.6   pkg=vsftpd srv=vsftpd rule=ftp

[dbserver]
192.168.3.7

[servers:children]
webserver
dbserver

[webserver:vars]
pkg=mariadb-server
srv=mariadb
rule=mysql


If while installing vsftpd ansible fails, Ansible does not do a roll back
#You can make use of "rescued=0" in anisible playbook to perform a roll back


#Playscope : inside | external files
#External Files: host_vars | group_Vars
## make dir host_vars group_vars >> inventory (hosts file)
### make sure the name of the group file is same as the one in your hosts inventory file
### except your inventory file all other files will be in YML/YAML format

## mkdir host_vars & group_vars

[devops@app1 project]$ cat group_vars/webserver 
---
pkg:
  - mariadb-server
  - mariadb

srv: mariadb
rule: mysql

[devops@app1 project]$ cat hosts      (Inventory File)
[webserver]
192.168.3.6

[dbserver]
192.168.3.7

[servers:children]
webserver
dbserver

## global | playbook | host ( hosts > group_vars | host_vars )
## Roles >> External yml :: vars_files:

#Host scop    : inside invenyotu file | ext. host_vars -group_vars --> yml
#Play Scope   : inside playbook | external yml file variable file var_files
#Global scope   : ansible-playbook vars.yml -e pkg=httpd -e srv=vsftpd -e rule=mysql

#group_vars vs host_vars --> Host_vars gets precedence

Ansibe ask-password


##Static Variables : defining ( passing ) >> user defined variables
##Dynamic Variables: FACTS (Gathering Facts) of your managed node >> env. info >> Disk used free
  ## Module: setup > gather facts
  ## ansible dbserver -m setup | less     ##Fetch Facts
  ## ansible dbserver -m setup | grep swap
  ## ansible dbserver -m setup -a filter=ansible_memory_mb

[devops@app1 project]$ cat facts.yml
---
- name: collecting facts of ansible
  hosts: dbserver
  tasks: 
    - name: print facts value
      debug:
        #var: ansible_facts       ## Prints the entire Facts
        #var: ansible_memory_mb     ## is like "-a filter=ansible_memory_mb"
           var: ansible_memory_mb.swap    ## fetchs the exact ARRAY
        or var: ansible_facts.memory_mb   ansible_facts.hostname

## ansible_hostname ansible_fqdn ansible_facts >> array + list ansible_hostname 


[devops@app1 project]$ cat vars.yml 
---
- name: Play1
  hosts: webserver
  become: true
  gather_facts: true  (this setting is True by default) 
  #vars_files:
    #- var_file.yml
  vars:
    pkg: httpd
    srv: httpd
    rule: http
    ## a-z | _ | 0-9 var1 var_1 >> _vars  1var
  tasks:
    - name: Installing {{ pkg }} Package
      yum:
        name: "{{ pkg }}"
        state: latest

    - name: Starting {{ srv }} Service
      service:
        name: "{{ srv }}"
        state: started
        enabled: true

    - name: Allow {{ rule }} in Firewall
      firewalld:
        service: "{{ rule }}"
        state: enabled
        permanent: true
        immediate: true

    - name: Creating index.html file
      copy:
        content: "Hello from {{ ansible_facts.hostname }} and my IP is {{ ansible_default_ipv4.address }}"
        dest: /var/www/html/facts.html


[devops@app1 project]$ curl http://192.168.3.6/facts.html
Hello from app2 and my IP is 10.0.2.15[devops@app1 project]$ 
[devops@app1 project]$ 
[devops@app1 project]$ ansible webserver -a "cat /var/www/html/facts.html"
192.168.3.6 | CHANGED | rc=0 >>
Hello from app2 and my IP is 10.0.2.15


## If you do not want to use Facts
### Set  gather_facts: false   in the top of your playbook


## "delegate_to:" --> Delegate Task to another server

[devops@app1 project]$ cat copy_facts.yml
---
- name: Copy ansible_facts in a file
  hosts: all
  ##hosts: localhost
  tasks:
    - name: Saving Facts under /tmp firectory
      copy:
        content: "{{ ansible_facts | to_nice_json }}"
        dest: "/tmp/{{ ansible_hostname }}.json"
      delegate_to: localhost
[devops@app1 project]$ ls -ltr /tmp/app*json
-rw-r--r--. 1 root root 21247 Feb  4 08:55 /tmp/app2.json
-rw-r--r--. 1 root root 21893 Feb  4 08:55 /tmp/app3.json
-rw-r--r--. 1 root root 21285 Feb  4 08:59 /tmp/app1.json (if hosts:localhost)


 groups: wheel >> SUDO will be presoncigured for a user with "wheel" group but with Password

 Always try to have Dynamic information in your yml files:x

 [devops@app1 project]$ cat pass.yml
---
user_pass: AjjuR0ck$
[devops@app1 project]$ cat users.yml 
---
- name: Playbook for User Accounts
  hosts: all
  vars_files:
    - pass.yml
  tasks:
    - name: Adding a User Account
      user: 
        name: ajju
        state: present
        uid: 1010
        shell: /bin/sh
        groups: wheel
        password: "{{ user_pass }}"

##ansible-vault > clear text format in Digest

[devops@app1 project]$ cat pass.yml 
---
user_pass: AjjuR0ck$
[devops@app1 project]$ ansible-vault encrypt pass.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
[devops@app1 project]$ ansible-vault view pass.yml 
Vault password: 
---
user_pass: AjjuR0ck$
[devops@app1 project]$ cat pass.yml 
$ANSIBLE_VAULT;1.1;AES256
63616532353035376233316639646161343763663038376139666637323366316131386363633264
3131366461393031623639633865666238336364353136330a353633643037316264356135343734
35363361636465343930373966633361663265663762303238376437323162663264376437343166
3238383837623535650a643935366363623038316237313966666461376463643063633838323430
32396262623036653166663165333138346665303933373731343033343933656337
[devops@app1 project]$





[devops@app1 project]$ cat users.yml
---
- name: Playbook for User Accounts
  hosts: all
  vars_files:
    - pass.yml
  tasks:
    - name: Adding a User Account
      user: 
        name: ajju
        state: present
        uid: 1010
        shell: /bin/sh
        groups: wheel
        password: "{{ user_pass | password_hash('sha512') }}"


[devops@app1 project]$ ansible-playbook users.yml --ask-vault-pass
Vault password: 

PLAY [Playbook for User Accounts] ************************************************************

TASK [Gathering Facts] ***********************************************************************
ok: [192.168.3.7]
ok: [192.168.3.6]

TASK [Adding a User Account] *****************************************************************
changed: [192.168.3.7]
changed: [192.168.3.6]

PLAY RECAP ***********************************************************************************
192.168.3.6                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.3.7                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[devops@app1 project]$


## The "authorized_key" module copies the SSH public key to the remote users authorized_keys

    - name: SSH Copy Public Key                                    
      authorized_key:                                              
        user: ajju                                                 
        state: present                                             
        key: "{{ lookup('file', '/home/devops/.ssh/id_rsa.pub') }}




[devops@app1 project]$ cat .myvaultpassword.txt 
Acc1234$$

[devops@app1 project]$ ansible-playbook users.yml --vault-password-file .myvaultpassword.txt 

[devops@app1 project]$ cat ansible.cfg 
[defaults]
inventory=./hosts
remote_user=devops
ask_pass=False
vault_password_file=.myvaultpassword.txt

[privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False

[devops@app1 project]$ ansible-playbook users.yml (Running without any password make sure the passwordfile entry in the ansible.cfg is present)



Task Control:
1. Loops
2. Conditions
3. Handlers


# yum install elinks git tree apache ftp mysql -y (Yum module supports installing multiple application at a time)

# service start httpd (Service module supports a single appication execution at a time)
## service start httpd 
## service start mariadb
## service start vsftpd

# user add ajju (Useradd module supports single execution)

[devops@app1 project]$ cat loops.yml 
---
- name: Play1
  hosts: webserver
  vars:
    pkg:
    - httpd
    - vsftpd
    - mariadb
  tasks:
    - name: Install rpms
      yum:
        name:
          - elinks
          - git 
          - tree
          - httpd
          - vsftpd
          - mariadb
        state: latest

    - name: Starting Service
      service:
        name: "{{ item }}"
        state: started
      loop: "{{ pkg }}"

    - name: Adding Users
      user:
        name: "{{ item }}"
        state: present
      loop:             ## Or use "with_items:"
        - user1
        - user2
        - user3

Ansible Is a declariteve tool --> We cannot use iterate for 5 times or break, count etc




[devops@app1 project]$ cat conditions.yml
---
- name: Play2
  hosts: all
  vars:
    supported_distros:
      - CentOS
      - RedHat
      - Fedora

  tasks:
    - name: Install Apache PKG if OS is EL
      yum:
        name: httpd
        state: present
      #when: ansible_distribution == "CentOS"
      when: ansible_distribution in supported_distros   (another approach)

    - name: Install Apache PKG if OS is Ubuntu
      apt:
        name: apache2
        state: present
      when: ansible_distribution == "Ubuntu"


[devops@app1 project]$ cat hosts 
[webserver]
app2 ansible_host=192.168.3.6

[dbserver]
app3 ansible_host=192.168.3.7

[servers:children]
webserver
dbserver

[devops@app1 project]$ cat conditions.yml
---
- name: Play2
  hosts: all
  vars:
    supported_distros:
      - CentOS
      - RedHat
      - Fedora

  tasks:
    - name: Install Apache PKG if OS is EL
      yum:
        name: httpd
        state: present
      #when: ansible_distribution == "CentOS"
      #when: ansible_distribution in supported_distros
      when: ansible_hostname in groups['webserver']

    #- name: Install Apache PKG if OS is Ubuntu
    #  apt:
    #    name: apache2
    #    state: present
    #  when: ansible_distribution == "Ubuntu"

    - name: Installing Database Package
      yum:
        name: mariadb-server
        state: latest
      when: ansible_hostname in groups['dbserver']
[devops@app1 project]$ 

#Special Var (Magic Variables)
# app3 >> [dbserver] > app3

[devops@app1 project]$ cat conditions.yml
---
- name: Play2
  hosts: all
  vars:
    supported_distros:
      - CentOS
      - RedHat
      - Fedora

  tasks:
    - name: Install Apache PKG if OS is EL
      yum:
        name: httpd
        state: present
      #when: ansible_distribution == "CentOS"
      #when: ansible_distribution in supported_distros
      when: ansible_hostname in groups['webserver'] and ansible_distribution in supported_distros

      #when: ansible_free_mem >= 10000
      #when: ansible_total_mem != 15000   <,>,>=,<=, ==, "string" == True|False == 0

    #- name: Install Apache PKG if OS is Ubuntu
    #  apt:
    #    name: apache2
    #    state: present
    #  when: ansible_distribution == "Ubuntu"

    - name: Installing Database Package
      yum:
        name: mariadb-server
        state: latest
      when: inventory_hostname in groups['dbserver'] or ansible_distribution == "Ubuntu"



Tags:
 Play contains several tasks, which can be tagged: 

 - name: Install applications 
  hosts: all 
  become: true 
 tasks: 
     - name: Install vim 
 apt: 
  name=vim 
  state=present 
 tags: 
     - vim 
 - name: Install screen 
  apt: name=screen 
  state=present 
  tags: 
     - screen 

 Task with tag 'vim' will run when 'vim' is specified in tags. 

 You can specify as many tags as you want. It is useful to use tags like 'install' or 'config'. Then you can run playbook with specifying tags or skip-tags. For 

 ansible-playbook my_playbook.yml --tags "tag1,tag2" 
 ansible-playbook my_playbook.yml --tags "tag2" 
 ansible-playbook my_playbook.yml --skip-tags "tag1"



------------------------------------------------------------------------------
Day 3:

https://www.ansible.com/resources/ebooks
https://docs.ansible.com

https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html

Deploying files to managed hosts
managing large projects
using multple ansible modules for day to day operations


Loopcontrol: Iterating multiple items in the loop

- name: adding users
      user:
        name: "{{ item.name }}"
        state: absent
        password: "{{ item.pass | password_hash('sha512') }}"
      loop:
        - name: user1
          pass: redhat
        - name: user2
          pass: RedHat
        - name: user3
          pass: Password@123
      loop_control:
        label: name
        pause: 3

Task control:
1.loops
2. conditions
3. handlers


## Handlers  --> same as task but for special/specific events

Key words in ansible are Case Sensitive
Handlers are for Special Tasks
when a condition is met only then the taask should run


[devops@app1 project]$ ansible-playbook apache.yml --syntax-check



[devops@app1 project]$ cat apache.yml
---
- name: Play for WebServer
  hosts: webserver
  become: true
  remote_user: devops
  vars:
    web_pkg: httpd
    fw_pkg: firewalld
    web_srv: httpd
    fw_srv: firewalld
    fw_rule: http

  tasks:
    - name: Install Packages
      yum: 
        name: "{{ item }}"
        state: latest
      loop:
        - "{{ web_pkg }}"
        - "{{ fw_pkg }}"

    - name: Starting Services
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      loop:
        - "{{ web_srv }}"
        - "{{ fw_srv }}"

    - name: allow {{ fw_rule }} in firewalld
      firewalld:
        service: "{{ fw_rule }}"
        state: enabled

    - name: Create Document root for WebServer
      copy: 
        content: "<h1>Hey Azher Khan You are a Rock Star, I am {{ ansible_fqdn }}</h1>"
        dest: /var/www/html/custom.html

    - name: Make config changes
      replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: "index.html"
        replace: "custom.html"
      notify: Restart Apache

  handlers:
    - name: Restart Apache
      service:
        name: "{{ web_srv }}"
        state: restarted


----
ignore_errors: true
register:

force_handlers:true    (If the tasks after a handler notifier (apache change) fails, then handler will be notified and run and only then the playbook fails)
Generally if the task fails ansibleplabook stops executing anything beyond that point. And Handlers are the last tasks to run once the main tasks are completed

[devops@app1 project]$ cat apache.yml
---
- name: Play for WebServer
  hosts: webserver
  become: true
  force_handlers: true
  remote_user: devops
  vars:
    web_pkg: httpd
    fw_pkg: firewalld
    web_srv: httpd
    fw_srv: firewalld
    fw_rule: http

  tasks:
    - name: Install Packages
      yum: 
        name: "{{ item }}"
        state: latest
      loop:
        - "{{ web_pkg }}"
        - "{{ fw_pkg }}"

    - name: Starting Services
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      loop:
        - "{{ web_srv }}"
        - "{{ fw_srv }}"

    - name: allow {{ fw_rule }} in firewalld
      firewalld:
        service: "{{ fw_rule }}"
        state: enabled

    - name: Create Document root for WebServer
      copy: 
        content: "<h1>Hey Azher Khan You are a Rock Star, I am {{ ansible_fqdn }}</h1>"
        dest: /var/www/html/custom.html

    - name: Make config changes
      replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: "index.html"
        replace: "custom.html"
      notify: Restart Apache

    - name: Install hello Pkg
      yum:
        name: hello
        state: latest
      register: output
      ignore_errors: true

    - debug:
        var: output
      register: output1

    - name: Print the Output message
      debug:
        msg: "Setting up a Repo"
      when: output.failed == true and output1.changed == true

  handlers:
    - name: Restart Apache
      service:
        name: "{{ web_srv }}"
        state: restarted


[devops@app1 project]$ ansible localhost -m setup -a 'filter=ansible_eth*'

[devops@app1 project]$ ansible localhost -m setup -a "filter=*ipv4*"
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.3.5", 
            "10.0.2.15"
        ], 
        "ansible_default_ipv4": {
            "address": "10.0.2.15", 
            "alias": "eth0", 
            "broadcast": "10.0.2.255", 
            "gateway": "10.0.2.2", 
            "interface": "eth0", 
            "macaddress": "52:54:00:8a:fe:e6", 
            "mtu": 1500, 
            "netmask": "255.255.255.0", 
            "network": "10.0.2.0", 
            "type": "ether"
        }
    }, 
    "changed": false
}


## File Deployment

Static Content:
Modules: (To Manage Static content of a File)
- Copy
- REplace
- Lineinfile
- Blockinfile
- Synchronize (rsync)


Dynamic: ifcfg-eth0
10 managed nodes in cloud --> eth0 -> dhcp ->

Templates > Template Engine (Jinja2)
template file > Variables (user, facts, magic var)


[devops@app1 project]$ cat file.j2 
{# This is a Sample template (comments) ifcfg-eth0 #}
DEVICE={{ ansible_facts.default_ipv4.interface }} 
ONBOOT=yes
BOOTPROTO=none
IPADDR1={{ ansible_facts.default_ipv4.address }}
IPADDR2={{ ansible_facts.all_ipv4_addresses[1] }}
NETMASK={{ ansible_facts.default_ipv4.netmask }}
GATEWAY={{ ansible_facts.default_ipv4.gateway }}
DNS1={{ ansible_dns.nameservers[0] }}


[devops@app1 project]$ cat network.yml 
---
- name: Create J2 Template
  hosts: all
  tasks:
    - name: Generating Template
      template: 
        src: file.j2
        dest: "/tmp/ifcfg-{{ ansible_facts.default_ipv4.interface }}"


[devops@app1 project]$ ansible all -a "cat /tmp/ifcfg-eth0"
app3 | CHANGED | rc=0 >>
DEVICE=eth0 
ONBOOT=yes
BOOTPROTO=none
IPADDR1=10.0.2.15
IPADDR2=192.168.3.7
NETMASK=255.255.255.0
GATEWAY=10.0.2.2
DNS1=10.0.2.3

app2 | CHANGED | rc=0 >>
DEVICE=eth0 
ONBOOT=yes
BOOTPROTO=none
IPADDR1=10.0.2.15
IPADDR2=192.168.3.6
NETMASK=255.255.255.0
GATEWAY=10.0.2.2
DNS1=10.0.2.3


## Static Files:
#Copy
#replace
#lineinfile
#blockinfile
#synchronize

file module:
  Node1.txt >> /tmp/file/<node1|node2>.txt : file : > 1st create Dir > File Creation



Controller> Manage
Revers: Fetch


[devops@app1 project]$ cat static.yml 
---
- name: Playbook to display Static Module Manipulation
  hosts: all
  tasks:
    - name: Verify the Directory exists
      stat:
        path: /tmp/files
      register: var1

    #- debug:
    #    var: var1

    - name: Creating a Directory
      file:
        path: /tmp/files
        state: directory
        owner: devops
        group: devops
        mode: 0775
      when: var1.stat.exists == false

    - name: Creating file using copy module
      copy:
        content: "Sample file using the Copy Module in {{ ansible_facts.all_ipv4_addresses[1] }} instance "
        dest: "/tmp/files/{{ ansible_hostname }}.txt"

    - name : Copy file from controller to manage nodes
      copy:
        src: index.html
        dest: /tmp/files/

    - name: Replace the content of existing file
      replace:
        path: "/tmp/files/{{ ansible_hostname }}.txt"
        regexp: "Copy"
        replace: "MOVED"

    - name: Appending a New line in the existing file
      lineinfile:
        path: "/tmp/files/{{ ansible_hostname }}.txt"
        line: "This is the Second Line in the file using LINEINFILE module"

    - name: Adding a Set of Lines in the file
      blockinfile:
        path: "/tmp/files/{{ ansible_hostname }}.txt"
        block: |
          Using the Block Module and as you can see this is the First line
          Yep this is the second line like you didnt know
          I know i need to stop now but this is the third line
        
    - name: Add a line Before a regex
      lineinfile:
        path: "/tmp/files/{{ ansible_hostname }}.txt"
        regexp: "^Yep"
        insertbefore: "^second"
        line: "Hehehe Added more content"

    - name: Copy files from managed nodes
      fetch:
        src: "/tmp/files/{{ ansible_hostname }}.txt"
        dest: /home/devops/project/
        flat: true


[vagrant@app2 ~]$ cat /tmp/files/index.html 
<h1>Sample Azher Apache Server on Ansible Managed Node</h1>
<h2>AK Ansible Automation</h2>

[devops@app1 project]$ cat app2.txt 
Sample file using the MOVED Module in 192.168.3.6 instance 
This is the Second Line in the file using LINEINFILE module
# BEGIN ANSIBLE MANAGED BLOCK
Using the Block Module and as you can see this is the First line
Hehehe Added more content
I know i need to stop now but this is the third line
# END ANSIBLE MANAGED BLOCK
[devops@app1 project]$ cat app3.txt 
Sample file using the MOVED Module in 192.168.3.7 instance 
This is the Second Line in the file using LINEINFILE module
# BEGIN ANSIBLE MANAGED BLOCK
Using the Block Module and as you can see this is the First line
Hehehe Added more content
I know i need to stop now but this is the third line
# END ANSIBLE MANAGED BLOCK
[devops@app1 project]$



## Managing LArege Project:
1. Host Patterns (regexp) | hosts:
2. Dynamic Inventory
3. Parallellism
4. Large Project (task | var | playbook)


[devops@app1 project]$ cat inventory 
server1
server2
[web]
node1.example.com
node2.example.com
node3.example.com
node4.example.com

[db]
node2.example.com
node[5:9].example.com

[ip]
172.19.2.[100:105]
172.19.[1:3].[20:25]

[nodes:children]
web
db
ip


Ansible <host-pattern>

by default ansible refers to the hosts file mentioned within ansible.cfg
if you give the -i option then that file will be chosen instead

##hosts: all|ungrouped|'*'|web,db|node1,node2,node3|'web,!node1'|'web,&db'

ansible "*" --list-hosts -i inventory    (same as all)

ansible all --list-hosts -i inventory

ansible ip --list-hosts -i inventory

ansible ungrouped --list-hosts -i inventory    (ungrouped hosts)
  hosts (2): 
    server1
    server2

ansible 'web,!node1.example.com' --list-hosts -i inventory  (web except node1)
  hosts (3):
    node2.example.com
    node3.example.com
    node4.example.com

 ansible 'web,&db' --list-hosts -i inventory    (common in web & db)
  hosts (1):
    node2.example.com



#Dynamic Inventory
#Cludb | Virt (aPP Scaling Events | out - in)
Provider available (CLOUD: AWS| AZURE | GCP| OPENSTACK | OpenShift | OCI)
Provieer (LDAP | ADDS | IPA | IDM)
Provider (Monitoring System: Nagios)
PRovider (Virt Provider: VMWare | RHEV)


Ansible all --list-hosts > #!/bin/python3 >> Provider >> Fetch Host
Credentials to (lookup) >> aws ec2 accesskey secretkey| region | AZ zone
ENV VAR
export AWS_ACCESS_KEY=00048545808084584004
export AWS_SECRET_KEY=ksdndfnfdnjfnjkvklnnkvkl
sh dynamic/ec2.py

On Run time the host information is pulled out
Like FACTS, will be fetched during Run Time


group (vars for host) metadata key=value (host | var)

ANSIBLE CODE ENVINE > PRocess (absible tower) >> redis

Inventory: Script must have
1. JSON.    (as output)
2. --list
3. --host

python dynamic/ec2.py  --list >> host_infor provider
python dynamic/ec2.py  --host <hostname> >> variable for this host

[devops@app1 project]$ ansible-inventory --list -i hosts
{
    "_meta": {
        "hostvars": {
            "app2": {
                "ansible_host": "192.168.3.6", 
                "pkg": [
                    "mariadb-server", 
                    "mariadb"
                ], 
                "rule": "mysql", 
                "srv": "mariadb"
            }, 
            "app3": {
                "ansible_host": "192.168.3.7"
            }
        }
    }, 
    "all": {
        "children": [
            "servers", 
            "ungrouped"
        ]
    }, 
    "dbserver": {
        "hosts": [
            "app3"
        ]
    }, 
    "servers": {
        "children": [
            "dbserver", 
            "webserver"
        ]
    }, 
    "webserver": {
        "hosts": [
            "app2"
        ]
    }
}

[devops@app1 project]$ ansible-inventory --host app2
{
    "ansible_host": "192.168.3.6", 
    "pkg": [
        "mariadb-server", 
        "mariadb"
    ], 
    "rule": "mysql", 
    "srv": "mariadb"
}

[devops@app1 project]$ ansible-inventory --yaml --list -i hosts
all:
  children:
    servers:
      children:
        dbserver:
          hosts:
            app3:
              ansible_host: 192.168.3.7
        webserver:
          hosts:
            app2:
              ansible_host: 192.168.3.6
              pkg:
              - mariadb-server
              - mariadb
              rule: mysql
              srv: mariadb
    ungrouped: {}

[devops@app1 project]$ ansible all --list-hosts -v
Using /home/devops/project/ansible.cfg as config file
[WARNING]:  * Failed to parse /home/devops/project/dynamic/ec2.py with script plugin: Inventory
script (/home/devops/project/dynamic/ec2.py) had an execution error: Traceback (most recent call
last):   File "/home/devops/project/dynamic/ec2.py", line 164, in <module>     import boto
ImportError: No module named boto

[WARNING]:  * Failed to parse /home/devops/project/dynamic/ec2.py with ini plugin:
/home/devops/project/dynamic/ec2.py:3: Error parsing host definition ''''': No closing quotation

[WARNING]: Unable to parse /home/devops/project/dynamic/ec2.py as an inventory source

[WARNING]: Unable to parse /home/devops/project/dynamic as an inventory source

[WARNING]: No inventory was parsed, only implicit localhost is available

[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit
localhost does not match 'all'

  hosts (0):

[devops@app1 project]$ cat ansible.cfg 
[defaults]
#inventory=./hosts
inventory=dynamic
remote_user=devops
ask_pass=False
vault_password_file=.myvaultpassword.txt

[privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False

[devops@app1 project]$ ll dynamic/
total 72
-rwxrwxrwx. 1 devops devops 73130 Feb  5 09:42 ec2.py
[devops@app1 project]$ wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py

https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#inventory-script-example-aws-ec2


Serial Exectuion: Run on one node first once it compltes successufly then run on the other nodes

[devops@app1 project]$ vim static.yml 
---
  hosts: all
  serial: 1    (run one by one)


[devops@app1 project]$ cat ansible.cfg 
..
vault_password_file=.myvaultpassword.txt
forks=1    (it can be more than 1, 5 is default)

how do we decide the number of forks ?
Depends on the resources the ansible Controller Node has
Also on the Manage node infra we have
If the managed nodes are a network device then it takes time for the network devoces to execute tasks, so we need to keep that in mind 

## Large Projects (YAML)
yaml >> vars | tasks (Vars_) >> vars_files: ext.yml
yaml >> variblw
yML << Tasks
Call these files >? maste rplaybook

var | tasks
hosts
call
1. Dybamically call thse. files: Include files    ( Loads files one by one and executes)   --> Better Performance >> include_*
      --> Tasks vars roles playbooks
      --> This is best to use on Production Environments for Performance
playbook >> 4 yaml file

2. Static : Import file      (Validation|Syntax check --> Loads all files and then runs)
      --> Import tasks roles plybooks
      --> Good for Validation



[devops@app1 project]$ cat http_vars.yml
---
web_pkg: httpd
web_srv: httpd
web_rule: http


[devops@app1 project]$ cat http_tasks.yml
---
- name: Installing {{ web_pkg }}
  yum:
    name: "{{ web_pkg }}"
    state: present

- name: starting {{ web_srv }}
  service:
    name: "{{ web_srv }}"
    state: started

- name: Allow {{ web_rule }} in firewall
  firewalld:
    service: "{{ web_rule }}"
    state: enabled


[devops@app1 project]$ cat fw_vars.yml
---
fw_pkg: firewalld
fw_srv: firewalld


[devops@app1 project]$ cat fw_tasks.yml
---
- name: Setup {{ fw_pkg }}
  yum:
    name: "{{ fw_pkg }}"
    state: latest

- name: Starting {{ fw_srv }}
  service:
    name: "{{ fw_srv }}"
    state: started
  

[devops@app1 project]$ cat master.yml 
---
- name: Master Playbook
  hosts: webserver
  become: true
  vars_files:
    - fw_vars.yml
  tasks:
    - include_vars: http_vars.yml

    - include_tasks: http_tasks.yml

    - import_tasks: fw_tasks.yml



[devops@app1 project]$ cat app.yml 
---
- import_playbook: static.yml

- import_playbook: network.yml

- import_playbook: master.yml


Ansible Tracks the execution for Run time
The Tasks execution is not tracketed within any file






------------------------------------------------------------------------------
Day 4:

simplifying playbooks  with roles
troublshooting ansible
automating administration tasks

1, Global scope
2. plat scope
3. host scope 1. hostvars host_vars

Facts
Reguster
Magic Variable (hostvars) inventory_hostname}
when: ansible_hostname in group['webserverxc ']


can we have the list of 
from Azher Khan to Host (privately):
modules we can run as the adhoc commands ?
from Azher Khan to Host (privately):
If there was no dependency on the (tasks/module for other tasks/modules) then we can run it adhoc


[devops@app1 project]$ cat hosts.yml
---
- name: Play1
  hosts: all
  tasks:
    - template: src=hosts.j2 dest=/tmp/hosts

    #- template:
    #   src: hosts.j2
    #   dest: /tmp/hosts


For loops in Jinja2 they should be in a single {} curly braces and must have an endfor loop

[devops@app1 project]$ cat hosts.j2 
{# This is sample hosts template #}
# Comment line

{% for i in groups['all'] %}
{{ hostvars[i]['ansible_facts']['default_ipv4']['address'] }}  {{ hostvars[i]['ansible_facts']['fqdn'] }}   {{ hostvars[i]['ansible_facts']['hostname'] }}
{% endfor %}
[devops@app1 project]$



[vagrant@app3 ~]$ cat /tmp/hosts
# Comment line
10.0.2.15  app2.dev   app2
10.0.2.15  app3.dev   app3

[vagrant@app2 ~]$ cat /tmp/hosts 
# Comment line
10.0.2.15  app2.dev   app2
10.0.2.15  app3.dev   app3


## Ansible Roles: Generic way of ansible Infra as a code

##Role> Skeleton (dir structure)
##Playbook > vars tasks staticfiles templates handlers


Directory Structure > Role DB>>
1. Vars
2. Tasks
3. Handlers
4. Files
5. Templates
6. Meta


#Reusable Share Standards >>org.private  Public (Repository >> Ansible Galaxy)
#### github >> DockerHub
#Playbook:
- hosts: <host>
  become: true
  roles:
    -db-role


[devops@app1 roles]$ ansible-galaxy init azher.mysql
- Role azher.mysql was created successfully
[devops@app1 roles]$ tree azher.mysql/
azher.mysql/
|-- defaults        --> Variables (basic defaults)
|   `-- main.yml
|-- files           --> Static Files (copy, synchronize)
|-- handlers          --> Special Tasks/ Handlers
|   `-- main.yml
|-- meta          --> Metdata (Author | License | Min version)
|   `-- main.yml
|-- README.md         --> Pre-Requisite --> readme.txt --> how to use
|-- tasks           --> Tasks Files/Code
|   `-- main.yml
|-- templates         --> Jinja2 teamplates (By default the playbook code will look into this location for the files)
|-- tests           --> Tests Inventory|Playbook
|   |-- inventory
|   `-- test.yml
`-- vars          --> Variables (this overrides basic defaults)
    `-- main.yml

8 directories, 8 files
[devops@app1 roles]$ 

MAIN.YML   --> Is the Master files, which have full control


[devops@app1 project]$ ansible-galaxy list
# /home/devops/project/roles
- azher.apache, (unknown version)
- azher.mysql, (unknown version)


[devops@app1 project]$ ansible-galaxy remove azher.apache
- successfully removed azher.apache




[devops@app1 roles]$ cat azher.mysql/tasks/main.yml 
---
# tasks file for azher.mysql
- name: Install {{ db_pkg }} Packages 
  yum:
    name: "{{ db_pkg }}"
    state: present
  notify: restart_db

- name: Starting {{ db_srv }} Service
  service:
    name: "{{ db_srv }}"
    state: started
    enabled: yes

- name: Copy template file for MOTD
  template:
    src: motd.j2
    dest: /etc/motd
    owner: root
    group: root
    mode: 0644

# 1. Remove Test DB
# 2. Disable Anonymous Access
# 3. Set Password for Root Login
# 4. Sample DB for a particular user
# 5. non-root user harry (Privilege to access Sample DB)

- name: Removing Test DB
  mysql_db:
    name: test
    state: absent
  ignore_errors: true

- name: Disable anonymous access to DB
  mysql_user:
    name: ''
    state: absent
  ignore_errors: true

- name: Setting root user password for DB
  mysql_user:
    name: root
    state: present
    password: "{{ root_pass }}"
  ignore_errors: true

- name: Create Database for User
  mysql_db:
    name: ansible_db
    state: present
    login_user: root
    login_password: "{{ root_pass }}"

- name: Adding non-root user and assign privileges
  mysql_user:
    name: harry
    state: present
    password: "{{ usr_pass }}"
    login_user: root
    login_password: "{{ root_pass }}"
    priv: 'ansible_db.*:ALL' 
    #*.* : ALL  C U R D


[devops@app1 roles]$ cat azher.mysql/vars/main.yml 
---
# vars file for azher.mysql
db_pkg: 
  - mariadb-server
  - mariadb
  - MySQL-python

db_srv: mariadb
root_pass: AjjuR0ck$
usr_pass: redhat

admin_mail: azher.khan@domain.com
#vars_files: | include_vars:


[devops@app1 roles]$ cat azher.mysql/templates/motd.j2
{#Sample motd template#}
Welcome to Database Server {{ ansible_hostname }}
Unauthorized access is Prohibited

NODE FQDN: {{ ansible_fqdn }}
NODE IP  : {{ ansible_facts.default_ipv4.address }}
NODE OS  : {{ ansible_distribution }}

For any incidents please write to admin at {{ admin_mail }}


[devops@app1 roles]$ cat azher.mysql/handlers/main.yml 
---
# handlers file for azher.mysql
- name: restart_db
  service:
    name: "{{ db_srv }}"
    state: restarted
[devops@app1 roles]$ 

[devops@app1 roles]$ cat  azher.mysql/meta/main.yml  | head -10
galaxy_info:
  author: Azher Khan
  description: TEST CPE Engineering Team Database Server
  company: Oracle



Ansible gives prioirty to Roles then the Task in a playbook in such a case we need to use "pre_tasks"



[devops@app1 project]$ cat azmysql.yml
---
- name: Playbook to Setup MySQL Database 
  hosts: app3
  become: true
  pre_tasks:
    - name: Removing existing DB directory
      file:
        path: /var/lib/mysql
        state: absent
      ignore_errors: true

    - service: name=mariadb state=stopped
      ignore_errors: true

    - yum: name=mariadb-server state=absent
      ignore_errors: true
  roles:
    - azher.mysql


 2020-02-06 12:21:45 ⌚  azhekhan-mac in ~/vagrant_dev/v_ansible_centos7
○ → ssh vagrant@192.168.3.7
Last login: Thu Feb  6 06:51:09 2020 from 192.168.3.1


Welcome to Database Server app3
Unauthorized access is Prohibited

NODE FQDN: app3.dev
NODE IP  : 10.0.2.15
NODE OS  : CentOS



For any incidents please write to admin at azher.khan@domain.com
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[vagrant@app3 ~]$

[vagrant@app3 ~]$ mysql -uharry -predhat
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 5
Server version: 5.5.64-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| ansible_db         |
+--------------------+
2 rows in set (0.00 sec)

MariaDB [(none)]> 


Contributing Your Own Role

(Page 160). 

Manually Enabling SSH Multiplexing

(Page 162). 

[defaults] gathering = smart

Setting the gathering configuration option to “smart” in ansible.cfg tells Ansible to use smart gathering. This means that Ansible will only gather facts if they are not present in the cache or if the cache has expired.

(Page 168). 

[devops@app1 project]$ cat hosts.yml 
---
- name: Play1
  hosts: all
  tasks:
    - template: src=hosts.j2 dest=/tmp/hosts

    #- template:
    #   src: hosts.j2
    #   dest: /tmp/hosts
    - command: hostname
      changed_when: false


[devops@app1 project]$ ansible-galaxy install geerlingguy.nginx
- downloading role 'nginx', owned by geerlingguy
- downloading role from https://github.com/geerlingguy/ansible-role-nginx/archive/2.7.0.tar.gz
- extracting geerlingguy.nginx to /home/devops/project/roles/geerlingguy.nginx
- geerlingguy.nginx (2.7.0) was installed successfully
[devops@app1 project]$ ansible-galaxy list
# /home/devops/project/roles
- azher.mysql, (unknown version)
- geerlingguy.nginx, 2.7.0

[devops@app1 geerlingguy.nginx]$ tree
.
|-- defaults
|   `-- main.yml
|-- handlers
|   `-- main.yml
|-- LICENSE
|-- meta
|   `-- main.yml
|-- molecule
|   `-- default
|       |-- molecule.yml
|       |-- playbook.yml
|       `-- yaml-lint.yml
|-- README.md
|-- tasks
|   |-- main.yml
|   |-- setup-Archlinux.yml
|   |-- setup-Debian.yml
|   |-- setup-FreeBSD.yml
|   |-- setup-OpenBSD.yml
|   |-- setup-RedHat.yml
|   |-- setup-Ubuntu.yml
|   `-- vhosts.yml
|-- templates
|   |-- nginx.conf.j2
|   |-- nginx.repo.j2
|   `-- vhost.j2
`-- vars
    |-- Archlinux.yml
    |-- Debian.yml
    |-- FreeBSD.yml
    |-- OpenBSD.yml
    `-- RedHat.yml

8 directories, 24 files
[devops@app1 geerlingguy.nginx]$ 

[devops@app1 project]$ cat nginx.yml
---
- name: Play for NGINX from Ansible Galaxy
  hosts: webserver
  become: true
  pre_tasks:
    - service: name=httpd state=stopped

  roles:
    - geerlingguy.nginx

  post_tasks:
    - debug: msg="NGINX Installed Successfully"


Review the README file for all ROLES available in the Ansible Galaxy
The best way to read the Playbooks is to REview the README file and understand the configuration you need to tweak to make the role work
You can choose to go throug the playbooks but that would be complex




Creteed Role:
Install Role: Pubilic Repository
Insatall Role:
1 Ansible
2 HTTP (roles)
3 GIT (public private)
4 Local system (export tar file)


[devops@app1 project]$ cat req.yml 
---
- src: https://github.com/harpreetsingh123/role2.git
  name: azher.role1
  scm: git
  version: master

##- src: https://github.com/harpreetsingh123/role2.git
##  name: harpreet.role2
##  scm: git
##  version: master
##- src: file:///tmp/mysql-role.tar
##  name: mariadb.role


[devops@app1 project]$ ansible-galaxy install -r req.yml -p roles/
- extracting azher.role1 to /home/devops/project/roles/azher.role1
- azher.role1 (master) was installed successfully
[devops@app1 project]$


[devops@app1 project]$ ansible-galaxy list
# /home/devops/project/roles
- azher.mysql, (unknown version)
- geerlingguy.nginx, 2.7.0
- azher.role1, master


Create 
Install Ansible Galaxy
Install 3rd Part repo (git, http, local)
##Red Hat distribution can have certified roles, 
  Install rpm on controller roles >> 5-7 Kdump, selinux, network, ntp
  ##RHEL CENTOS FEDORA
  [devops@app1 project]$ sudo yum install rhel-system-roles -y  (INSTALL ONLY on Ansible Controller Node)


[devops@app1 project]$ cat ansible.cfg | grep roles
roles_path=roles:/usr/share/ansible/roles


[devops@app1 project]$ ansible-galaxy list
# /home/devops/project/roles
- azher.mysql, (unknown version)
- geerlingguy.nginx, 2.7.0
- azher.role1, master
# /usr/share/ansible/roles
- linux-system-roles.kdump, (unknown version)
- linux-system-roles.network, (unknown version)
- linux-system-roles.postfix, (unknown version)
- linux-system-roles.selinux, (unknown version)
- linux-system-roles.timesync, (unknown version)
- rhel-system-roles.kdump, (unknown version)
- rhel-system-roles.network, (unknown version)
- rhel-system-roles.postfix, (unknown version)
- rhel-system-roles.selinux, (unknown version)
- rhel-system-roles.timesync, (unknown version)
[devops@app1 project]$


- hosts: targets
  vars:
    timesync_ntp_servers:
      - hostname: foo.example.com
        iburst: yes
      - hostname: bar.example.com
        iburst: yes
      - hostname: baz.example.com
        iburst: yes
  roles:
    - rhel-system-roles.timesyncs


cat ansible.cfg  | grep log
log_path=ansible.log 


## logrotation
#Service (process)
#Troubleshooting
##Debug mode

verbosity levels: 
1 -v     : Std output task execution
2 -vv    : Std output and Input
3 -vvv   : Std output/input + connection related info (ssh)
4 -vvvv  : Std IN/OUT, Connection + Module (copy)


Can we run different playbooks with different users ?
Yes, use option -u or in the playbook you can mention the user name


[devops@app1 project]$ ansible-playbook nginx.yml  --list-tasks


[devops@app1 project]$ ansible-playbook nginx.yml  --start-at-task="Copy nginx configuration in place."

[devops@app1 project]$ ansible-playbook nginx.yml  --step   (Interaction prompt for input confirmation)

[devops@app1 project]$ ansible-playbook -C nginx.yml   (DRY Run)



[devops@app1 project]$ cat hosts.yml 
---
- name: Play1
  hosts: all
  tasks:
    - template: src=hosts.j2 dest=/tmp/hosts

    #- template:
    #   src: hosts.j2
    #   dest: /tmp/hosts
    - command: hostname
      changed_when: false

    - debug:
        msg: "Hello from Ansible"
        verbosity: 4

Ansible Best PRactices:
https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#playbooks-best-practices


cat tags.xml
---
- name: playbook for tags
  hosts: all
  become: true
  #pre_tasks:
  tasks:
    - yum: name=httpd state=installed
      tags: web
    - service: name=nginx state=stopped
      tags: web
    - service: name=httpd state=started
      tags: web
    - yum: name=mariadb-server state=latest
      tags: db
    - service: name=mariadb state=started
      tags: db

ansible-playbook tags.xml --tags web
ansible-playbook tags.xml --skip-tags web
ansible-playbook tags.yml --list-tasks


Power Off one Virtual machine >> Attached new disk (2 GB) >> power on

[devops@app1 project]$ ansible app2 -a "init 0"
app2 | UNREACHABLE! => {
    "changed": false, 
    "msg": "Failed to connect to the host via ssh: Shared connection to 192.168.3.6 closed.", 
    "unreachable": true
}

[devops@app1 project]$ ansible app2 -a lsblk
app2 | CHANGED | rc=0 >>
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  40G  0 disk 
`-sda1   8:1    0  40G  0 part /
sdb      8:16   0   2G  0 disk 

Partitions
LVM
Disk >> Partition >> PV >> VG >> LV
  Partition (resize) < Filesystem < ?Mounting


[devops@app1 project]$ #ansible app2 -a "sudo yum install -y lvm2 "



[devops@app1 project]$ cat lsblk.yml 
---
- name: Play for LVM
  hosts: webserver
  become: true
  tasks:
  #Flow>Partition>VG(PV)>LV>FS>Mounting
    - name: Creating a Partition #SDB
      parted:
        device: /dev/sdb
        number: 1
        part_end: 1GiB
        state: present

    - name: Creating a Volume Group
      lvg:
        pvs: /dev/sdb1
        state: present
        vg: testvg

    - name: Creating a Logical Volume from Volume Group
      lvol:
        vg: testvg
        lv: testlv
        size: 500M
        state: present


    - name: Assigning a File System to Logical Volume
      filesystem:
        device: /dev/testvg/testlv
        fstype: ext4

    - name: Creating Mount Point
      file:
        path: /mnt/volume1
        state: directory

    - name: Mounting the Filesystem under /mnt/volume1
      mount: 
        path: /mnt/volume1
        src: /dev/testvg/testlv
        fstype: ext4
        state: mounted

        #/etc/fstab > /dev/testvg/testlv /mnt/volume1 ext4 defaults 0 0


[devops@app1 project]$ ansible app2 -a "cat /etc/fstab"
app2 | CHANGED | rc=0 >>

#
# /etc/fstab
# Created by anaconda on Sat Jun  1 17:13:31 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=8ac075e3-1124-4bb6-bef7-a6811bf8b870 /                       xfs     defaults        0 0
/swapfile none swap defaults 0 0
/dev/testvg/testlv /mnt/volume1 ext4 defaults 0 0
        

[vagrant@app2 ~]$ df -kh
Filesystem                 Size  Used Avail Use% Mounted on
/dev/sda1                   40G  4.1G   36G  11% /
devtmpfs                   111M     0  111M   0% /dev
tmpfs                      118M     0  118M   0% /dev/shm
tmpfs                      118M  4.5M  114M   4% /run
tmpfs                      118M     0  118M   0% /sys/fs/cgroup
/dev/mapper/testvg-testlv  477M  2.3M  445M   1% /mnt/volume1
tmpfs                       24M     0   24M   0% /run/user/1000
