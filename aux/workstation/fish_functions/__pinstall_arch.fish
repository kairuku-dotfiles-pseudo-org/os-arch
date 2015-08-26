function __pinstall_arch -d "Arch-specific include function called by 'pinstall'"
# this function is not meant to be called directly
# this function is symlinked into the fish repo
# this function takes as an argument a package name

    __cli_message "Continuing with the Arch case ..."
    sudo pacmatic -Syy
    sudo pacman -S $argv

end # END OF SUBFUNCTION DEFINTION
