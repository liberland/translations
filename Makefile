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
#    to add the language code to the variables LANGCONST and LANGLAWS (for
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
#    make update-source     Update the source repositories.
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

LANGLAWS = cs de fr hr hu ru sr
LANGCONST = cs de fr hr hu ru sr

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

LANGLDOCS = en $(LANGLAWS)
LANGCDOCS = en $(LANGCONST)

CFILES = Liberland-constitution
CONST_MD_FILES = $(CONST_SOURCE)/$(CFILES).md
CONST_MD_FILES += $(foreach lang,$(LANGCONST),$(CONST_TRANS)/$(lang)/$(CFILES)-$(lang).md)
CONST_PDF_FILES = $(foreach lang,$(LANGCDOCS),$(CONST_DOCS)/$(lang)/$(CFILES)-$(lang).pdf)
CONST_MOBI_FILES = $(CONST_PDF_FILES:.pdf=.mobi)
CONST_HTML_FILES = $(CONST_PDF_FILES:.pdf=.html)
CONST_EPUB_FILES = $(CONST_PDF_FILES:.pdf=.epub)

LFILES = $(basename $(notdir $(wildcard $(LAWS_SOURCE)/drafts/*.md)))
LAWS_MD_FILES = $(foreach var,$(LFILES),$(LAWS_SOURCE)/drafts/$(var).md)
LAWS_MD_FILES += $(foreach lang,$(LANGLAWS),$(foreach var,$(LFILES),$(LAWS_TRANS)/$(lang)/$(var)_$(lang).md))
LAWS_PDF_FILES = $(foreach lang,$(LANGLDOCS),$(foreach var,$(LFILES),$(LAWS_DOCS)/$(lang)/$(var)_$(lang).pdf))
LAWS_MOBI_FILES = $(LAWS_PDF_FILES:.pdf=.mobi)
LAWS_HTML_FILES = $(LAWS_PDF_FILES:.pdf=.html)
LAWS_EPUB_FILES = $(LAWS_PDF_FILES:.pdf=.epub)


all: update-source update-transifex docs

clean:
	-rm -r docs
	-rm -r translations
	-rm -r source
	-rm $(CONST_TITLE)
	-rm $(LAWS_TITLE)

init:
	$(GIT) clone $(CONST_REPO) $(CONST_SOURCE)
	$(GIT) clone $(LAWS_REPO) $(LAWS_SOURCE)

docs: cdocs ldocs

cdocs: make-constitution-dir constitution-docs

ldocs: make-laws-dir laws-docs

make-constitution-dir:
	@for lang in $(LANGCDOCS); \
	do \
		mkdir -p $(CONST_DOCS)/$$lang ; \
	done
	echo "% Liberland Constitution\n%\n% Last updated: $(DATE)" > $(CONST_TITLE)
	
make-laws-dir:
	@for lang in $(LANGLDOCS); \
	do \
		mkdir -p $(LAWS_DOCS)/$$lang ; \
	done
	echo "% Liberland Laws and Provisions\n%\n% Last updated: $(DATE)" > $(LAWS_TITLE)
	
update-source:
	cd $(CONST_SOURCE) && $(GIT) fetch && $(GIT) pull
	cd $(LAWS_SOURCE) && $(GIT) fetch && $(GIT) pull

update-transifex:
	$(TX) pull -a && $(TX) push -s

constitution-docs: $(CONST_PDF_FILES) $(CONST_MOBI_FILES) $(CONST_HTML_FILES) $(CONST_EPUB_FILES)

laws-docs: $(LAWS_PDF_FILES) $(LAWS_MOBI_FILES) $(LAWS_HTML_FILES) $(LAWS_EPUB_FILES)

$(CONST_PDF_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) $(PDF_OPTIONS) -o $@ $(CONST_TITLE) $<

$(CONST_MOBI_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) -o $@ $(CONST_TITLE) $<

$(CONST_HTML_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) --standalone --to=html5 -o $@ $(CONST_TITLE) $<

$(CONST_EPUB_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) --epub-metadata=metadata/constitution.yaml -o $@ $(CONST_TITLE) $<

$(LAWS_PDF_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) $(PDF_OPTIONS) -o $@ $(LAWS_TITLE) $<

$(LAWS_MOBI_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) -o $@ $(LAWS_TITLE) $<

$(LAWS_HTML_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) --standalone --to=html5 -o $@ $(LAWS_TITLE) $<

$(LAWS_EPUB_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) --epub-metadata=metadata/laws.yaml -o $@ $(LAWS_TITLE) $<

