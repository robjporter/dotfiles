#!/bin/bash

###########################################################################
#                             Load .dotfiles
###########################################################################
curr=${PWD}
cd ${HOME}
source ./.functions
reload_dot_files
cd ${curr}
unset curr
###########################################################################