#!/bin/bash

# Reassemble BookType book base on Transifex translation of "Open Education Handbook"
#
# Usage: reassemble.sh lang

HOST=https://www.transifex.com

# Get book
if test ! -e open-education-handbook.zip; then
wget http://booktype.okfn.org/export/open-education-handbook/export \
    -O open-education-handbook.zip
fi

cp open-education-handbook.zip open-education-handbook-${1}.zip
mkdir -p open-education-handbook
unzip -u -d open-education-handbook open-education-handbook.zip

cd open-education-handbook

tx init --host=${HOST}

tx set --auto-remote \
    https://www.transifex.com/projects/p/open-education-handbook

tx pull -l ${1}

mkdir -p template
cp *.html template

# Use PO files to create HTML
for f in $(ls *.html)
do
    po2html translations/open-education-handbook.${f/.html/pot}/${1}.po \
        -t template/${f} -o ${f} --fuzzy
done

# Reassemble
cd -
zip -f open-education-handbook-${1}.zip open-education-handbook/*
