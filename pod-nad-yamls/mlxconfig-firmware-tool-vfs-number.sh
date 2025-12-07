## mlxconfig is part of mft: https://network.nvidia.com/products/adapter-software/firmware-tools/

[root@ip-10-0-58-16 ~]# wget https://www.mellanox.com/downloads/MFT/mft-4.30.1-113-x86_64-rpm.tgz
--2025-05-23 17:48:30--  https://www.mellanox.com/downloads/MFT/mft-4.30.1-113-x86_64-rpm.tgz
Resolving www.mellanox.com (www.mellanox.com)... 23.212.249.207, 23.212.249.213
Connecting to www.mellanox.com (www.mellanox.com)|23.212.249.207|:443... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://content.mellanox.com/MFT/mft-4.30.1-113-x86_64-rpm.tgz [following]
--2025-05-23 17:48:31--  https://content.mellanox.com/MFT/mft-4.30.1-113-x86_64-rpm.tgz
Resolving content.mellanox.com (content.mellanox.com)... 107.178.241.102
Connecting to content.mellanox.com (content.mellanox.com)|107.178.241.102|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 72012729 (69M) [application/gzip]
Saving to: ‘mft-4.30.1-113-x86_64-rpm.tgz’

mft-4.30.1-113-x86_64-rpm.tgz                  100%[===================================================================================================>]  68.68M   863KB/s    in 81s

2025-05-23 17:49:53 (864 KB/s) - ‘mft-4.30.1-113-x86_64-rpm.tgz’ saved [72012729/72012729]

[root@ip-10-0-58-16 ~]# tar xvf mft-4.30.1-113-x86_64-rpm.tgz
mft-4.30.1-113-x86_64-rpm/LICENSE.txt
mft-4.30.1-113-x86_64-rpm/RPMS/
mft-4.30.1-113-x86_64-rpm/RPMS/mft-4.30.1-113.x86_64.rpm
mft-4.30.1-113-x86_64-rpm/RPMS/mft-oem-4.30.1-113.x86_64.rpm
mft-4.30.1-113-x86_64-rpm/RPMS/mft-autocomplete-4.30.1-113.x86_64.rpm
mft-4.30.1-113-x86_64-rpm/RPMS/mft-pcap-4.30.1-113.x86_64.rpm
mft-4.30.1-113-x86_64-rpm/SDEBS/
mft-4.30.1-113-x86_64-rpm/SDEBS/kernel-mft-dkms_4.30.1-113_all.deb
mft-4.30.1-113-x86_64-rpm/SRPMS/
mft-4.30.1-113-x86_64-rpm/SRPMS/kernel-mft-4.30.1-113.src.rpm
mft-4.30.1-113-x86_64-rpm/install.sh
mft-4.30.1-113-x86_64-rpm/old-mft-uninstall.sh
mft-4.30.1-113-x86_64-rpm/uninstall.sh
[root@ip-10-0-58-16 ~]#

[root@ip-10-0-58-16 ~]# cd mft-4.30.1-113-x86_64-rpm
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# ls

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# yum install gcc rpm-build make -y
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# yum install elfutils-libelf-devel perl -y
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# ./install.sh
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# yum install kernel-devel-6.1.132-147.221.amzn2023.x86_64
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# ./install.sh
-I- Removing any old MFT file if exists...
-I- Building the MFT kernel binary RPM...
-I- Installing the MFT RPMs...
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:kernel-mft-4.30.1-6.1.132_147.221################################# [100%]
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:mft-4.30.1-113                   ################################# [100%]
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:mft-autocomplete-4.30.1-113      ################################# [100%]
-I- In order to start mst, please run "mst start".
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# lspci | grep MT2910
0000:05:00.0 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
0000:05:00.1 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
0001:05:00.0 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
0001:05:00.1 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 05:00.0 q | grep NUM_OF_VFS
        NUM_OF_VFS                                  16
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 05:00.0 set NUM_OF_VFS=127

Device #1:
----------

Device type:        ConnectX7
Name:               MCX755106AS-HEA_Ax
Description:        NVIDIA ConnectX-7 HHHL Adapter Card; 200GbE (default mode) / NDR200 IB; Dual-port QSFP112; PCIe 5.0 x16 with x16 PCIe extension option; Crypto Disabled; Secure Boot Enabled
Device:             05:00.0

Configurations:                                          Next Boot       New
        NUM_OF_VFS                                  16                   127

 Apply new Configuration? (y/n) [n] : y
Applying... Done!
-I- Please reboot machine to load new configurations.
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 05:00.1 q | grep NUM_OF_VFS
        NUM_OF_VFS                                  127
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 0000:05:00.0 q | grep NUM_OF_VFS
        NUM_OF_VFS                                  127
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 0000:05:00.1 q | grep NUM_OF_VFS
        NUM_OF_VFS                                  127
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 0001:05:00.0 q | grep NUM_OF_VFS
        NUM_OF_VFS                                  16
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 0001:05:00.0 set NUM_OF_VFS=127

Device #1:
----------

Device type:        ConnectX7
Name:               MCX755106AS-HEA_Ax
Description:        NVIDIA ConnectX-7 HHHL Adapter Card; 200GbE (default mode) / NDR200 IB; Dual-port QSFP112; PCIe 5.0 x16 with x16 PCIe extension option; Crypto Disabled; Secure Boot Enabled
Device:             0001:05:00.0

Configurations:                                          Next Boot       New
        NUM_OF_VFS                                  16                   127

 Apply new Configuration? (y/n) [n] : y
Applying... Done!
-I- Please reboot machine to load new configurations.
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]#

[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# mlxconfig -d 0001:05:00.1 q | grep NUM_OF_VFS
        NUM_OF_VFS                                  127
[root@ip-10-0-58-16 mft-4.30.1-113-x86_64-rpm]# sudo shutdown -r now