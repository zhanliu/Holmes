; 导入数据到金字塔程序
; 数据都是从金字塔ftp 下载，目录结构是这样的：
;  < 目录 >
;     |-----国内股票历史K线数据
;	  |			|
;	  |			|------1分钟K线数据
;	  |			|------5分钟K线数据
;	  |			|------日K线数据
;	  |
;     |-----国内期货历史K线数据
;	  			|
;	  			|------1分钟K线数据
;	  			|------5分钟K线数据
;	  			|------日K线数据

;每个数据文件夹里面都是很多rar文件。本程序就是解压rar，然后把得到的DAD文件导入金字塔，然后把已经完成的DAD文件删除，原始rar文件move到当前文件夹下
;一个叫做finished的子文件夹当中去

; 执行导入之前需要手工创建好 finished文件夹

;#RequireAdmin  ;this line is for win7
#include <File.au3>
AutoItSetOption("MustDeclareVars",1)


Dim $baseDir = "H:\jade\data"  ;need to change this depend on actual location

main()

Func main()


	Dim $jztWin = WinActivate("金字塔")
	Dim $cmd = '"c:\program files\7-zip\7z.exe" e -y '  ;7zip 安装路径
	Dim $datamanager




	;MsgBox(0,"handler is",$jztWin)
	WinActivate($jztWin)

	If WinExists("数据管理器") Then
		$datamanager = WinActivate("数据管理器")
    Else

		Send("^d") ;send control+d
		$datamanager=WinWait("数据管理器")
	EndIf
	ControlClick($datamanager,"","SysTabControl321","left",1,267,5)  ;click 导入数据 tab
	Local $subFolders =  _FileListToArray($baseDir , "*" , 2)  ;read sub folders
	If @error = 4 Then
		;MsgBox(0,"","no subFolders")
		Return
	EndIf
	For $i =1 To $subFolders[0]
		Local $subFolderName = $subFolders[$i]
		;MsgBox(0,"subfolderName",$subFolderName)
		if $subFolderName = "国内股票历史K线数据" or $subFolderName="国内期货历史K线数据" Then
			Local $folders[3] =["日K线数据","5分钟K线数据","1分钟K线数据"]
			For $dataFolderName in $folders
				 Local $fullPath = $baseDir&"\"& $subFolderName & "\" & $dataFolderName
				 ;MsgBox(0,$dataFolderName,$fullPath)
				 Switch $dataFolderName  ;根据导入类型来选择下拉框
					Case "1分钟K线数据"
						ControlCommand($datamanager,"","ComboBox5","SelectString","1分钟数据")

					Case "5分钟K线数据"

						ControlCommand($datamanager,"","ComboBox5","SelectString","5分钟数据")

					Case "日K线数据"
						ControlCommand($datamanager,"","ComboBox5","SelectString","日线数据")

					Case Else

						ContinueLoop ;防止有其他目录，有就跳过
				EndSwitch
				FileChangeDir($fullPath)
				;MsgBox(0,"fullpath",$fullPath)
				Local $rarFiles = _FileListToArray($fullPath , "*.rar" , 1)
				If @error = 4 Then  ;没有rar文件，说明文件夹里面没有需要导入的文件，可以continue loop去下一种数据类型
					;MsgBox(0,"no file","no rar file")
					ContinueLoop
				EndIf
				Local $finishedDir = _FileListToArray($fullPath , "finished" , 2)
				If @error = 4 Then ;finished folder doesnot exist
					DirCreate($fullPath & "\finished")
					;MsgBox(0,"info","finished folder created")
				EndIf

				For $i =1 To $rarFiles[0]
					Local $rarFileName = $rarFiles[$i]
					ToolTip("uncompressing" & $rarFileName)
					RunWait(@ComSpec & " /C " & $cmd & $rarFileName); uncompress
					ToolTip("uncompressfinished")
					RunWait(@ComSpec & " /C move /Y " & $rarFileName & " ./finished/" )
					ToolTip("File Moved: " & $rarFileName)
					Local $dadFile = _FileListToArray($fullPath , "*.DAD" , 1) ;we should have 1 DAD file
					Local $dadFileName = $fullPath&"\"&$dadFile[1]
					ToolTip("begin import: " & $rarFileName)
					import($dadFileName)
					ToolTip("finished import: " & $rarFileName)
					;FileMove($fullPath&"\"&$rarFileName, $fullPath&"\finised\"&$rarFileName) ;move to finished

					RunWait(@ComSpec & ' /C del /Q *.DAD"') ; remove DAD file
					ToolTip("DAD file removed for: " & $rarFileName)
					sleep(500)
				Next
			Next
		EndIf
	Next



EndFunc




Func import($fileName)

	Local $dm
	$dm = WinActivate("数据管理器")

	ControlSetText($dm,"","Edit2",$fileName)
	sleep(500)
	ControlClick($dm,"","Button50")
	;MouseClick("left",767,630)
	WinWait("金字塔","共导入了")
	WinClose("金字塔","共导入了")
EndFunc
