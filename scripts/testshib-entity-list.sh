#!/bin/bash

# Retrieve Testshib.org's current entity list
# See http://www.testshib.org/entities.html

set -e

curl 'https://www.testshib.org/entities.html' 2>/dev/null | python -c '
import re
import sys
html = sys.stdin.read()
for m in re.finditer(r"strong>EntityID<\/strong>\s*([\S]*?)(<br>)?<", html):
    print(m.group(1))
'
