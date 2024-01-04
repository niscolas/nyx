#!/usr/bin/env nu

def main [action: string] {
    mut mut_action = $action
    if $mut_action == "format" {
        return (format_setup)
    } else if $mut_action == "is_internal" {
        return (is_internal)
    }

    if $mut_action == "auto" {
        $mut_action = (format_setup)
    }

    if $mut_action == "dual" {
        use_dual
    } else if $mut_action == "internal" {
        use_internal
    } else if $mut_action == "hdmi" {
        use_hdmi
    }

    if not (ps | find eww | is-empty) { pkill eww }

    my-eww-bar

    if not (ps | find stalonetray | is-empty) { pkill stalonetray }

    sleep 1sec
    tray.nu $action
}

def format_setup [] {
    if (is_internal) {
        return "internal"
    } else {
        return "dual"
    }
}

def is_internal [] {
    let result = (xrandr --listmonitors | find HDMI | is-empty)
    return $result
}

def get_connected_monitor [name: string] {
    let result = (xrandr
        | lines
        | split column " "
        | get column1
        | find $name
        | first)
    return $result
}

def get_internal [] { return (get_connected_monitor "eDP") }

def get_hdmi [] { return (get_connected_monitor "HDMI") }

def use_dual [] {
    let internal = (get_internal)
    let hdmi = (get_hdmi)

    (xrandr
        --output $internal
            --mode 1920x1080
            --pos 0x1080
            --rate 144.0
        --output $hdmi
            --primary
            --mode 1920x1080
            --rate 144.0
            --pos 0x0)
}

def use_internal [] {
    let internal = (get_internal)
    let hdmi = (get_hdmi)

    if ($hdmi | is-empty) {
        (xrandr
            --output $internal
                --primary
                --mode 1920x1080
                --rate 144.0)
    } else {
        (xrandr
            --output $internal
                --primary
                --mode 1920x1080
                --rate 144.0
            --output $hdmi
                --off)
    }
}

def use_hdmi [] {
    let internal = (get_internal)
    let hdmi = (get_hdmi)

    (xrandr
        --output $hdmi
            --primary
            --mode 1920x1080
            --rate 144.0
        --output $internal
            --off)
}
