#-------------------------------------------------------------------------------
# Name:        模块1
# Purpose:
#
# Author:      frwang
#
# Created:     24-02-2012
# Copyright:   (c) frwang 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#!/usr/bin/env python

import subprocess
import os

def main():
    t=os.popen("sqlplus dkt/dktdkt @generateExternalTables.sql").read()
    print(t)

def uploadData():
    os.popen("sqlplus dkt/dktdkt @generateExternalTables.sql")  #recreate table


if __name__ == '__main__':
    main()
