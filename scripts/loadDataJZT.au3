; �������ݵ�����������
; ���ݶ��Ǵӽ�����ftp ���أ�Ŀ¼�ṹ�������ģ�
;  < Ŀ¼ >
;     |-----���ڹ�Ʊ��ʷK������
;	  |			|
;	  |			|------1����K������
;	  |			|------5����K������
;	  |			|------��K������
;	  |
;     |-----�����ڻ���ʷK������
;	  			|
;	  			|------1����K������
;	  			|------5����K������
;	  			|------��K������

;ÿ�������ļ������涼�Ǻܶ�rar�ļ�����������ǽ�ѹrar��Ȼ��ѵõ���DAD�ļ������������Ȼ����Ѿ���ɵ�DAD�ļ�ɾ����ԭʼrar�ļ�move����ǰ�ļ�����
;һ������finished�����ļ��е���ȥ

; ִ�е���֮ǰ��Ҫ�ֹ������� finished�ļ���

#RequireAdmin  ;this line is for win7
#include <File.au3>
AutoItSetOption("MustDeclareVars",1)


Dim $baseDir = "H:\jade\data"  ;need to change this depend on actual location
main()

Func main()

	Dim $datamanager
	Dim $jztWin = WinActivate("������")
	Dim $cmd = '"c:\program files\7-zip\7z.exe" e '  ;7zip ��װ·��




	;MsgBox(0,"handler is",$jztWin)
	WinActivate($jztWin)

	If WinExists("���ݹ�����") Then
		$datamanager = WinActivate("���ݹ�����")
    Else

		Send("^d") ;send control+d
		$datamanager=WinWait("���ݹ�����")
	EndIf
	ControlClick($datamanager,"","SysTabControl321","left",1,267,5)  ;click �������� tab
	Local $subFolders =  _FileListToArray($baseDir , "*" , 2)  ;read sub folders
	If @error = 4 Then
		Return
	EndIf
	For $i =1 To $subFolders[0]
		Local $subFolderName = $subFolders[$i]
		if $subFolderName = "���ڹ�Ʊ��ʷK������" or $subFolderName="�����ڻ���ʷK������" Then
			Local $folders[3] =["��K������","5����K������","1����K������"]
			For $dataFolderName in $folders
				 Local $fullPath = $baseDir&"\"& $subFolderName & "\" & $dataFolderName
				 Switch $dataFolderName  ;���ݵ���������ѡ��������
					Case "1����K������"
						ControlCommand($datamanager,"","ComboBox5","SelectString","1��������")

					Case "5����K������"

						ControlCommand($datamanager,"","ComboBox5","SelectString","5��������")

					Case "��K������"
						ControlCommand($datamanager,"","ComboBox5","SelectString","��������")
					Default
						ContinueLoop ;��ֹ������Ŀ¼���о�����
				EndSwitch
				FileChangeDir($fullPath)
				;MsgBox(0,"fullpath",$fullPath)
				Local $rarFiles = _FileListToArray($fullPath , "*.rar" , 1)
				If @error = 4 Then  ;û��rar�ļ���˵���ļ�������û����Ҫ������ļ�������continue loopȥ��һ����������
					ContinueLoop
				EndIf
				Local $finishedDir = _FileListToArray($fullPath , "finished" , 2)
				If @error = 4 Then ;finished folder doesnot exist
					DirCreate($fullPath & "\finished")
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


	WinActivate($datamanager)
	ControlSetText($datamanager,"","Edit2",$fileName)
	sleep(500)
	ControlClick($datamanager,"","Button50")
	;MouseClick("left",767,630)
	WinWait("������","��������")
	WinClose("������","��������")
EndFunc
