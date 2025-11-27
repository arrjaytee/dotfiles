#!/bin/bash
#------------------------------------------------------------------------------
# BP HPC .bashrc file
# => Do not delete, modify, or molest.
# => All user mods should go in $HOME/.userbashrc
#------------------------------------------------------------------------------
# => This is where our setup files live
#
SETUP="/hpc/apps/setup"
#
#------------------------------------------------------------------------------
#
[ -f "$SETUP/profile.bash" ] && . $SETUP/profile.bash
#
#------------------------------------------------------------------------------
#
[ -f "$HOME/.userbashrc" ] && . $HOME/.userbashrc




