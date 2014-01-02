HOST?=https://www.transifex.com
USERNAME?=user
PASSWORD?=pass
OUTPUTLANG?=pt

help:
	@echo ''

open-education-handbook.zip:
	wget http://booktype.okfn.org/export/open-education-handbook/export \
	    -O open-education-handbook.zip

open-education-handbook-$(OUTPUTLANG).zip: open-education-handbook.zip
	cp $< $@

open-education-handbook: open-education-handbook.zip
	mkdir -p $@
	unzip -u -d $@ $<
	cd $@; tx init --host=$(HOST) --user=$(USERNAME) --pass=$(PASSWORD)
	cd $@; \
	for f in $$(ls *.html); \
	do \
	    html2po $${f} -o $${f/html/pot}; \
	done

open-education-handbook/template: open-education-handbook
	mkdir -p $@
	cp $</*.html $@

setup: open-education-handbook
	cd open-education-handbook; for f in $$(ls *.pot); \
	do \
	    tx set --auto-local -r open-education-handbook.$${f/\./} \
		"<lang>/$${f/pot/po}" --type=PO --source-language en \
		--source-file $${f} --execute; \
	done

push: setup
	cd open-education-handbook; tx push -s

pull: setup
	cd open-education-handbook; tx pull -l $(OUTPUTLANG)

reassemble: open-education-handbook-$(OUTPUTLANG).zip open-education-handbook/template
	cd open-education-handbook; for f in $$(ls *.html); \
	do \
	    po2html $(OUTPUTLANG)/$${f/html/po} \
		-t template/$${f} -o $${f}; \
	done
	zip -f open-education-handbook-$(OUTPUTLANG).zip open-education-handbook/*
