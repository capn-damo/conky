#!/bin/bash
#
## e-weather.sh by <damo> June 2016,  for use by electro-1920.conky
## Adapted from bunsenweather.sh, which was based on ideas from 
## weatherbang.sh version 1.0, 2013 by Ryan Fantus
##
## Requires:
##          'jq' (sudo apt-get install jq);
##          API Key from http://openweathermap.org/api
##
## USAGE: Call this script from Conky with ( replace "<t>" with the update interval)
##          ${execpi <t> /path/to/e-weather.sh [location]}

#### User configurables:  ##############################################

# Get API KEY by registering for one at http://openweathermap.org/api
#api="your very long api number"
api=""

# Either set the location manually here, or by passing it as a script parameter in the Conky
place="$1"
#place="yourlocation"

# Choose fahrenheit/Imperial or Celcius/metric:
#metric='imperial' && unit='F'
metric='metric' && unit='C'

########################################################################
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

placeholder() {
    if (( $1 == 1 ));then
        echo "\${voffset -20}\${goto 230}No internet connection"
        echo "\${goto 230}  Weather information"
        echo "\${goto 230}  unavailable"
    else
        echo "\${voffset -20}\${goto 230}No API key"
        echo "\${goto 230}  Weather information"
        echo "\${goto 230}  unavailable"
    fi
}

if [[ -z "$api" ]] &>/dev/null;then
    placeholder 0 && exit 1
else
    connectiontest 10

    # If latlong is preferred then don't set a value for $place
    if (( $? == 0 ));then
        if [[ -z $place ]];then
            # Geolocate IP:
            ipinfo=$(curl -s ipinfo.io)
            latlong=$(echo $ipinfo | jq -r '.loc')
            # Parse the latitude and longitude
            lat=${latlong%,*}
            long=${latlong#*,}
            location="lat=$lat&lon=$long"
        else
            location="q=$place"
        fi
    
        weather=$(curl -s http://api.openweathermap.org/data/2.5/weather\?APPID\=$api\&$location\&units\=${metric})
        ### TODO: better to try and put the output into a jq array, to reduce the processes :/ ###
        city=$(echo $weather | jq -r '.name')
        temperature=$(printf '%.0f' $(echo $weather | jq '.main.temp'))
        condition=$(echo $weather | jq -r '.weather[0].main')
        wind=$(echo $weather | jq '.wind.speed')
        winddir=$(echo $weather | jq '.wind.deg')
    
        # Format the output with printf
        printf "\${voffset -20}%s: %s\n\${goto 230}Wind: %d m/s, from %.3d°\n\${goto 230}Temp: %d°c" "$city" "$condition" "$wind" "$winddir" "$temperature" 2>/dev/null
    else
        placeholder 1
    fi
fi

exit
