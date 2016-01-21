#!/bin/bash
export OOC_LIBS=$(dirname `pwd`)
OPTIMIZE="-O2"
#magic .
rock -v -r -O2 --gc=off +-Wall magic-chess.use
