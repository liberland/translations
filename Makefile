#-------------------------------------------------------------------------------
#
#	 This makefile will update the source files from the git repositories
#
#		 constitution
#		 laws
#
#	 push the new source files to transifex, and pull the transifex 
#	 translations. Finally, it will create files for distribution in 
#	 pds, epub and mobi formats.
#	
#	 Usage:
#		 
#		 make init			Use this only once in order to clone to the 
#							Constitution and Laws repos and create some 
#							empty directories.
#		 make				Update the constitution and laws repos,
#							update the transifex source and download 
#							translations, and make the final distribution docs.
#
#-------------------------------------------------------------------------------
PANDOC = pandoc
GIT = git
TX = tx

PD_OPT = --tab-stop=2 --toc --toc-depth=3 -S
PDF_OPTIONS = -V geometry:margin=1in

DATE = $(shell date "+%Y-%m-%d %H:%M %Z")

CONST_REPO = git@github.com:liberland/constitution.git
CONST_SOURCE = source/constitution
CONST_DOCS = docs/constitution
CONST_TRANS = translations/constitution

LAWS_REPO = git@github.com:liberland/laws.git
LAWS_SOURCE = source/laws
LAWS_DOCS = docs/laws
LAWS_TRANS = translations/laws
LAWS_INDEX = metadata/laws-title.txt

CONST_MD_FILES = $(CONST_SOURCE)/Liberland-constitution.md \
	$(CONST_TRANS)/cs/Liberland-constitution-cs.md \
	$(CONST_TRANS)/de/Liberland-constitution-de.md \
	$(CONST_TRANS)/fr/Liberland-constitution-fr.md \
	$(CONST_TRANS)/hr/Liberland-constitution-hr.md \
	$(CONST_TRANS)/hu/Liberland-constitution-hu.md \
	$(CONST_TRANS)/ru/Liberland-constitution-ru.md \
	$(CONST_TRANS)/sr/Liberland-constitution-sr.md

CONST_PDF_FILES = $(CONST_DOCS)/en/Liberland-constitution.pdf \
	$(CONST_DOCS)/cs/Liberland-constitution-cs.pdf \
	$(CONST_DOCS)/de/Liberland-constitution-de.pdf \
	$(CONST_DOCS)/fr/Liberland-constitution-fr.pdf \
	$(CONST_DOCS)/hr/Liberland-constitution-hr.pdf \
	$(CONST_DOCS)/hu/Liberland-constitution-hu.pdf \
	$(CONST_DOCS)/ru/Liberland-constitution-ru.pdf \
	$(CONST_DOCS)/sr/Liberland-constitution-sr.pdf

CONST_MOBI_FILES = $(CONST_DOCS)/en/Liberland-constitution.mobi \
	$(CONST_DOCS)/cs/Liberland-constitution-cs.mobi \
	$(CONST_DOCS)/de/Liberland-constitution-de.mobi \
	$(CONST_DOCS)/fr/Liberland-constitution-fr.mobi \
	$(CONST_DOCS)/hr/Liberland-constitution-hr.mobi \
	$(CONST_DOCS)/hu/Liberland-constitution-hu.mobi \
	$(CONST_DOCS)/ru/Liberland-constitution-ru.mobi \
	$(CONST_DOCS)/sr/Liberland-constitution-sr.mobi

CONST_HTML_FILES = $(CONST_DOCS)/en/Liberland-constitution.html \
	$(CONST_DOCS)/cs/Liberland-constitution-cs.html \
	$(CONST_DOCS)/de/Liberland-constitution-de.html \
	$(CONST_DOCS)/fr/Liberland-constitution-fr.html \
	$(CONST_DOCS)/hr/Liberland-constitution-hr.html \
	$(CONST_DOCS)/hu/Liberland-constitution-hu.html \
	$(CONST_DOCS)/ru/Liberland-constitution-ru.html \
	$(CONST_DOCS)/sr/Liberland-constitution-sr.html

CONST_EPUB_FILES = $(CONST_DOCS)/en/Liberland-constitution.epub \
	$(CONST_DOCS)/cs/Liberland-constitution-cs.epub \
	$(CONST_DOCS)/de/Liberland-constitution-de.epub \
	$(CONST_DOCS)/fr/Liberland-constitution-fr.epub \
	$(CONST_DOCS)/hr/Liberland-constitution-hr.epub \
	$(CONST_DOCS)/hu/Liberland-constitution-hu.epub \
	$(CONST_DOCS)/ru/Liberland-constitution-ru.epub \
	$(CONST_DOCS)/sr/Liberland-constitution-sr.epub

LAWS_MD_FILES = $(addprefix $(LAWS_SOURCE)/drafts/, Adjudication_of_Civil_Disputes.md \
	Administration_of_Justice.md Corporate_Regulations.md Land_Ownership.md \
	The_Articles_of_the_Preparatory_Committee.md ) \
	$(addprefix $(LAWS_TRANS)/cs/, Adjudication_of_Civil_Disputes_cs.md \
	Administration_of_Justice_cs.md Corporate_Regulations_cs.md Land_Ownership_cs.md \
	The_Articles_of_the_Preparatory_Committee_cs.md ) \
	$(addprefix $(LAWS_TRANS)/de/, Adjudication_of_Civil_Disputes_de.md \
	Administration_of_Justice_de.md Corporate_Regulations_de.md Land_Ownership_de.md \
	The_Articles_of_the_Preparatory_Committee_de.md ) \
	$(addprefix $(LAWS_TRANS)/fr/, Adjudication_of_Civil_Disputes_fr.md \
	Administration_of_Justice_fr.md Corporate_Regulations_fr.md Land_Ownership_fr.md \
	The_Articles_of_the_Preparatory_Committee_fr.md ) \
	$(addprefix $(LAWS_TRANS)/hr/, Adjudication_of_Civil_Disputes_hr.md \
	Administration_of_Justice_hr.md Corporate_Regulations_hr.md Land_Ownership_hr.md \
	The_Articles_of_the_Preparatory_Committee_hr.md ) \
	$(addprefix $(LAWS_TRANS)/hu/, Adjudication_of_Civil_Disputes_hu.md \
	Administration_of_Justice_hu.md Corporate_Regulations_hu.md Land_Ownership_hu.md \
	The_Articles_of_the_Preparatory_Committee_hu.md ) \
	$(addprefix $(LAWS_TRANS)/ru/, Adjudication_of_Civil_Disputes_ru.md \
	Administration_of_Justice_ru.md Corporate_Regulations_ru.md Land_Ownership_ru.md \
	The_Articles_of_the_Preparatory_Committee_ru.md ) \
	$(addprefix $(LAWS_TRANS)/sr/, Adjudication_of_Civil_Disputes_sr.md \
	Administration_of_Justice_sr.md Corporate_Regulations_sr.md Land_Ownership_sr.md \
	The_Articles_of_the_Preparatory_Committee_sr.md )

LAWS_PDF_FILES = $(addprefix $(LAWS_DOCS)/en/, Adjudication_of_Civil_Disputes.pdf \
	Administration_of_Justice.pdf Corporate_Regulations.pdf Land_Ownership.pdf \
	The_Articles_of_the_Preparatory_Committee.pdf ) \
	$(addprefix $(LAWS_DOCS)/cs/, Adjudication_of_Civil_Disputes_cs.pdf \
	Administration_of_Justice_cs.pdf Corporate_Regulations_cs.pdf Land_Ownership_cs.pdf \
	The_Articles_of_the_Preparatory_Committee_cs.pdf ) \
	$(addprefix $(LAWS_DOCS)/de/, Adjudication_of_Civil_Disputes_de.pdf \
	Administration_of_Justice_de.pdf Corporate_Regulations_de.pdf Land_Ownership_de.pdf \
	The_Articles_of_the_Preparatory_Committee_de.pdf ) \
	$(addprefix $(LAWS_DOCS)/fr/, Adjudication_of_Civil_Disputes_fr.pdf \
	Administration_of_Justice_fr.pdf Corporate_Regulations_fr.pdf Land_Ownership_fr.pdf \
	The_Articles_of_the_Preparatory_Committee_fr.pdf ) \
	$(addprefix $(LAWS_DOCS)/hr/, Adjudication_of_Civil_Disputes_hr.pdf \
	Administration_of_Justice_hr.pdf Corporate_Regulations_hr.pdf Land_Ownership_hr.pdf \
	The_Articles_of_the_Preparatory_Committee_hr.pdf ) \
	$(addprefix $(LAWS_DOCS)/hu/, Adjudication_of_Civil_Disputes_hu.pdf \
	Administration_of_Justice_hu.pdf Corporate_Regulations_hu.pdf Land_Ownership_hu.pdf \
	The_Articles_of_the_Preparatory_Committee_hu.pdf ) \
	$(addprefix $(LAWS_DOCS)/ru/, Adjudication_of_Civil_Disputes_ru.pdf \
	Administration_of_Justice_ru.pdf Corporate_Regulations_ru.pdf Land_Ownership_ru.pdf \
	The_Articles_of_the_Preparatory_Committee_ru.pdf ) \
	$(addprefix $(LAWS_DOCS)/sr/, Adjudication_of_Civil_Disputes_sr.pdf \
	Administration_of_Justice_sr.pdf Corporate_Regulations_sr.pdf Land_Ownership_sr.pdf \
	The_Articles_of_the_Preparatory_Committee_sr.pdf )

LAWS_MOBI_FILES = $(addprefix $(LAWS_DOCS)/en/, Adjudication_of_Civil_Disputes.mobi \
	Administration_of_Justice.mobi Corporate_Regulations.mobi Land_Ownership.mobi \
	The_Articles_of_the_Preparatory_Committee.mobi ) \
	$(addprefix $(LAWS_DOCS)/cs/, Adjudication_of_Civil_Disputes_cs.mobi \
	Administration_of_Justice_cs.mobi Corporate_Regulations_cs.mobi Land_Ownership_cs.mobi \
	The_Articles_of_the_Preparatory_Committee_cs.mobi ) \
	$(addprefix $(LAWS_DOCS)/de/, Adjudication_of_Civil_Disputes_de.mobi \
	Administration_of_Justice_de.mobi Corporate_Regulations_de.mobi Land_Ownership_de.mobi \
	The_Articles_of_the_Preparatory_Committee_de.mobi ) \
	$(addprefix $(LAWS_DOCS)/fr/, Adjudication_of_Civil_Disputes_fr.mobi \
	Administration_of_Justice_fr.mobi Corporate_Regulations_fr.mobi Land_Ownership_fr.mobi \
	The_Articles_of_the_Preparatory_Committee_fr.mobi ) \
	$(addprefix $(LAWS_DOCS)/hr/, Adjudication_of_Civil_Disputes_hr.mobi \
	Administration_of_Justice_hr.mobi Corporate_Regulations_hr.mobi Land_Ownership_hr.mobi \
	The_Articles_of_the_Preparatory_Committee_hr.mobi ) \
	$(addprefix $(LAWS_DOCS)/hu/, Adjudication_of_Civil_Disputes_hu.mobi \
	Administration_of_Justice_hu.mobi Corporate_Regulations_hu.mobi Land_Ownership_hu.mobi \
	The_Articles_of_the_Preparatory_Committee_hu.mobi ) \
	$(addprefix $(LAWS_DOCS)/ru/, Adjudication_of_Civil_Disputes_ru.mobi \
	Administration_of_Justice_ru.mobi Corporate_Regulations_ru.mobi Land_Ownership_ru.mobi \
	The_Articles_of_the_Preparatory_Committee_ru.mobi ) \
	$(addprefix $(LAWS_DOCS)/sr/, Adjudication_of_Civil_Disputes_sr.mobi \
	Administration_of_Justice_sr.mobi Corporate_Regulations_sr.mobi Land_Ownership_sr.mobi \
	The_Articles_of_the_Preparatory_Committee_sr.mobi )

LAWS_HTML_FILES = $(addprefix $(LAWS_DOCS)/en/, Adjudication_of_Civil_Disputes.html \
	Administration_of_Justice.html Corporate_Regulations.html Land_Ownership.html \
	The_Articles_of_the_Preparatory_Committee.html ) \
	$(addprefix $(LAWS_DOCS)/cs/, Adjudication_of_Civil_Disputes_cs.html \
	Administration_of_Justice_cs.html Corporate_Regulations_cs.html Land_Ownership_cs.html \
	The_Articles_of_the_Preparatory_Committee_cs.html ) \
	$(addprefix $(LAWS_DOCS)/de/, Adjudication_of_Civil_Disputes_de.html \
	Administration_of_Justice_de.html Corporate_Regulations_de.html Land_Ownership_de.html \
	The_Articles_of_the_Preparatory_Committee_de.html ) \
	$(addprefix $(LAWS_DOCS)/fr/, Adjudication_of_Civil_Disputes_fr.html \
	Administration_of_Justice_fr.html Corporate_Regulations_fr.html Land_Ownership_fr.html \
	The_Articles_of_the_Preparatory_Committee_fr.html ) \
	$(addprefix $(LAWS_DOCS)/hr/, Adjudication_of_Civil_Disputes_hr.html \
	Administration_of_Justice_hr.html Corporate_Regulations_hr.html Land_Ownership_hr.html \
	The_Articles_of_the_Preparatory_Committee_hr.html ) \
	$(addprefix $(LAWS_DOCS)/hu/, Adjudication_of_Civil_Disputes_hu.html \
	Administration_of_Justice_hu.html Corporate_Regulations_hu.html Land_Ownership_hu.html \
	The_Articles_of_the_Preparatory_Committee_hu.html ) \
	$(addprefix $(LAWS_DOCS)/ru/, Adjudication_of_Civil_Disputes_ru.html \
	Administration_of_Justice_ru.html Corporate_Regulations_ru.html Land_Ownership_ru.html \
	The_Articles_of_the_Preparatory_Committee_ru.html ) \
	$(addprefix $(LAWS_DOCS)/sr/, Adjudication_of_Civil_Disputes_sr.html \
	Administration_of_Justice_sr.html Corporate_Regulations_sr.html Land_Ownership_sr.html \
	The_Articles_of_the_Preparatory_Committee_sr.html )

LAWS_EPUB_FILES = $(addprefix $(LAWS_DOCS)/en/, Adjudication_of_Civil_Disputes.epub \
	Administration_of_Justice.epub Corporate_Regulations.epub Land_Ownership.epub \
	The_Articles_of_the_Preparatory_Committee.epub ) \
	$(addprefix $(LAWS_DOCS)/cs/, Adjudication_of_Civil_Disputes_cs.epub \
	Administration_of_Justice_cs.epub Corporate_Regulations_cs.epub Land_Ownership_cs.epub \
	The_Articles_of_the_Preparatory_Committee_cs.epub ) \
	$(addprefix $(LAWS_DOCS)/de/, Adjudication_of_Civil_Disputes_de.epub \
	Administration_of_Justice_de.epub Corporate_Regulations_de.epub Land_Ownership_de.epub \
	The_Articles_of_the_Preparatory_Committee_de.epub ) \
	$(addprefix $(LAWS_DOCS)/fr/, Adjudication_of_Civil_Disputes_fr.epub \
	Administration_of_Justice_fr.epub Corporate_Regulations_fr.epub Land_Ownership_fr.epub \
	The_Articles_of_the_Preparatory_Committee_fr.epub ) \
	$(addprefix $(LAWS_DOCS)/hr/, Adjudication_of_Civil_Disputes_hr.epub \
	Administration_of_Justice_hr.epub Corporate_Regulations_hr.epub Land_Ownership_hr.epub \
	The_Articles_of_the_Preparatory_Committee_hr.epub ) \
	$(addprefix $(LAWS_DOCS)/hu/, Adjudication_of_Civil_Disputes_hu.epub \
	Administration_of_Justice_hu.epub Corporate_Regulations_hu.epub Land_Ownership_hu.epub \
	The_Articles_of_the_Preparatory_Committee_hu.epub ) \
	$(addprefix $(LAWS_DOCS)/ru/, Adjudication_of_Civil_Disputes_ru.epub \
	Administration_of_Justice_ru.epub Corporate_Regulations_ru.epub Land_Ownership_ru.epub \
	The_Articles_of_the_Preparatory_Committee_ru.epub ) \
	$(addprefix $(LAWS_DOCS)/sr/, Adjudication_of_Civil_Disputes_sr.epub \
	Administration_of_Justice_sr.epub Corporate_Regulations_sr.epub Land_Ownership_sr.epub \
	The_Articles_of_the_Preparatory_Committee_sr.epub )

all: make-dir update-source update-transifex const-docs laws-docs

init:
	$(GIT) clone $(CONST_REPO) $(CONST_SOURCE)
	$(GIT) clone $(LAWS_REPO) $(LAWS_SOURCE)

make-dir:
	@mkdir -p $(CONST_DOCS)/en $(CONST_DOCS)/cs $(CONST_DOCS)/de $(CONST_DOCS)/fr \
	$(CONST_DOCS)/hr $(CONST_DOCS)/hu $(CONST_DOCS)/ru $(CONST_DOCS)/sr
	@mkdir -p $(LAWS_DOCS)/en $(LAWS_DOCS)/cs $(LAWS_DOCS)/de $(LAWS_DOCS)/fr \
	$(LAWS_DOCS)/hr $(LAWS_DOCS)/hu $(LAWS_DOCS)/ru $(LAWS_DOCS)/sr

update-source:
	cd $(CONST_SOURCE) && $(GIT) fetch && $(GIT) pull
	cd $(LAWS_SOURCE) && $(GIT) fetch && $(GIT) pull

update-transifex:
	$(TX) pull -a && $(TX) push -s

const-docs: $(CONST_PDF_FILES) $(CONST_MOBI_FILES) $(CONST_HTML_FILES) $(CONST_EPUB_FILES)
#	need to add "last updated"

laws-docs: $(LAWS_PDF_FILES) $(LAWS_MOBI_FILES) $(LAWS_HTML_FILES) $(LAWS_EPUB_FILES)
#	@-rm $(LAWS_INDEX)
#	@echo "% Liberland Laws and Provisions\n%\n% Last updated: $(DATE)" > $(LAWS_INDEX)
#	Need to add "last updated"

$(CONST_PDF_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) $(PDF_OPTIONS) $< -o $@

$(CONST_MOBI_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) $< -o $@

$(CONST_HTML_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) --standalone --to=html5 $< -o $@

$(CONST_EPUB_FILES): $(CONST_MD_FILES)
	$(PANDOC) $(PD_OPT) $< -o $@

$(LAWS_PDF_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) $(PDF_OPTIONS) $< -o $@

$(LAWS_MOBI_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) $< -o $@

$(LAWS_HTML_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) --standalone --to=html5 $< -o $@

$(LAWS_EPUB_FILES): $(LAWS_MD_FILES)
	$(PANDOC) $(PD_OPT) --epub-metadata=metadata/laws.yaml $< -o $@

