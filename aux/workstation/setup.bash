#!/usr/bin/bash

# depends on "lnif" function (which depends on explicit $HOME paths); 
# see separate bash repo
source $BASH_CUSTOM_FUNCTIONS_FILE

CURRENT_DIR=$(pwd)

#···············································································
#   SETUP CONFIG FILES
#···············································································

ARCH_CONF='/z/750/dot/repos/os-arch/config/workstation'


lnif "$ARCH_CONF/pacman.conf.ini"     '/etc/pacman.conf'
lnif "$ARCH_CONF/pacmatic.ini"        '/root/.config/pacmatic'
lnif "$ARCH_CONF/pamac.conf.ini"      '/etc/pamac.conf'
lnif "$ARCH_CONF/powerpill.json"      '/etc/powerpill/powerpill.json'
lnif "$ARCH_CONF/yaourtrc.ini"        '/etc/yaourtrc'

ARCH_MIRS="$ARCH_CONF/mirrorlists/generated"

lnif "$ARCH_MIRS/mirrorlist_antergos_active.ini"    '/etc/pacman.d/antergos-mirrorlist'
lnif "$ARCH_MIRS/mirrorlist_arch_active.ini"        '/etc/pacman.d/mirrorlist'

echo "Changing pamac preferences in the GUI overwrites the symlink, so don't use  the GUI"
echo

#···············································································
#   SETUP FISH FUNCTIONS
#···············································································

ARCH_AUX='/z/750/dot/repos/os-arch/aux/workstation/fish_functions'
FISH_DIR='/z/750/dot/repos/shell-fish/config/workstation/generic/ln_src_func_shared/functions/open/system_oriented/inc'

lnif "$ARCH_AUX/__pinstall_arch.fish"   "$FISH_DIR/__pinstall_arch.fish"
lnif "$ARCH_AUX/__pupgrade_arch.fish"   "$FISH_DIR/__pupgrade_arch.fish"

#···············································································
cd $CURRENT_DIR
