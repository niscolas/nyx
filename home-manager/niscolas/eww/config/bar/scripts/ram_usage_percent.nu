#!/usr/bin/env nu

free -m
| lines
| find "Mem:"
| split column -c " "
| collect { |x| (($x | get 0.column3 | into int) / ($x | get 0.column2 | into int)) * 100 | into int }
