# How to build runtime environment for overseas

## System Requirement
1. Hardware: any hardware can run ubuntu 18.04
2. OS: ubuntu 18.04 (Server edition is recommended)
3. Software:  
    1. nginx
    2. php
    3. certbot
    4. mariadb
    5. ghostscript
    6. fail2ban
    7. portsentry
    8. supervisor
    8. rsync
    9. docker
    10. ufw
    
## Hardware Configuration
1. Storage:
    1. physical: HDD * 8, SSD * 2  
    ![Physical Disk List](https://github.com/0verseas/runtime-builder/blob/master/images/PDs.png)
    
    2. virtual (RAID): VD_HDD(HDD * 8), VD_SSD(SSD * 2)  
    ![Virtual Disk List](https://github.com/0verseas/runtime-builder/blob/master/images/VDs.png)
    ![VD_HDD config](https://github.com/0verseas/runtime-builder/blob/master/images/VD_HDD_config.jpg)
    ![VD_SSD config](https://github.com/0verseas/runtime-builder/blob/master/images/VD_SSD_config.jpg)
    
## OS Installation Hint
1. Set language to `English` to avoid font issues
2. Set Location to `Asia/Taiwan`
3. Set Locale to `en_US.UTF-8`
4. Set keyboard to `English (US)`
    ![language setting gif](https://github.com/0verseas/runtime-builder/blob/master/images/system-install-choose-language.gif)

5. Check timezone is `Asis/Taipei`
6. system install on disk `VD_HDD`
7. Install OpenSSH Server in predefined software
    ![install predefined software](https://github.com/0verseas/runtime-builder/blob/master/images/system-install-predefined-software.png)

## Software Configuration
### Nginx + Certbot
1. The traditional way
    * certbot:
        - Get certificates use [webroot](https://certbot.eff.org/docs/using.html#webroot)
    * Nginx:  
        [SSL Configuration Generator by Mozilla](https://mozilla.github.io/server-side-tls/ssl-config-generator/) (modern profile is recommended)
2. The modern way
    - https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx.html
3. Add config below to `/etc/crontab` for autorenew certificates

    ```
    30 2 * * 1 root /usr/bin/certbot renew
    35 2 * * 1 root /etc/init.d/nginx reload
    ```

### PHP

### Supervisor
Install for [Laravel Queue Worker](https://laravel.com/docs/5.7/queues#supervisor-configuration)

### Database
1. MariaDB Audit plugin  
    add config below to `/etc/mysql/mariadb.conf.d/50-server.cnf`  
    ``` config
    # for server / query audit
    plugin_load=server_audit=server_audit.so
    
    #
    # * MariaDB Audit Plugin
    #
    # https://mariadb.com/kb/en/library/mariadb-audit-plugin-log-settings/
    #
    # for server / query audit

    server_audit_logging=on

    # to log all queries, or to log only connect and table changes?
    # https://mariadb.com/kb/en/library/mariadb-audit-plugin-log-settings/#logging-query-events
    server_audit_events=CONNECT,QUERY,TABLE

    server_audit_file_path=/var/log/mysql/server_audit.log

    # log file size 1G=1000000000
    # now set to 100M
    server_audit_file_rotate_size=100000000

    # set to 0 means never rotate (0-999)
    # now set 999, size will be 100M*999=100G
    server_audit_file_rotations=999

    # set max logging query length to 10M per query
    server_audit_query_log_limit=10485760
    ```
2. fd limit(open files limit)  
    1. add config below to `/etc/mysql/mariadb.conf.d/50-server.cnf`  
        ```config
        #
        # Open File Limit
        #
        open_files_limit = 65535
        ```
    
    2. add config below to `/etc/security/limits.conf`  
        ```config
        mysql            soft    nofile          65535
        mysql            hard    nofile          65535
        ```
3. automysqlbackup
    1. `apt install automysqlbackup`
    2. Review settings in `/etc/default/automysqlbackup`.
        - `DBNAMES`
        - `BACKUPDIR`
        - `MDBNAMES`
        - `DBEXCLUDE`

### fail2ban
- `apt install fail2ban`
- it's ok to use default settings

### portsentry
1. `apt install portsentry`
2. Review settings in `/etc/portsentry/portsentry.conf`
    - `TCP_PORTS` / `UDP_PORTS`
    - `ADVANCED_EXCLUDE_TCP` / `ADVANCED_EXCLUDE_UDP`
3. Make sure settings below are enabled
    - `BLOCK_UDP="1"` / `BLOCK_TCP="1"`
    - `SCAN_TRIGGER="1"` to reduce false alarm
4. Use better `KILL_ROUTE`. Find this line and enable to use iptables setting instead of default rule
    ```
    KILL_ROUTE="/sbin/iptables -I INPUT -s $TARGET$ -j DROP && /sbin/iptables -I INPUT -s $TARGET$ -m limit --limit 3/minute --limit-burst 5 -j LOG --log-level DEBUG --log-prefix 'Portsentry: dropping: '"
    ```

### docker

### Disk Mount
0. make sure VD_SSD is formatted in ext4 disk format
1. create directory at `/mnt/VD_SSD`
1. `sudo fdisk -l` check what device path is for VD_SSD
2. `blkid (VD_SSD's device path with partition number)` to get UUID of VD_SSD's partition
3. add `UUID=(UUID get from previous step) /mnt/VD_SSD     ext4    errors=remount-ro 0       1` to `/etc/fstab`

### rsync (SSD -> HDD)
add below to `/etc/crontab`  
```
*/5 * * * * root rsync --archive --delete --delete-delay --delay-updates /mnt/VD_SSD /data/
```

### ufw (Uncomplicated Firewall)
0. Ubuntu has built-in ufw. You can use `sudo ufw status` to check status and rule of ufw.
1. To make sure your connection after enabling ufw, **`sudo ufw allow ssh`** is necessary.
2. `sudo ufw allow 80`, `sudo ufw allow 443` and any rule you need.
3. If setting is ready, you can type in `sudo ufw enable`.

## Example Config Files
all examples are in config-examples folder
