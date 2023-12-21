#!/usr/bin/env nu

let layout = (setxkbmap -query | lines | split column ":" | str trim | find "layout" | get column2 | first)
mut newlayout = ""

if $layout == "us" {
    $newlayout = "br"
} else {
    $newlayout = "us"
}

setxkbmap $newlayout
