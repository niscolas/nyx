#!/usr/bin/env nu

def main [file: string] {
    if (echo $file | path exists) {
        if (not ($file | find .tar.bz2 | is-empty)) {
            tar xjvf $file
        } else if (not ($file | find .tar.gz | is-empty)) {
            tar xzvf $file
        } else if (not ($file | find .bz2 | is-empty)) {
            bunzip2 $file
        } else if (not ($file | find .rar | is-empty)) {
            rar x $file
        } else if (not ($file | find .gz | is-empty)) {
            gunzip $file
        } else if (not ($file | find .tar | is-empty)) {
            tar xf $file
        } else if (not ($file | find .tbz2 | is-empty)) {
            tar xjvf $file
        } else if (not ($file | find .tgz | is-empty)) {
            tar xzvf $file
        } else if (not ($file | find .zip | is-empty)) {
            unzip $file
        } else if (not ($file | find .Z | is-empty)) {
            uncompress $file
        } else if (not ($file | find .7z | is-empty)) {
            7z x $file
        } else {
            [ $file, " cannot be extracted with this program" ] | str join
        }
    } else {
        [ $file, " is not a valid file" ] | str join
    }
}
