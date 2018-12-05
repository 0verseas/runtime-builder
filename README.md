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
    
## Hardware Configuration
1. Storage:
    1. physical: HDD * 8, SSD * 2  
    ![Physical Disk List](https://github.com/0verseas/runtime-builder/blob/master/images/PDs.png)
    
    2. virtual (RAID): VD_HDD, VD_SSD  
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
