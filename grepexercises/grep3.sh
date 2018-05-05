#!/bin/sh
#Print all lines that contain a date. Hint: this is a very simple pattern. It does not have to work for any year before 2000.
egrep '^[A-Za-z]{3}\.\s[1-9]{1,2},\s[0-9]{4}$' grepdata.txt
