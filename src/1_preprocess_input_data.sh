#!/bin/bash

## Vincent Major
## Created September 25 2017
## Last modified September 26 2017

## This script will take a raw xml file of pubmed articles,
## extract their pmids, years, titles and abstracts using R, and
## process the text and combine with manual labels using python.

## expecting one argument, remove the extension
BASEFILE=$(echo $1 | cut -f 1 -d '.')
INTERMEDIATE="$BASEFILE"_intermediate.xml
echo $INTERMEDIATE

#OUTFILE="$BASEFILE"_extracted.txt
OUTFILE=$2
echo $OUTFILE

## remove artifacts from pasting many xmls together
head -3 $1 | sed '2d' > $INTERMEDIATE
## inverse grep i.e. remove matching rows - act as OR
grep -v -e 'DOCTYPE' -e '<?xml version="1.0" ?>' -e '<PubmedArticleSet>' $1 >> $INTERMEDIATE
## matching does not match the last line which is simply "</PubmedArticleSet>"

## second, extract from the cleaned up XML
Rscript src/1_extract_id_year_title_abstract_from_raw_xml.R $INTERMEDIATE $OUTFILE
## which should create a file called $OUTFILE

echo "Done!"
