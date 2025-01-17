#!/bin/bash

# Wrapper executing ESP8266 or ESP32 targets

# current script dir
SCRIPT_DIR="$( cd $( dirname $0 ) && pwd )"

# this file is generated by export-env-vars.sh in working dir
source ${PWD}/.env-vars || { echo "[ERR] : missing or wrong ${PWD}/.env-vars" && exit 1 ; }

DEVTYPE="$( [ "$X_BRANCH" = "dev-esp32" ] && echo "ESP32" || echo "ESP8266" )"
BasePath="${SCRIPT_DIR}/${DEVTYPE}"

_main() {
  local -r CMD="$1" ; shift
  cd nodemcu-firmware || { echo "[ERR] : expects $(pwd)/nodemcu-firmware dir but found none" ; return 1 ; }
  case "${CMD}" in
    -install) ${BasePath}/intall.sh ;;
    -before)  ${BasePath}/before-script.sh ;;
    -script)  ${BasePath}/script.sh ;;
    *)        echo "[ERR]: unrecognized command : ${CMD}", return 1 ;;
  esac
}

_main "$@"