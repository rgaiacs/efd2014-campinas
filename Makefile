HOST?=https://www.transifex.com
USERNAME?=user
PASSWORD?=pass
OUTPUTLANG?=pt
PO=$(wildcard open-education-handbook-$(OUTPUTLANG)/translations/*/$(OUTPUTLANG).po)

help:
	@echo This is the maintainer script for Campinas\' EFD 2014
	@echo
	@echo push: update files in Transifex server
	@echo reassemble: create zip with translation
	@echo
	@echo For more information look at REAMDE.md

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

open-education-handbook-$(OUTPUTLANG): open-education-handbook
	mkdir -p $@
	cp $</*.html $@
	cd $@; tx init --host=$(HOST) --user=$(USERNAME) --pass=$(PASSWORD)

setup-clean: open-education-handbook
	# Remove old resources from server
	cd open-education-handbook; tx set --auto-remote \
	    https://www.transifex.com/projects/p/open-education-handbook
	cd open-education-handbook; \
	     for i in `awk -F '/' '/file_filter/ {print $$2}' .tx/config | awk -F '.' '{gsub("pot", ".html", $$2); print $$2}'`; \
	     do \
	     if test ! -e $${i}; then \
	     tx delete -f -r open-education-handbook.$${i/.html/pot}; \
	     fi; \
	     done;

setup: open-education-handbook setup-clean
	rm -rf open-education-handbook/.tx
	cd open-education-handbook; for f in $$(ls *.pot); \
	do \
	    tx set --auto-local -r open-education-handbook.$${f/\./} \
		"<lang>/$${f/pot/po}" --type=PO --source-language en \
		--source-file $${f} --execute; \
	done

push: setup
	cd open-education-handbook; tx push -s

pull: open-education-handbook-$(OUTPUTLANG)
	cd open-education-handbook-$(OUTPU2TLANG); tx set --auto-remote \
	    https://www.transifex.com/projects/p/open-education-handbook
	cd open-education-handbook-$(OUTPUTLANG); tx pull -l $(OUTPUTLANG)

reassemble: open-education-handbook-$(OUTPUTLANG).zip $(PO)
	cd open-education-handbook-$(OUTPUTLANG); for f in $$(ls *.html); \
	do \
	    po2html translations/open-education-handbook.$${f/.html/pot}/$(OUTPUTLANG).po \
		-t ../open-education-handbook/$${f} -o $${f}; \
	done
	zip -f open-education-handbook-$(OUTPUTLANG).zip open-education-handbook-$(OUTPUTLANG)/*

clean:
	rm -rf open-education-handbook-$(OUTPUTLANG){,.zip}

cleanall: clean
	rm -rf open-education-handbook{,.zip}
