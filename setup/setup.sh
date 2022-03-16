#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Require root privilege"
  exit 1
fi

# install deno
curl -fsSL https://deno.land/install.sh | sh

if [ $? -eq 0 ]; then
  deno -A https://raw.githubusercontent.com/kat0h/dotfiles/master/setup.ts
fi
