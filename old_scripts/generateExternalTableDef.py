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
import os
import fnmatch


def main():
    projectPath = "D:/projects/astock"
    scriptCode = """\
DROP TABLE ext_XXXXXX;
CREATE TABLE ext_XXXXXX
    (tran_time      varchar(6),
    tran_price     number(10,3),
    tran_vol  number(10),
    tran_count  number(10),
    tran_flag varCHAR(2))
ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
     DEFAULT DIRECTORY dkt_workdir
     ACCESS PARAMETERS
        (RECORDS DELIMITED BY NEWLINE
         BADFILE 'XXXXXX.bad'
         DISCARDFILE 'XXXXXX.dsc'
         SKIP 3
         FIELDS TERMINATED BY WHITESPACE
         MISSING FIELD VALUES ARE NULL
         REJECT ROWS WITH ALL NULL
         FIELDS
            (tran_time  char,
             tran_price     char,
             tran_vol  integer external(255),
             tran_count  integer external(255),
             tran_flag CHAR(2)
          )
        )
LOCATION ('XXXXXX.txt')
);
"""
    scriptFile = open("generateExternalTables.sql","w")
    for fileName in fnmatch.filter(os.listdir("d:\\projects\\astock\\tmp"),"*.txt"):
        txtFile = open(projectPath+"/tmp/"+fileName,mode="r")
        firstLine = txtFile.readline().strip()
        txtFile.close()
        stockCode = firstLine[firstLine.index('(')+1:firstLine.index(')')]
        stockName = firstLine[firstLine.index(' ')+1:firstLine.index('(')-1]
        scriptFile.write("----------"+stockCode+"  "+stockName+"\n")
        scriptFile.writelines(scriptCode.replace("XXXXXX",stockCode))

    scriptFile.write("exit;")
    scriptFile.close
    print("Finished")



    print(firstLine[0:firstLine.index(' ')])

#end of main



if __name__ == '__main__':
    main()
