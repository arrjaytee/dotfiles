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





# >>> vscode python
# version: 0.1.1
if [ -z "$VSCODE_PYTHON_AUTOACTIVATE_GUARD" ]; then
    export VSCODE_PYTHON_AUTOACTIVATE_GUARD=1
    if [ -n "$VSCODE_PYTHON_BASH_ACTIVATE" ] && [ "$TERM_PROGRAM" = "vscode" ]; then
        eval "$VSCODE_PYTHON_BASH_ACTIVATE" || true
    fi
fi
# <<< vscode python
