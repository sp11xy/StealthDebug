#!/system/bin/sh

# Logfile optional
#logfile="/data/local/tmp/stealthdebug.log"

# Warten, bis Boot abgeschlossen ist
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# Logstart
echo "[+] StealthDebug gestartet um $(date)" >> "$logfile"

# Wiederholtes Faken der Properties
while true; do
    # USB Debugging und ADB Properties
    resetprop -n persist.sys.usb.config mtp #funktioniert
    resetprop -n sys.usb.config mtp #funktioniert
    resetprop -n sys.usb.state mtp #funktioniert
    resetprop -n init.svc.adbd stopped #funktioniert
    resetprop -n sys.usb.ffs.ready 0 #funktioniert
	resetprop -n persist.sys.usb.reboot.func mtp #funktioniert
    resetprop -n service.adb.root 0  #funktioniert
    resetprop -n service.adb.tcp.port -1 #funktioniert
    resetprop -n persist.service.adb.enable 0 #funktioniert 
    #resetprop -n sys.usb.controller none #killer
    resetprop -n sys.usb.ffs.adb.ready 0 #funktioniert
    #resetprop -n sys.usb.configfs 0  #killer
    resetprop -n persist.vendor.usb.config none #funktioniert
    resetprop -n vendor.usb.config none #funktioniert

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

    # Magisk Hide / Root-Spuren löschen
    #resetprop --delete ro.magisk.disable
    #resetprop --delete persist.magisk.hide
    #resetprop --delete ro.magisk.version

    # Dienste beenden (optional, wird jedes Mal versucht)
    #stop adbd 2>/dev/null
    #stop usbd 2>/dev/null

    # Log-Eintrag für Debugging
    echo "[+] Props aktualisiert um $(date)" >> "$logfile"

    # Warte 2 Sekunden und wiederhole
    sleep 2
done &
