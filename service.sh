#!/system/bin/sh

# Logfile optional
#logfile="/data/local/tmp/stealthdebug.log"

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

echo "[+] StealthDebug gestartet um $(date)" >> "$logfile"


while true; do
   
    resetprop -n persist.sys.usb.config mtp 
    resetprop -n sys.usb.config mtp 
    resetprop -n sys.usb.state mtp 
    resetprop -n init.svc.adbd stopped 
    resetprop -n sys.usb.ffs.ready 0 
    resetprop -n persist.sys.usb.reboot.func mtp 
    resetprop -n service.adb.root 0  
    resetprop -n service.adb.tcp.port -1 
    resetprop -n persist.service.adb.enable 0 
    #resetprop -n sys.usb.controller none #killer
    resetprop -n sys.usb.ffs.adb.ready 0 
    #resetprop -n sys.usb.configfs 0  #killer
    resetprop -n persist.vendor.usb.config none 
    resetprop -n vendor.usb.config none 

    # Build Properties
    resetprop -n ro.build.type user
    resetprop -n ro.build.tags release-keys
    resetprop -n ro.product.build.type user
    resetprop -n ro.build.selinux enforcing

    # Debugging Flags
    resetprop -n ro.debuggable 0
    #resetprop -n ro.adb.secure 1
    #resetprop -n ro.secure 1
    resetprop -n persist.sys.debuggable 0
    resetprop -n persist.service.debuggerd.enable 0
    resetprop -n dalvik.vm.checkjni false
    resetprop -n ro.kernel.android.checkjni 0

    # Bootloader/Security
    resetprop -n ro.boot.vbmeta.device_state locked
    resetprop -n ro.boot.verifiedbootstate green
    resetprop -n ro.boot.flash.locked 1
    resetprop -n ro.warranty_bit 0
    resetprop -n ro.boot.warranty_bit 0
    resetprop -n ro.boot.mode normal
    resetprop -n ro.bootmode normal

    #resetprop --delete ro.magisk.disable
    #resetprop --delete persist.magisk.hide
    #resetprop --delete ro.magisk.version

    #stop adbd 2>/dev/null
    #stop usbd 2>/dev/null

    echo "[+] Props aktualisiert um $(date)" >> "$logfile"

    
    sleep 2
done &
