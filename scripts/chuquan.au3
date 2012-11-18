; 用来导入除权数据，用了绝对坐标值，需要修改。
#RequireAdmin

#include <File.au3>

AutoItSetOption("MustDeclareVars",1)
main()

Func main()
;   if WinExists("金字塔决策交易系统") Then
	   ;Msgbox(0,"exists","jzt exists")
	;EndIf
	Local $fullPath = "D:\temp\除权数据"
	Local $cmd = '"c:\program files\7-zip\7z.exe" e '
	FileChangeDir($fullPath)
	Local $rarFiles = _FileListToArray($fullPath , "*.rar" , 1)

	Dim $jztWin = WinActivate("金字塔决策交易系统")
	Dim $datamanager
	;MsgBox(0,"handler is",$jztWin)
	WinActivate($jztWin)

	If WinExists("数据管理器") Then
		$datamanager = WinActivate("数据管理器")
    Else

		 Send("^d") ;send control+d
		$datamanager=WinWait("数据管理器")
	 EndIf

	 For $i =1 To $rarFiles[0]
			Local $rarFileName = $rarFiles[$i]

			RunWait(@ComSpec & " /C " & $cmd & $rarFileName); uncompress
			Local $dadFile = _FileListToArray($fullPath , "*.txt" , 1) ;we should have 1 DAD file
			Local $dadFileName = $fullPath&"\"&$dadFile[1]

			;ControlClick($datamanager,"","[CLASS:SysTabControl32; INSTANCE:1]","left",1,326,8)
			;MsgBox(0,"ready to click button", "ready!")
			MouseMove(769,566)
			MouseClick("left",769,566)
	;ControlClick($datamanager,"","[CLASS:Button; INSTANCE:9]","left")
	WinWait("金字塔","是否清空")
	;ControlClick("金字塔","是否清空","[CLASS:Button; INSTANCE:2]")
	MouseClick("left",655,591)
	;WinWaitClose("金字塔","是否清空")
	WinWait("引入除权数据文件")
	MouseMove(890,703)
	MouseClick("left")
	MouseMove(830,733)
	MouseClick("left")
			MouseMove(750,478)
			MouseClick("left")
			;ControlClick("引入除权数据文件","","[CLASS:Button; INSTANCE:5]","left")
			MouseClick("left",1074,678) ;click the import button
			WinWait("金字塔","共导入")
			WinClose("金字塔","共导入")


			;import($dadFileName)
			;FileMove($fullPath&"\"&$rarFileName, $fullPath&"\finised\"&$rarFileName) ;move to finished
			RunWait(@ComSpec & " /C move /Y " & $rarFileName & " ./finished/" )
			RunWait(@ComSpec & ' /C del /Q *.txt"') ; remove txt file
			sleep(500)
		Next




	;MouseClick("left",659,347)





EndFunc

