#!/usr/bin/env bash

# Only try running R to translate files if there are some files present.
# The Makefile passes in the names of files.


if [ $# -eq 2 ] ; then
    Rscript -e "source('bin/generate_md_episodes.R')" "$@"
fi
