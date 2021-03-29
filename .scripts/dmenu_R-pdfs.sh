#!/bin/sh
# This script provides a dmenu interface to load, download and update R package
# help pdf files.
# Dependencies:
#   - dmenu
#   - notify-send
#   - grep
#   - awk
#   - sed
#   - curl
#   - pdftotext

# set some variables
PDF_VIEWER='zathura'
CACHE_DIR=$HOME/.cache/R-pdfs
DMENU_CMD='dmenu -i -fn "Ubuntu Mono:size=11" -nb "#161616" -nf "#D0D0D0" -sf \
		 "#161616" -sb "#1f63b5" -p "Select Package:"'

# create the cache directory
mkdir -p $CACHE_DIR

# load all cached pdf files
CACHED=$(ls $CACHE_DIR)

# dmenu prompt to select the wanted pdf file
PACKAGE=$(echo $CACHED | sed 's/.pdf//g;s/ /\n/g;s/$/\n~~update~~/' |
	      eval "$DMENU_CMD")

# exit if the dmenu prompt was canceled or nothing was entered
[ -n "$PACKAGE" ] || { echo 'No package selected'; exit 1; }

# check wether update was chosen
[ "$PACKAGE" = "~~update~~" ] && {
    # iterate over all cached files
    for f in $CACHED; do
	# get package name
	p=$(echo $f | sed 's/.pdf//g')
	# check the current version on CRAN
	REMOTE=$(curl -s https://cran.r-project.org/web/packages/$p/index.html |
		     grep -A1 Version: | tail -n 1 | sed 's/<td>//g;s/<\/td>//g')
	# check the verion in the PDF
	LOCAL=$(pdftotext $CACHE_DIR/$f -f 1 -l 1 - |
		    grep Version | awk '{print $2}')
	# echo the both versions (if called from console)
	echo $f' LOCAL: '$LOCAL' REMOTE: '$REMOTE
	
        [ $LOCAL != $REMOTE ] &&
	    wget -q https://cran.r-project.org/web/packages/$p/$p.pdf \
		 -O ~/.cache/R-pdfs/$p.pdf &&
	    notify-send 'Updated Package PDF' $p': '$LOCAL' -> '$REMOTE &
    done;
    # exit after update
    exit 0;
}

# if the chosen package is not cached yet, download it from CRAN
[ -n "$(echo $CACHED | grep -w $PACKAGE)" ] ||
    wget https://cran.r-project.org/web/packages/$PACKAGE/$PACKAGE.pdf \
	 -O ~/.cache/R-pdfs/$PACKAGE.pdf

# open package pdf when it exists
eval "$PDF_VIEWER $CACHE_DIR/$PACKAGE.pdf" &
