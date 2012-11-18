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

	Local $aStockX =70; A股 tab x坐标
	Local $aStockY =520; A股 tab y坐标

	Local $firstX =110; 第一行股票的 x坐标
	Local $firstY =81 ; 第一行股票 y坐标

	Local $totalStockNumber = 2322


	;$aStockX = 70
	;$aStockY = 520

	;$firstX = 110
	;$firstY = 80


	common_StartTdxW()  ;start TDX

	common_SelectTDXMenu(11,2)  ;进入报价页面
	MouseClick("left",$aStockX,$aStockY) ; Select "A股" Tab

	Sleep(200)





	Local $size = DirGetSize($exportPath,1)
	Local $fileCount = $size[1]

	if $fileCount > 0 and $fileCount < $totalStockNumber Then
		;resume mode
		Send("^{HOME}")
		For $i = 1 to Int($fileCount/20) ;先在列表处向下翻页
			Send("{PGDN}")
		Next

		MouseClick("left",$firstX,$firstY,2)  ;进入第一个股票
		common_SelectTDXMenu(13,2)  ;选菜单： 分析-> 分时走势图

		For $i = 1 to Mod($fileCount-1,20)  ;然后精确定位
			Send("{PGDN}")
		Next

	Else
		; if already all files are there, means regenerate.
		RunWait(@ComSpec & " /C " & "del /Q C:\tools\newone\T0002\export\*.txt ")
		MouseClick("left",$firstX,$firstY,2)  ;进入第一个股票
		common_SelectTDXMenu(13,2)  ;选菜单： 分析-> 分时走势图
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
	common_SelectTDXMenu(13,3)  ;选菜单： 分析-> 分时明细
	Sleep(50)
	common_SelectTDXMenu(10,2) ;选菜单： 系统-> 导出数据
	WinWait("数据导出")
	Local $size = DirGetSize($exportPath,1)
	Local $currentfileCount = $size[1]  ;we get the count of files in export dir
	ToolTip("File #:" & $currentfileCount)
	Local $newCount = $currentfileCount
	ControlClick("数据导出","","Button1") ;导出按钮
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
	ControlClick($wHandler,"","Button2") ;取消按钮

	WinClose($wHandler)
	;MsgBox(0,"Closed TdxW","")
	WinWaitClose($wHandler)

	common_SelectTDXMenu(13,2) ;返回 分时走势
	;Local $diff = TimerDiff($startTime)
	;MsgBox(0, "One Stock Export Cost (seconds): ", $diff/1000)
EndFunc



