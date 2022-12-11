#!/bin/bash

_get_val() {
  local -r fName="$1" ; shift
  local -r defVal="$1" ; shift
  _grp() {
    grep -E "^${fName}=" build.config | cut -f 2- -d '='
  }
  local -r val="$( _grp )"
  if [ "xx" == "x${val}x" ] ; then
    echo "${defVal}"
  else
    echo "${val}"
  fi
}

_exp_if_exists() {
  local -r fName="$1" ; shift
  local -r eName="$1" ; shift
  local -r val="$( _get_val ${fName} "$@" )"
  if [ "xx" != "x${val}x" ] ; then
    echo "export ${eName}='$( echo ${val} | sed "s/'/\\\\x27/g" )'"
  fi
}

_exp() {
  local -r X_MODULES=$( _get_val modules )
  cat <<EOF
export USER_PROLOG='$(                    _get_val prolog 'built on nodemcu-build.com provided by frightanic.com' )'
export X_EMAIL=$(                         _get_val email )
export X_BRANCH='$(                       _get_val branch )'
export X_MODULES='${X_MODULES}'
export X_U8G_FONTS='$(                    _get_val u8g-fonts )'
export X_U8G_DISPLAY_I2C='$(              _get_val u8g-display-i2c )'
export X_U8G_DISPLAY_SPI='$(              _get_val u8g-display-spi )'
export X_UCG_DISPLAY_SPI='$(              _get_val ucg-display-spi )'
export X_LUA_FLASH_STORE=$(               _get_val lfs-size )
export X_SPIFFS_FIXED_LOCATION=$(         _get_val spiffs-base )
export X_SPIFFS_MAX_FILESYSTEM_SIZE=$(    _get_val spiffs-size )
export X_SSL_ENABLED=$(                   _get_val ssl-enabled )
export X_DEBUG_ENABLED=$(                 _get_val debug-enabled )
export X_FATFS_ENABLED=$(                 _get_val fatfs-enabled )
export X_NUMBER_OF_MODULES=$(echo "${X_MODULES}" | awk -F\, '{print NF}')
EOF
  _exp_if_exists spiffs-1mboundary X_SPIFFS_SIZE_1M_BOUNDARY
  _exp_if_exists repository X_REPO
  _exp_if_exists lua X_LUA
  _exp_if_exists lua-init X_LUA_INIT_STRING
} 

_exp > ./.env-vars

cat ./.env-vars
