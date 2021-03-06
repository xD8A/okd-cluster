SET VM=okd-hub

SET CPU_COUNT=1
SET RAM_SIZE=4096
SET DISK_SIZE=81920

SET INTNET_NAME=intnet
rem TODO: Select bridge interface (see: VBoxManage list bridgeifs)
SET BRIDGE_NAME="Intel(R) Dual Band Wireless-AC 3165"

SET ISO_PATH="D:\Repo\centos\7\isos\CentOS-7-x86_64-DVD-2009.iso"
SET DISK_PATH="%VBOX_USER_HOME%\%VM%\%VM%.vdi"
SET KS_PATH="..\unattended\hub_ks.cfg"
SET POST_PATH="..\unattended\dummy_postinstall.sh"

IF NOT EXIST "%VBOX_USER_HOME%" (
  ECHO "Virtual Box home directory does not exist: %VBOX_USER_HOME%" 1>&2
  EXIT 3
)
IF NOT EXIST "%ISO_PATH%" (
  ECHO "Installation iso not found: %ISO_PATH%" 1>&2
  EXIT 3
)
IF NOT EXIST "%KS_PATH%" (
  ECHO "Kickstart template not found: %KS_PATH%" 1>&2
  EXIT 3
)
IF NOT EXIST "%POST_PATH%" (
  ECHO "Postinstall template not found: %POST_PATH%" 1>&2
  EXIT 3
)

rem Create machine
VBoxManage createvm --register --basefolder %VBOX_USER_HOME% --name %VM% --ostype RedHat_64
rem Setup system resources
VBoxManage modifyvm %VM% --ioapic on
VBoxManage modifyvm %VM% --cpus %CPU_COUNT%
VBoxManage modifyvm %VM% --memory %RAM_SIZE%
rem Setup network
VBoxManage modifyvm %VM% --nic1 intnet --intnet1 %INTNET_NAME% --macaddress1 080027180001
VBoxManage modifyvm %VM% --nic2 bridged --bridgeadapter2 %BRIDGE_NAME%
rem Create disk 
VBoxManage createmedium --filename %DISK_PATH% --size %DISK_SIZE%
VBoxManage storagectl %VM% --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach %VM% --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium %DISK_PATH%
rem Mount ISO image
VBoxManage storagectl %VM% --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach %VM% --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium %ISO_PATH%
rem Setup boot order
VBoxManage modifyvm %VM% --boot1 disk --boot2 dvd --boot3 none --boot4 none
rem Unattended install
VBoxManage unattended install %VM% --iso=%ISO_PATH% --start-vm=gui --script-template=%KS_PATH% --post-install-template=%POST_PATH%
