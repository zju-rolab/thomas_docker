#!/bin/bash

read_confirm_y ()
{
  tips=$1
  unset confirm
  if [ $# -eq 1 ]; then
    read -n 1 -p "${tips}? (Y/n) " comfirm
  else
    read -t $2 -n 1 -p "${tips}? (Y/n) " comfirm
  fi
  echo "" >&2 
  confirm=${confirm:-Y}
  if [ "$confirm" = 'n' ] || [ "$confirm" = 'N' ]; then
    echo false
  else
    echo true
  fi
}

read_confirm_n ()
{
  tips=$1
  unset confirm
  if [ $# -eq 1 ]; then
    read -n 1 -p "${tips}?(y/N) " confirm
  else
    read -t $1 -n 1 -p "${tips}?(y/N) " confirm
  fi
  echo "" >&2
  confirm=${confirm:-N}
  if [ "$confirm" = 'y' ] || [ "$confirm" = 'Y' ]; then
    echo true
  else
    echo false
  fi
}