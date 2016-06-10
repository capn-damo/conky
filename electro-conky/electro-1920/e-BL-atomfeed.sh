#!/bin/bash
#
# e-BL-atomfeed.sh by <damo> June 2016, for use by electro-1920.conky
#
# extract text between "CDATA[" and "]]" (Post title text)
# cut first line with tail
# keep first 6 lines from result of tail
URL="https://forums.bunsenlabs.org/extern.php?action=feed&type=atom"

connectiontest() {
    local -i i attempts=${1-0}
    for (( i=0; i < attempts || attempts == 0; i++ )); do
        if wget -O - 'http://ftp.debian.org/debian/README' &> /dev/null; then
            return 0
        fi
        if (( i == attempts - 1 )); then # if last attempt
            return 1
        fi
    done
}

connectiontest 10

if (( $? == 0 ));then
    curl -s "$URL" | grep "<title" | grep -o -P '(?<=CDATA\[).*(?=\]\])'| tail -n +2 | head -n 6 | cut -c 1-60 | sed 's/^/${goto 358}/'
else
    echo "\${goto 358}No internet connection"
    echo "\${goto 358}Forum feed unavailable"
    echo "\${goto 358}"
    echo "\${goto 358}"
    echo "\${goto 358}"
    echo "\${goto 358}"
fi
