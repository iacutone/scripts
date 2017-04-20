#!/bin/bash
#
# Weather
# =======
#
# By Jezen Thomas <jezen@jezenthomas.com>
#
# This script sends a couple of requests over the network to retrieve
# approximate location data, and the current weather for that location. This is
# useful if for example you want to display the current weather in your tmux
# status bar.

# There are three things you will need to do before using this script.
#
# 1. Install jq with your package manager of choice (homebrew, apt-get, etc.)
# 2. Sign up for a free account with OpenWeatherMap to grab your API key
# 3. Add your OpenWeatherMap API key where it says API_KEY

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

