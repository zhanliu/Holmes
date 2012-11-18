#-------------------------------------------------------------------------------
# Name:        模块1
# Purpose:
#
# Author:      frwang
#
# Created:     29-02-2012
# Copyright:   (c) frwang 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#!/usr/bin/env python
import subprocess
import os

p = subprocess.Popen("cmd /C dir C:\\windows")
rcode = p.poll()
while rcode == None :
    print("not done")
    rcode =p.poll()

print('done')
