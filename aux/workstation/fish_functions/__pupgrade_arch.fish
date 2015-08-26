function __pupgrade_arch -d "Arch-specific include function called by 'pupgrade'"
#···············································································
# this function is not meant to be called directly
# this function is symlinked into the fish repo
# NOTE: ** this is the NON-PIPING variant of this subfunction **

    __cli_message "Continuing with the Arch case ..."

    # until the lock file issue is fixed:
    # killall pamac-tray

    set MIRS_TOP_DIR /z/750/dot/repos/os-arch/config/workstation/mirrorlists

    # always sed a new locale.gen? or always inspect manually?

    set ANT_PNEW /etc/pacman.d/antergos-mirrorlist.pacnew

    if test -e $ANT_PNEW
        __cli_message "Antergos mirrorlist pacnew file found, backing up and overwriting:"
        set ANT_MIR      $MIRS_TOP_DIR/generated/mirrorlist_antergos_active.ini
        set ANT_MIR_BAK  $MIRS_TOP_DIR/backups/mirrorlist_antergos_backup.ini
        cp -vf $ANT_MIR $ANT_MIR_BAK
        cat $ANT_PNEW > $ANT_MIR
        sudo rm -fv $ANT_PNEW
    else
        __cli_message "No Antergos mirrorlist pacnew file found"
    end # END PACNEW TEST

    set PAC_MIR      $MIRS_TOP_DIR/generated/mirrorlist_arch_active.ini
    set PAC_MIR_BAK  $MIRS_TOP_DIR/backups/mirrorlist_arch_backup.ini

    __cli_message "Backing up mirrorlist:"
    cp -vf $PAC_MIR $PAC_MIR_BAK

    __cli_message "Updating mirrors with reflector, using https (the mirrorlist package is disabled in pacman.conf):"
    reflector \
    --verbose \
    --country 'United States' \
    --latest 10 \
    --protocol https \
    --sort score \
    --save $PAC_MIR
    # note that verbose mode doesn't seem to output anything with the other options above
    # --sort {rate,score,delay,country,age}
    # --fastest n
    # --protocol http
    # --protocol rsync

    # inspect the generated list after pausing to view screen output to this point:
    sleep 3
    nano $PAC_MIR

    __cli_message "Running pacmatic (run w/o args to see options):"
    sudo pacmatic -Syy


    # aria2 complains about missing database signatures (see also your pacman.conf):
    # https://bbs.archlinux.org/viewtopic.php?id=153818&p=2
    __cli_message "Running powerpill (edit pacman.conf to upgrade temporarily excluded packages;"
    __cli_message "also check back periodically to see if pacman db signing has been implemented):"
    sudo powerpill -Syu

    set -l PPL_STATUS $status
    if test $PPL_STATUS -eq 0
        __cli_message "Powerpill completed, thus now running yaourt:"
        yaourt -Syua
        
        __cli_message "Running pkgcacheclean:"
        sudo pkgcacheclean --verbose 3

        # restart pamac-tray
        # pamac-tray &

        __cli_message "Type 'pacman -Q --help' for query options if desirable"
        __cli_message "Type 'pacdeps -oppp [package]' if desirable"
        __cli_message "Remember, never update pamac prefs via the GUI"
        __cli_message "If you upgrade virtualbox, reboot, then enter 'sudo vboxreload'"
    else
        __cli_message "Powerpill did not complete, resolve issues, then re-run this function"
    end # END PACMAN STATUS CONDITIONAL

#···············································································
end # END OF SUBFUNCTION DEFINTION


#···············································································
#    NOTES/REFERENCES:
#···············································································

# rankmirrors

# http://kmkeen.com/pacmatic/
# https://github.com/keenerd/pacmatic/blob/master/pacmatic

# http://xyne.archlinux.ca/projects/powerpill/#powerpill.json1

# https://www.archlinux.org/mirrors/status/
# https://www.archlinux.org/mirrorlist/

# https://wiki.archlinux.org/index.php/Mirrors
# https://wiki.archlinux.org/index.php/Reflector
# https://wiki.archlinux.org/index.php/Powerpill  

# https://wiki.archlinux.org/index.php/Category:System_recovery
# https://wiki.archlinux.org/index.php/Full_system_backup_with_rsync
# https://wiki.archlinux.org/index.php/Enhancing_Arch_Linux_Stability#Regularly_backup_a_list_of_installed_packages
# https://wiki.archlinux.org/index.php/Migrate_installation_to_new_hardware
