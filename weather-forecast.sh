#!/bin/bash

set -e

get_weather_data() {
  WEATHER_RESPONSE=$(curl https://api.weather.gov/gridpoints/MLB/26,68/forecast)

  FIRST_RESPONSE=$(echo "$WEATHER_RESPONSE" | jq .properties.periods | jq '.[0]')
  FORECAST=$(echo "$FIRST_RESPONSE" | jq .shortForecast | sed s/\"//g)
  TEMP=$(echo "$FIRST_RESPONSE" | jq .temperature | sed s/\"//g)
  WIND_SPEED=$(echo "$FIRST_RESPONSE" | jq .windSpeed | sed s/\"//g)

  WEATHER_STATUS="$FORECAST $TEMP, $WIND_SPEED"
  echo $WEATHER_STATUS > ~/Dropbox/weather.txt
  echo $WEATHER_STATUS
}

get_weather_data
