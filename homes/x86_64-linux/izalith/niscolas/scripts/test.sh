#!/usr/bin/env bash

acpi -b | sed 's/\,//g' 
