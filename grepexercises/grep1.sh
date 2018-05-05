#!/bin/sh
#Print all lines that contain a phone number with an extension (the letter x or X followed by four digits).
egrep '[0-9]{3}-[0-9]{3}-[0-9]{4}(\s[0-9]+)?' grepdata.txt