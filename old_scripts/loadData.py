#-------------------------------------------------------------------------------
# Name:        濡€虫健1
# Purpose:
#
# Author:      frwang
#
# Created:     29-02-2012
# Copyright:   (c) frwang 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#!/usr/bin/env python

import cx_Oracle
import os
import fnmatch
import datetime
import subprocess

tdx_export_dir = "C:\\tools\\newone\\T0002\\export"

def main():
    DATA_PATH="C:\\projects\\astock\\data"
    os.chdir(DATA_PATH)

    execCMD_Wait("c:\\projects\\astock\\bin\\export_today_data.exe")
    execCMD_Wait("del /Q c:\\projects\\astock\\data\*.*")
    execCMD_Wait("move /Y "+tdx_export_dir+"\\*.txt c:\\projects\\astock\\data")

    #logFile = open("C:/projects/astock/log/upload_data.log","a")
    #logFile.writelines("Upload Started at:" + datetime.datetime.today().ctime()+" \n")
    #failedCodes = set()
    fnames = fnmatch.filter(os.listdir(DATA_PATH), '*.txt')
    failedCodes = uploadData(fnames)
    generateExtTables(failedCodes)
    uploadData(failedCodes)

    #now it's OK to delete data







def uploadData(listOfCodes):
    connection = cx_Oracle.Connection("dkt/dktdkt@DKT")
    cursor = connection.cursor()
    logFile = open("C:/projects/astock/log/upload_data.log","a")
    logFile.writelines("Upload Started at:" + datetime.datetime.today().ctime()+" \n")
    failedCodes = set()
    for codeName in listOfCodes:
            codeName=codeName[0:6]
            f = open(codeName+".txt")
            firstLine=f.readline().strip()
            date=firstLine[0:firstLine.index(' ')]
            stockName = firstLine[firstLine.index(' ')+1:firstLine.index('(')-1]
            f.close()
            try:
                logFile.writelines("Inserting "+ codeName +" "+stockName+"\n")
                print("Inserting "+ codeName +" "+stockName+"\n")

                #cursor.execute("insert /*+ APPEND */ into TDX_TRANSACTION select '"+codeName+"','"+stockName+"', to_date('"+date+"','YYYYMMDD'),tran_price,sum(tran_vol),sum(tran_count),null,null from ext_"+codeName+" group by tran_price")
                cursor.execute("delete from stock_mean where stock_code='"+codeName+"' and trade_day=to_date('"+date+"','YYYYMMDD')")
                cursor.execute("insert /*+ APPEND */ into stock_mean select '"+codeName+"','"+stockName+"' , to_date('"+date+"','YYYYMMDD'), sum(tran_price*tran_vol)/sum(tran_vol),min(tran_price) ,max(tran_price),  round((sum(tran_price*tran_vol)/sum(tran_vol))/(max(tran_price)-min(tran_price)),4 ),0 from ext_"+codeName)
                connection.commit()
                logFile.writelines("Insert "+ codeName +" "+stockName+" Done\n")
                print("Insert "+ codeName +" "+stockName+" Done\n")
            except cx_Oracle.Error as exc:
                error=exc.args[0]
                logFile.writelines("Insert "+ codeName +" "+stockName+" Failed\n")
                logFile.writelines(str(error.code)+" "+error.message)
                print(str(error.code)+" "+error.message)
                if error.code ==49 :
                        failedCodes.add(codeName)

    logFile.writelines("Upload data done " +datetime.datetime.today().ctime()+"\n")
    print("Upload data done " +datetime.datetime.today().ctime()+"\n")
    logFile.writelines("=============Failed List===============\n")
    print("=============Failed List===============\n")
    for item in failedCodes:
            print(item)
            logFile.writelines(item+"\n")
    logFile.close()
    cursor.close()
    connection.close()
    return failedCodes

def generateExtTables(listOfCodes):
    for code in listOfCodes:
            generateExtTableScript(code)


def generateExtTableScript(codeName):
    sqltxt = "CREATE TABLE ext_"+codeName[0:6]+ \
    '('
    'tran_time      varchar(6),'
    'tran_price     number(10,3),'
    'tran_vol  number(10),'
    'tran_count  number(10),'
    'tran_flag varCHAR(2))'
    'ORGANIZATION EXTERNAL'
    ' (TYPE ORACLE_LOADER'
    ' DEFAULT DIRECTORY dkt_workdir'
    '  ACCESS PARAMETERS'
    '    ('
    '    RECORDS DELIMITED BY NEWLINE'
    '    SKIP 3'
    '    FIELDS TERMINATED BY WHITESPACE'
    '    MISSING FIELD VALUES ARE NULL'
    '    REJECT ROWS WITH ALL NULL'
    '    FIELDS'
    '    (tran_time  char,'
    '      tran_price     char,'
    '      tran_vol  integer external(255),'
    '      tran_count  integer external(255),'
    '      tran_flag CHAR(2)'
    '       )'
    '   )'
    "  LOCATION ('"+codeName[0:6]+".txt')"
    ');'

    connection = cx_Oracle.Connection("dkt/dktdkt@DKT")
    try:
        print(sqltxt)
        cursor = connection.cursor()
        cursor.execute(sqltxt)
    except cx_Oracle.Error as exc:
                error=exc.args[0]
                logFile.writelines(str(error.code)+" "+error.message)
                print(str(error.code)+" "+error.message)
    finally:
        connection.close()

def main_bak():
    DATA_PATH="C:/projects/astock/data"
    os.chdir(DATA_PATH)
    connection = cx_Oracle.Connection("dkt/dktdkt@DKT")
    cursor = connection.cursor()
    logFile = open("C:/projects/astock/log/upload_data.log","a")
    logFile.writelines("Upload Started at:" + datetime.datetime.today().ctime()+" \n")
    failedCodes = set()
    for file in fnmatch.filter(os.listdir(DATA_PATH), '*.txt'):
        codeName=file[0:len(file)-4]
        f = open(file)
        firstLine=f.readline().strip()
        date=firstLine[0:firstLine.index(' ')]
        stockName = firstLine[firstLine.index(' ')+1:firstLine.index('(')-1]
        f.close()
        try:
            logFile.writelines("Inserting "+ codeName +" "+stockName+"\n")
            print("Inserting "+ codeName +" "+stockName+"\n")
            #print("insert /*+ APPEND */ into TDX_TRANSACTION select rownum,'"+codeName+"','"+stockName+"', to_date('"+date+" '||tran_time,'YYYYMMDD HH24:MI'),sum(tran_price*tran_vol)/sum(tran_vol),sum(tran_vol),sum(tran_count),null,null from ext_"+codeName+" group by to_date('"+date+" '||tran_time,'YYYYMMDD HH24:MI')")
            cursor.execute("insert /*+ APPEND */ into TDX_TRANSACTION select '"+codeName+"','"+stockName+"', to_date('"+date+" '||tran_time,'YYYYMMDD HH24:MI'),sum(tran_price*tran_vol)/sum(tran_vol),sum(tran_vol),sum(tran_count),null,null from ext_"+codeName+" group by tran_time")
            connection.commit()
            logFile.writelines("Insert "+ codeName +" "+stockName+" Done\n")
            #print("Insert "+ codeName +" "+stockName+" Done\n")
        except cx_Oracle.Error as exc:
            error=exc.args[0]
            logFile.writelines("Insert "+ codeName +" "+stockName+" Failed\n")
            logFile.writelines(str(error.code)+" "+error.message)
            print(str(error.code)+" "+error.message)
            failedCodes.add(codeName)


        #print("insert into TDX_TRANSACTION select '"+date+codeName+"'||rownum,'"+codeName+"','"+stockName+"', to_date('"+date+"'||' '||tran_time,'YYYYMMDD HH24:MI'),tran_price,tran_vol,tran_count,tran_flag, null from ext_"+codeName)
    logFile.writelines("Upload data done " +datetime.datetime.today().ctime()+"\n")
    print("Upload data done " +datetime.datetime.today().ctime()+"\n")
    logFile.writelines("=============Failed List===============\n")
    print("=============Failed List===============\n")
    for item in failedCodes:
        print(item)
        logFile.writelines(item+"\n")
    logFile.close()
    cursor.close()
    connection.close()


def execCMD_Wait(cmdString):
    print(cmdString)
    p = subprocess.Popen("cmd /C "+cmdString)
    rcode = p.poll()
    while rcode == None :
            rcode = p.poll()




if __name__ == '__main__':
    main()
