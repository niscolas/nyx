#!/usr/bin/env nu

def main [setup: string] {
  if $setup == "server" {
    start_server
  } else if $setup == "client" {
    start_client
  }
}

def start_server [] {
  input-leaps --no-daemon --disable-crypto --config ($env.XDG_CONFIG_HOME | path join "barrier/globant")
}

def start_client [] {
  while true {
    input-leapc --no-daemon --disable-crypto 192.168.100.37
    sleep 1sec
  }
}
