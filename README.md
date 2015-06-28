[![liberland](http://liberland.org/addons/image/Liberland_znak_small.png)](https://github.com/liberland/liberland)

# Liberland Translation Project
The Liberland translation project aims to make all essential Liberland documents available in as many languages as possible. At the present time, this project is translating documents from the following repositories:

* [Constitution](https://github.com/liberland/constitution)
* [Laws](https://github.com/liberland/laws)

The translation of individual source files is done using a simple web-based interface that is offered by [Transifex](https://www.transifex.com/) to open source projects. The project administrators upload the english source files to Transifex, the files are translated online by the community, and the administrators pull the translated files back into this repository. All translated files are then converted to several formats for distribution, including pdf, ePub, Mobi, and html.

**Please note that the English version shall always prevail in case of any discrepancy or inconsistency between the English version and any translation.**

## How to translate files

To get started translating files on Transifex, follow these steps:

* Go to the [Transifex](https://www.transifex.com) website, click on *login*, and then *create a new account*.
* After verifying your account, click on the link *Explore* and search for *Liberland*. 
* The Liberland organization has two translation projects: *constitution* and *laws*. Select one, click on *join team*, select the language you want to translate, and then wait to be approved by the administrator. If the language that you want to translate is not there, instead of clicking on *join team*, click *request language*.
* After approval, go to the [Liberland dashboard](https://www.transifex.com/organization/liberland/dashboard) and then click on the language you want to translate. Click the project *constitution* or *laws*, choose the resource to be translated, and finally click *translate* in the pop-up window. The rest should be obvious.

When translating, please note the following:

* The original source files are in "markdown" format and contain some text formatting characters (such as \#, \#\#, \#\#\#, \*, \*\*, >, and §). **Please keep all formatting characters in the translated text.**
* If the original source file changes, the previous translation of the changed phrase will not be shown. However, Transifex does keep a record of all previous translations, and if the new phrase is similar to the previous one, transifex will suggest translated strings under the tab *suggestions*. Previous translations of the phrase can be found under the tab *history*.

## How to update source and translated files

To use this repo as an administrator, first enter the command

    make init
    
This will clone the source repos into the *source* subdirectory of this project. This needs to be done only once. Next, type

    make
    
This will update the source repos, push the source files to Transifex, pull any newly translated files into your project, and then convert all files to pdf, ePub, Mobi and html formats.

If new languages are added to the Transifex project, it will be necessary to modify the Makefile by adding the language code to the variables LANGCONST and/or LANGLAWS (for constitution and laws translations, respectively).

To use the makefile you will need to install both **pandoc** and the **transifex client**. The Transifex client can be installed using the command

    pip install transifex-client==0.11.1.beta

## Outdated files - Please update on Transifex

The following translated files are outdated and have not been imported into Transifex. Before working on these languages, it would be useful to put these into the Transifex Project. These files will eventually be deleted.

* **Czech / čeština**
  * [Návrh Ústavy Svobodné republiky Liberland](languages_old/cs/Liberland-constitution-cs.md) (in progress - 66%)

* **Serbian / srpski / српски**
  * [Слободна Република Либерланд – нацрт Устава](languages_old/sr/Liberland-constitution-sr.md) (23.4.2015)
