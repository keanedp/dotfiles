#!/usr/bin/env zsh

export TIMEFMT='%U user %S system %P cpu %*E total'

for i ({1..10}) time zsh -ilc echo &>/dev/null || true 
