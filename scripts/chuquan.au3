; ���������Ȩ���ݣ����˾�������ֵ����Ҫ�޸ġ�
#RequireAdmin

#include <File.au3>

AutoItSetOption("MustDeclareVars",1)
main()

Func main()
;   if WinExists("���������߽���ϵͳ") Then
	   ;Msgbox(0,"exists","jzt exists")
	;EndIf
	Local $fullPath = "D:\temp\��Ȩ����"
	Local $cmd = '"c:\program files\7-zip\7z.exe" e '
	FileChangeDir($fullPath)
	Local $rarFiles = _FileListToArray($fullPath , "*.rar" , 1)

	Dim $jztWin = WinActivate("���������߽���ϵͳ")
	Dim $datamanager
	;MsgBox(0,"handler is",$jztWin)
	WinActivate($jztWin)

	If WinExists("���ݹ�����") Then
		$datamanager = WinActivate("���ݹ�����")
    Else

		 Send("^d") ;send control+d
		$datamanager=WinWait("���ݹ�����")
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
	WinWait("������","�Ƿ����")
	;ControlClick("������","�Ƿ����","[CLASS:Button; INSTANCE:2]")
	MouseClick("left",655,591)
	;WinWaitClose("������","�Ƿ����")
	WinWait("�����Ȩ�����ļ�")
	MouseMove(890,703)
	MouseClick("left")
	MouseMove(830,733)
	MouseClick("left")
			MouseMove(750,478)
			MouseClick("left")
			;ControlClick("�����Ȩ�����ļ�","","[CLASS:Button; INSTANCE:5]","left")
			MouseClick("left",1074,678) ;click the import button
			WinWait("������","������")
			WinClose("������","������")


			;import($dadFileName)
			;FileMove($fullPath&"\"&$rarFileName, $fullPath&"\finised\"&$rarFileName) ;move to finished
			RunWait(@ComSpec & " /C move /Y " & $rarFileName & " ./finished/" )
			RunWait(@ComSpec & ' /C del /Q *.txt"') ; remove txt file
			sleep(500)
		Next




	;MouseClick("left",659,347)





EndFunc

