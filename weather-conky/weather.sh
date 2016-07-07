#!/bin/bash
#
## weather.sh by <damo> June 2016
## Adapted from bunsenweather.sh, which was based on ideas from 
## weatherbang.sh version 1.0, 2013 by Ryan Fantus
##
## Requires:
##          'jq' (sudo apt-get install jq);
##          API Key from http://openweathermap.org/api
##
## USAGE: Call this script from Conky with ( replace "<t>" with the update interval)
##          ${execi <t> /path/to/weather.sh [location]}
##
##      or  ${execpi <t> /path/to/weather.sh [location]} to display printf values directly in the conky
##
#### User configurables:  ##############################################

# Get API KEY by registering for one at http://openweathermap.org/api
api="your very long api number"

# Either set the location manually here, or by passing it as a script parameter in the Conky.
# "yourlocation" must be a name (which doesn't have spaces), or a numeric id.
#
# id's can be obtained from http://bulk.openweathermap.org/sample/city.list.json.gz
# Download and extract the json file, then simply search for an id with grep. 
#   For example:   grep "New York" city.list.json
#
# If $place is not set, then the script attempts to get a geolocation from the IP address.

place="$1"              # Get $place from script parameter.
#place="yourlocation"   # Uncomment and add name or id. NB If the name has spaces, then you must use the id.

# Choose fahrenheit/Imperial or Celcius/metric:
#metric='imperial'
metric='metric'

# data file
datafile="/path/to/weather-data.txt"

# set LANG, to ensure correct decimal formatting of output
LANG=en_GB.UTF-8

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

placeholder() {
    if (( $1 == 1 )) &>/dev/null;then
        echo "No internet connection"
        echo "Weather information unavailable"
    else
        echo "No API key"
        echo "Weather information unavailable"
    fi
}

if [[ $metric == metric ]] &>/dev/null;then
    scaleT="°C"
    scaleV="m/s"
else
    scaleT="°F"
    scaleV="mph"
fi

if [[ -z "$api" ]] &>/dev/null;then
    placeholder 0 && exit 1
else
    connectiontest 10
    
    # If latlong is preferred then don't set a value for $place
    if (( $? == 0 )) &>/dev/null;then
        if [[ -z $place ]] &>/dev/null;then
            # Geolocate IP:
            ipinfo=$(curl -s ipinfo.io)
            latlong=$(echo "$ipinfo" | jq -r '.loc')
            # Parse the latitude and longitude
            lat=${latlong%,*}
            long=${latlong#*,}
            location="lat=$lat&lon=$long"
        else
            # check if numeric id, or placename is being used
            [[ ${place##*[!0-9]*} ]] &>/dev/null && location="id=$place" || location="q=$place"
        fi

        # get json data from openweathermap:
        weather=$(curl -s http://api.openweathermap.org/data/2.5/weather\?APPID=$api\&"$location"\&units=$metric)
        city=$(echo "$weather" | jq -r '.name') # In case location has spaces in the name
        weather_desc=$(echo "$weather" | jq -r '.weather[0].description')   # In case description has spaces in the name

        # load values into array:
        all=($(echo "$weather" | jq -r '.coord.lon,.coord.lat,.weather[0].main,.main.temp,.main.pressure,.main.temp_min,.main.temp_max,.wind.speed,.wind.deg,.clouds.all,.sys.sunrise,.sys.sunset'))
        #                   ARRAY INDEX  0          1          2                3          4              5              6              7           8         9           10           11

        longitude=$(printf '%06.1f' ${all[0]})
        latitude=$(printf '%+.1f' ${all[1]})
        condition="${all[2]}"
        temperature=$(printf '%+.1f%s' ${all[3]} $scaleT)
        pressure=$(printf '%.f %s' ${all[4]} mb)
        temperature_min=$(printf '%+.1f%s' ${all[5]} $scaleT)
        temperature_max=$(printf '%+.1f%s' ${all[6]} $scaleT)
        cloud_cover=$(printf '%d%s' ${all[9]} %)
        sunrise=$(date -d @${all[10]} +"%R")
        sunset=$(date -d @${all[11]} +"%R")
        description="$weather_desc"
        
        winddir=${all[8]}
        if [[ $winddir = null ]];then
            echo "$winddir" > "$datafile"
        else
            echo ${winddir%.*} > "$datafile"
            winddir=$(printf '%3.f%s' $winddir} °)
        fi
        
        windspeed=$(echo ${all[7]}*1.9 | bc)
        windspeed=$(printf '%01.1f %s' "$windspeed" "kn")
        echo "$windspeed" >> "$datafile"
        echo "$sunrise" | sed 's/://' >> "$datafile"
        echo "$sunset" | sed 's/://'>> "$datafile"
        temp_degrees=$(printf '%.1f' ${all[3]})
        echo "$temp_degrees" >> "$datafile"
        echo "$city" >> "$datafile" 
        echo "$description" >> "$datafile"
        
        #Format for output in a conky, with ${execpi...}:
        #printf "%s: %s\n\${goto 100}Wind: %s, from %s\n\${goto 100}Temp: %s\n\${goto 100}Sunrise: %s\n\${goto 100}Sunset:  %s" \
        #"$city" "$condition" "$windspeed" "$winddir" "$temperature" "$sunrise" "$sunset" 2>/dev/null

    else
        placeholder 1
    fi
fi

exit
