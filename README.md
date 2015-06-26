[![liberland](http://liberland.org/addons/image/Liberland_znak_small.png)](https://github.com/liberland/liberland)

# Liberland Translation Project
The Liberland translation project aims to make all essential Liberland documents available in as many languages as possible. At the present time, this project is translating documents from the following repositories:

* [Constitution](https://github.com/liberland/constitution)
* [Laws](https://github.com/liberland/laws)

The translation of individual source files is done using a simple web-based interface offered by [Transifex](https://www.transifex.com/). In brief, the project administrators upload the english source files to Transifex, the files are translated online by the community, and the administrators pull the translated files back into this project. All translated files are then converted to several formats, including PDF, ePub, Mobi, and html.

**Please note that the English version shall always prevail in case of any discrepancy or inconsistency between the English version and any translation.**

## How to translate files

To get started translating files on Transifex, follow these steps:

* Go to the [Transifex](https://www.transifex.com) website, click on login, and then create a new account.
* After verifying your account, click on the link *Explore* and search for *Liberland*. 
* The Liberland organization has two translation projects: *constitution* and *laws*. Select one, click on *join team*, select the language you want to translate, and then wait to be approved by the administrator. If the language that you want to translate is not there, instead of clicking on *join team*, click *request language*.
* After approval, go to the [Liberland dashboard](https://www.transifex.com/organization/liberland/dashboard) and then click on the language you want to translate. Click the project *constitution* or *laws*, choose the resource to be translated, and finally click *translate* in the pop-up window. The rest should be obvious.

When translating, please note the following:

* The original source files are in "markdown" format and contain some text formatting characters (such as \#, \#\#, \#\#\#, \*, \*\*, >, and §). **Please keep all formatting characters in the translated text.**
* If the original source changes, the previous translation will not be shown by default. Nevertheless, Transifex keeps a record of all previous translations, and if the new phrase is similar to the previous one, transifex will suggest translated strings under the tabs *suggestions* or *history*.


## How to update source and translated files

To use this repo as an administrator, first use the command

    make init
    
This will clone the source directories into the *source* subdirectory of the translations git. This only needs to be done once. Next, type

    make
    
This will push the source files to Transifex, pull any new translated files into your project, and then convert all files to PDF, ePub, Mobi and html formats.

To use the makefile you will need to install both **pandoc** and the **transifex client**. The transifex client can be installed using the command

    pip install transifex-client==0.11.1.beta

## Outdated files - Please update on Transifex

The following translated files are outdated and have not been imported into transifex. Before working on these languages, it would be useful to put these into the Transifex Project. These files will eventually be deleted.

* **Czech / čeština**
  * [Návrh Ústavy Svobodné republiky Liberland](languages/cs/Liberland-constitution-cs.md) (in progress - 66%)

* **Serbian / srpski / српски**
  * [Слободна Република Либерланд – нацрт Устава](languages/sr/Liberland-constitution-sr.md) (23.4.2015)


