#!/bin/bash

# Fetch the translation of "Open Education Handbook"
#
# Usage: fetch.sh https://www.transifex.com username password

cd $(mkdir -p open-education-handbook)

tx init --host=$1 --user=$2 --pass=$3

tx set --auto-remote \
    https://www.transifex.com/projects/p/open-education-handbook-portuguese-version
