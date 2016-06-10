#!/bin/bash

# extract text between "CDATA[" and "]]" (Post title text)
# cut first line with tail
# keep first 6 lines from result of tail
URL="https://forums.bunsenlabs.org/extern.php?action=feed&type=atom"

connectiontest() {
    local -i i attempts=${1-10}
    for (( i=0; i < attempts || attempts == 0; i++ )); do
        if wget -O - 'http://ftp.debian.org/debian/README' &> /dev/null; then
            return 0
        fi
        if (( i == attempts - 1 )); then # if last attempt
            return 1
        fi
    done
}

connectiontest

if (( $? == 0 ));then
    # Get 6 lines; trim to 50 chars; remove any '$' chars; add conky var code to beginning of line
    curl -s "$URL" | grep "<title" | grep -o -P '(?<=CDATA\[).*(?=\]\])'| tail -n +2 | head -n 6 | cut -c 1-50 | sed 's/\$//' | sed 's/^/${goto 263}/'  

else
    echo "\${goto 263}No internet connection"
    echo "\${goto 263}Forum feed unavailable"
    echo "\${goto 263}"
    echo "\${goto 263}"
    echo "\${goto 263}"
    echo "\${goto 263}"
fi
