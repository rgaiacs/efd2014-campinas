#!/bin/bash

# Setup the current directory to the translation of "Open Education Handbook"
#
# Usage: setup.sh https://www.transifex.com username password
#

# Get book
if test ! -e open-education-handbook.zip; then
wget http://booktype.okfn.org/export/open-education-handbook/export \
    -O open-education-handbook.zip
fi

mkdir -p open-education-handbook
unzip -u -d open-education-handbook open-education-handbook.zip

cd open-education-handbook

tx init --host=$1 --user=$2 --pass=$3

mkdir -p pt

# Create PO files from HTML
for f in $(ls *.html)
do
    html2po ${f} -o ${f/html/pot}
done

# Create mapping of PO files for Transifex
for f in $(ls *.pot)
do
    tx set --auto-local -r open-education-handbook.${f/\./} \
        "<lang>/${f/pot/po}" --type=PO --source-language en \
        --source-file ${f} --execute
done

tx push -s
