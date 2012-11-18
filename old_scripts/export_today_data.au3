#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include "dktUtilities.au3"
AutoItSetOption("MustDeclareVars",1)
Local $exportPath = "C:\tools\newone\T0002\export"
Main()

Func Main()

	Local $aStockX =70; A�� tab x����
	Local $aStockY =520; A�� tab y����

	Local $firstX =110; ��һ�й�Ʊ�� x����
	Local $firstY =81 ; ��һ�й�Ʊ y����

	Local $totalStockNumber = 2322


	;$aStockX = 70
	;$aStockY = 520

	;$firstX = 110
	;$firstY = 80


	common_StartTdxW()  ;start TDX

	common_SelectTDXMenu(11,2)  ;���뱨��ҳ��
	MouseClick("left",$aStockX,$aStockY) ; Select "A��" Tab

	Sleep(200)





	Local $size = DirGetSize($exportPath,1)
	Local $fileCount = $size[1]

	if $fileCount > 0 and $fileCount < $totalStockNumber Then
		;resume mode
		Send("^{HOME}")
		For $i = 1 to Int($fileCount/20) ;�����б����·�ҳ
			Send("{PGDN}")
		Next

		MouseClick("left",$firstX,$firstY,2)  ;�����һ����Ʊ
		common_SelectTDXMenu(13,2)  ;ѡ�˵��� ����-> ��ʱ����ͼ

		For $i = 1 to Mod($fileCount-1,20)  ;Ȼ��ȷ��λ
			Send("{PGDN}")
		Next

	Else
		; if already all files are there, means regenerate.
		RunWait(@ComSpec & " /C " & "del /Q C:\tools\newone\T0002\export\*.txt ")
		MouseClick("left",$firstX,$firstY,2)  ;�����һ����Ʊ
		common_SelectTDXMenu(13,2)  ;ѡ�˵��� ����-> ��ʱ����ͼ
	EndIf




	Local $startTime = TimerInit()
	For $i = 1 To $totalStockNumber
		dktExportCurrentDetail()
		Send("{PGDN}")  ;Next Stock
	Next
	Local $diff = TimerDiff($startTime)
	;MsgBox(0, "Finished export in: ", $diff/1000)
	;Shutdown(32);

EndFunc


Func dktExportCurrentDetail()
	;Local $startTime = TimerInit()
	common_SelectTDXMenu(13,3)  ;ѡ�˵��� ����-> ��ʱ��ϸ
	Sleep(50)
	common_SelectTDXMenu(10,2) ;ѡ�˵��� ϵͳ-> ��������
	WinWait("���ݵ���")
	Local $size = DirGetSize($exportPath,1)
	Local $currentfileCount = $size[1]  ;we get the count of files in export dir
	ToolTip("File #:" & $currentfileCount)
	Local $newCount = $currentfileCount
	ControlClick("���ݵ���","","Button1") ;������ť
	Local $startTime = TimerInit()
	Local $timeDiff = 0

	Local $wHandler = WinWait("TdxW")
	While  ($newCount = $currentfileCount and $timeDiff < 10000) ;do not close window before file generated or waited more than 15 seconds
		Sleep(100)
		$size = DirGetSize($exportPath,1)
		$newCount = $size[1] ; get new count of files
		$timeDiff = TimerDiff($startTime)
		;MsgBox(0,"TimeDiff",$timeDiff)
		ToolTip("File #:" & $newCount & "Count down: " & Int((10000-$timeDiff)/1000))
	WEnd
	;MsgBox(0,"Closing TdxW","")
	ControlClick($wHandler,"","Button2") ;ȡ����ť

	WinClose($wHandler)
	;MsgBox(0,"Closed TdxW","")
	WinWaitClose($wHandler)

	common_SelectTDXMenu(13,2) ;���� ��ʱ����
	;Local $diff = TimerDiff($startTime)
	;MsgBox(0, "One Stock Export Cost (seconds): ", $diff/1000)
EndFunc



