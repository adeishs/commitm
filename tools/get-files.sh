#!/bin/zsh

#
# To be run from within the top-level 'commitm' checkout directory.
#

DATA_DIR=commitm.d/descriptions

mkdir -p $DATA_DIR

get_text() {
    url="$1"
    local_name="$DATA_DIR/$2"
    local_cleaned_name="$local_name.clean"

    if [ ! -f "$local_name" ]; then
        echo "Fetching[$url] -> [$local_name]"
        curl "$url" > "$local_name"
    else
        echo "File [$local_name] exists, skipping fetch"
    fi

    if [ ! -f "$local_cleaned_name" ]; then
        echo "Normalising/cleaning[$local_name] -> [$local_cleaned_name]"
        perl tools/clean-file.pl "$local_name" > $local_cleaned_name
    else
        echo "File [$local_cleaned_name] exists, skipping clean"
    fi
}

get_text "https://www.gutenberg.org/files/1514/1514-0.txt" midsummers-night-dream.txt
get_text "https://www.gutenberg.org/files/27761/27761-0.txt" hamlet.txt
