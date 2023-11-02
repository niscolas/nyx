#!/usr/bin/env nu

def main [action: string] {
    mut mut_action = $action
    if $mut_action == "auto" {
        $mut_action = (display_setup.nu format)
    }

    if $mut_action == "dual" {
        use_with_offset
    } else if ($mut_action == "hdmi" or $mut_action == "internal") {
        use_in_place
    }
}

def use_with_offset [] {
    stalonetray --geometry 1x1-1962+14
}

def use_in_place [] {
    stalonetray --geometry 1x1-42+14
}
