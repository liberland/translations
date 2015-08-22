#-------------------------------------------------------------------------------
#
#    This makefile will clone and update the source files from the following git 
#    repositories
#
#        constitution
#        laws
#
#    push the new source files to Transifex, pull the Transifex translations 
#    into the current repo, and finally create files for distribution in pdf, 
#    epub, mobi and html formats.
#
#    To add a new language to the translations repository, it is only necessary
#    to add the language code to the variables LANG_CONST and LANG_LAWS (for
#    constitution and laws translations, respectively).
#
#
#    DIRECTORIES
#
#    source                 Clones of the github constitution and laws repos.
#
#    translations           Translated files pulled from Transifex.
#
#    docs                   PDF, ePub, Mobi, and HTML files for distribution.
#
#
#    USAGE
# 
#    make init              Use this only once in order to clone the github
#                           Constitution and Laws repositories.
#
#    make                   Update the constitution and laws repos, update the 
#                           Transifex source, download Transifex translations, 
#                           and make the final distribution docs. (This contains 
#                           all of the subsequent makes.)
#
#    make update-source     Update the GitHubsource repositories.
#
#    make update-transifex  Update the Transifex files.
#
#    make docs              Make the final docs for distribution.
#
#    make cdocs             Make the final Constitution documentation for
#                           distribution.
#
#    make ldocs             Make the final Laws documentation for distribution.
#
#-------------------------------------------------------------------------------
PANDOC = pandoc
GIT = git
TX = tx

LANG_LAWS = cs de fr hr hu ru sr tr
LANG_CONST = cs de fr hr hu ru sr tr

PD_OPT = --tab-stop=2 --toc --toc-depth=3 -S
PDF_OPTIONS = -V geometry:margin=1in

DATE = $(shell date "+%Y-%m-%d %H:%M %Z")

CONST_REPO = git@github.com:liberland/constitution.git
CONST_SOURCE = source/constitution
CONST_DOCS = docs/constitution
CONST_TRANS = translations/constitution
CONST_TITLE = metadata/constitution-title.txt

LAWS_REPO = git@github.com:liberland/laws.git
LAWS_SOURCE = source/laws
LAWS_DOCS = docs/laws
LAWS_TRANS = translations/laws
LAWS_TITLE = metadata/laws-title.txt

LANG_LDOCS = en $(LANG_LAWS)
LANG_CDOCS = en $(LANG_CONST)

CFILES = Liberland-constitution
CONST_MD_FILES_EN = $(CONST_DOCS)/en/$(CFILES)-en.md
CONST_MD_FILES = $(foreach lang,$(LANG_CONST),$(CONST_DOCS)/$(lang)/$(CFILES)-$(lang).md)
CONST_PDF_FILES = $(foreach lang,$(LANG_CDOCS),$(CONST_DOCS)/$(lang)/$(CFILES)-$(lang).pdf)
CONST_MOBI_FILES = $(CONST_PDF_FILES:.pdf=.mobi)
CONST_HTML_FILES = $(CONST_PDF_FILES:.pdf=.html)
CONST_EPUB_FILES = $(CONST_PDF_FILES:.pdf=.epub)

LFILES = $(basename $(notdir $(wildcard $(LAWS_SOURCE)/drafts/*.md)))
LAWS_MD_FILES_EN = $(foreach var,$(LFILES),$(LAWS_DOCS)/en/$(var)_en.md)
LAWS_MD_FILES = $(foreach lang,$(LANG_LAWS),$(foreach var,$(LFILES),$(LAWS_DOCS)/$(lang)/$(var)_$(lang).md))
LAWS_PDF_FILES = $(foreach lang,$(LANG_LDOCS),$(foreach var,$(LFILES),$(LAWS_DOCS)/$(lang)/$(var)_$(lang).pdf))
LAWS_MOBI_FILES = $(LAWS_PDF_FILES:.pdf=.mobi)
LAWS_HTML_FILES = $(LAWS_PDF_FILES:.pdf=.html)
LAWS_EPUB_FILES = $(LAWS_PDF_FILES:.pdf=.epub)


all: update-source update-transifex docs

clean:
	-rm -r docs
	-rm -r translations
	-rm $(CONST_TITLE)
	-rm $(LAWS_TITLE)

init:
	$(GIT) clone $(CONST_REPO) $(CONST_SOURCE)
	$(GIT) clone $(LAWS_REPO) $(LAWS_SOURCE)

update-source:
	cd $(CONST_SOURCE) && $(GIT) pull
	cd $(LAWS_SOURCE) && $(GIT) pull

update-transifex:
	$(TX) pull -a && $(TX) push -s

docs: cdocs ldocs

cdocs: make-constitution-dir constitution-docs

ldocs: make-laws-dir laws-docs

constitution-docs: $(CONST_MD_FILES_EN) $(CONST_MD_FILES) \
	$(CONST_PDF_FILES) $(CONST_MOBI_FILES) \
	$(CONST_HTML_FILES) $(CONST_EPUB_FILES)

laws-docs: $(LAWS_MD_FILES_EN) $(LAWS_MD_FILES) $(LAWS_PDF_FILES) \
	$(LAWS_MOBI_FILES) $(LAWS_HTML_FILES) $(LAWS_EPUB_FILES)

make-constitution-dir:
	@for lang in $(LANG_CDOCS); \
	do \
		mkdir -p $(CONST_DOCS)/$$lang ; \
	done
	@echo "% Liberland Constitution\n%\n% Last updated: $(DATE)" > $(CONST_TITLE)
	
make-laws-dir:
	@for lang in $(LANG_LDOCS); \
	do \
		mkdir -p $(LAWS_DOCS)/$$lang ; \
	done
	@echo "% Liberland Laws and Provisions\n%\n% Last updated: $(DATE)" > $(LAWS_TITLE)


$(CONST_MD_FILES_EN) : $(CONST_DOCS)/en/%-en.md : $(CONST_SOURCE)/%.md
	@cat $(CONST_TITLE) $< > $@

$(CONST_MD_FILES) : $(CONST_DOCS)/%.md : $(CONST_TRANS)/%.md
	@cat $(CONST_TITLE) $< > $@

$(CONST_PDF_FILES): %.pdf : %.md
	$(PANDOC) $(PD_OPT) $(PDF_OPTIONS) -o $@ $<

$(CONST_MOBI_FILES): %.mobi : %.md
	$(PANDOC) $(PD_OPT) -o $@ $<

$(CONST_HTML_FILES): %.html : %.md
	$(PANDOC) $(PD_OPT) --standalone --to=html5 -o $@ $<

$(CONST_EPUB_FILES): %.epub : %.md
	$(PANDOC) $(PD_OPT) --epub-metadata=metadata/constitution.yaml -o $@ $<

$(LAWS_MD_FILES_EN) : $(LAWS_DOCS)/en/%_en.md : $(LAWS_SOURCE)/drafts/%.md
	@cat $(LAWS_TITLE) $< > $@

$(LAWS_MD_FILES) : $(LAWS_DOCS)/%.md : $(LAWS_TRANS)/%.md
	@cat $(LAWS_TITLE) $< > $@

$(LAWS_PDF_FILES): %.pdf : %.md
	$(PANDOC) $(PD_OPT) $(PDF_OPTIONS) -o $@ $<

$(LAWS_MOBI_FILES): %.mobi : %.md
	$(PANDOC) $(PD_OPT) -o $@ $<

$(LAWS_HTML_FILES): %.html : %.md
	$(PANDOC) $(PD_OPT) --standalone --to=html5 -o $@ $<

$(LAWS_EPUB_FILES): %.epub : %.md
	$(PANDOC) $(PD_OPT) --epub-metadata=metadata/laws.yaml -o $@ $<

