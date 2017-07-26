#!/bin/bash

set -e

weather_icon() {
  case $1 in
    clear-day) echo 😎
      ;;
    clear-night) echo 🌃
      ;;
    rain) echo ☔️
      ;;
    snow) echo ❄️
      ;;
    sleet|hail) echo 🌨
      ;;
    wind) echo 🌬
      ;;
    fog) echo 🌫
      ;;
    cloudy) echo ☁️
      ;;
    partly-cloudy-day) echo 🌥
      ;;
    partly-cloudy-night) echo ☁︎
      ;;
    thunderstorm) echo ⛈
      ;;
    tornado) echo 🌪
      ;;
    *) echo 🌎 $1
  esac
}

get_weather_data() {
  LOCATION=$(curl --silent http://ip-api.com/csv)
  LAT=$(echo "$LOCATION" | cut -d , -f 8)
  LONG=$(echo "$LOCATION" | cut -d , -f 9)

  WEATHER=$(curl --silent https://api.darksky.net/forecast/"$DARKSKY_API_KEY"/"$LAT","$LONG"?exclude=hourly,minutely,daily,alerts,flags)

  SUMMARY=$(echo "$WEATHER" | jq .currently.summary | sed s/\"//g)
  ICON=$(echo "$WEATHER" | jq .currently.icon | sed s/\"//g)
  TEMP="$(echo "$WEATHER" | jq .currently.temperature | xargs printf "%.f\n")°F"
  WIND_SPEED="$(echo "$WEATHER" | jq .currently.windSpeed | xargs printf "%.f") MPH"
  EMOJI=$(weather_icon $ICON)

  WEATHER_STATUS="$EMOJI $SUMMARY $TEMP, $WIND_SPEED"
  echo $WEATHER_STATUS > ~/Dropbox/weather.txt
  echo $WEATHER_STATUS
}

get_weather_data

