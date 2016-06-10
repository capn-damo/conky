#!/bin/bash
#
## e-weather.sh by <damo> June 2016
## Adapted from bunsenweather.sh, which was based on ideas from 
## weatherbang.sh version 1.0, 2013 by Ryan Fantus
##
## Requires:
##          'jq' (sudo apt-get install jq);
##          API Key from http://openweathermap.org/api
##
## USAGE: Call this script from Conky with ( replace "<t>" with the update interval)
##          ${execpi <t> $HOME/.config/conky/scripts/bunsenweather.sh [location]}


#### User configurables:  ##############################################

# Get API KEY by registering for one at http://openweathermap.org/api
api="your very long api number"

# Either set the location manually here, or by passing it as a script parameter in the Conky
place="$1"
#place="yourlocation"

# Choose fahrenheit/Imperial or Celcius/metric:
#metric='imperial' && unit='F'
metric='metric' && unit='C'

#########################################################################
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
    printf "%s: %s\n\${goto 100}Wind: %d m/s, from %.3d°\n\${goto 100}Temp: %d°c" "$city" "$condition" "$wind" "$winddir" "$temperature" 2>/dev/null
else
    echo "\${goto 100}No internet connection"
    echo "\${goto 100}  Weather information"
    echo "\${goto 100}  unavailable"
fi

exit
