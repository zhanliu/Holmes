#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include "dktUtilities.au3"

AutoItSetOption("MustDeclareVars",1)
; Script Start - Add your code below here
Local $TDXWindow

If Not WinExists("招商证券") Then
	dkt_RunTDX()
	Sleep(5000)
EndIf

WinWait("招商证券")
dkt_DownloadData()
dkt_ZNXG()




;智能选股
Func dkt_ZNXG()
	Local $winHandler
	dkt_SelectTDXMenu($MENU_FUNC,$MENU_XGQ,$MENU_ZNXG)
	Sleep(1000)
	dkt_CloseTdxW()  ;may need to download
	Sleep(1000) ;wait 1 sec

	While Not WinExists("智能选股")
		Sleep(2000)
		If WinExists("选择截止日期") Then
;			ToolTip("msg dected")
			ControlClick("选择截止日期","","Button1")
		EndIf

	WEnd

;	WinWait("智能选股")
;	ToolTip("")
	$winHandler = WinGetHandle("智能选股")
	_saveGroup("KDJ")
	_saveGroup("RSI")
	_saveGroup("MACD")
	WinActivate($winHandler)
	ControlClick($winHandler,"","Button4") ;Close 智能选股



EndFunc ;==>dkt_SelectStocks

Func _saveGroup($groupName)

	Local $smartSelectWin,$selectGroupWin, $groupIndex, $pos
	$smartSelectWin = WinGetHandle("智能选股")
	WinActivate($smartSelectWin)
	$pos = WinGetPos($smartSelectWin)

	MouseMove($pos[0]+342,$pos[1]+28)  ;click '技术指标'
	MouseClick("left")
	Sleep(500)
	$groupIndex = ControlListView($smartSelectWin,"","SysListView321","FindItem",$groupName&"买入指示")
	ControlListView($smartSelectWin,"","SysListView321","Select",$groupIndex)

	ControlClick($smartSelectWin,"","Button3") ;click '存为板块'
	WinWait("请选择板块")
	$selectGroupWin = WinGetHandle("请选择板块")
	WinActivate($selectGroupWin)
	;MsgBOx(0,"focus",ControlGetFocus($selectGroupWin))
	;MsgBox(0,"handler",ControlGetHandle($selectGroupWin,"","SysListView321"))
	ControlClick($selectGroupWin,"","SysListView321","left",1,3,5) ;click the first item, should selected it.
	$groupIndex = ControlListView($selectGroupWin,"","SysListView321","FindItem",$groupName)

	;If $groupIndex<0 Then
	;	_createGroup($groupName)
	;EndIf
	ControlListView($selectGroupWin,"","SysListView321","Select",$groupIndex)
	Sleep(200)
	ControlClick($selectGroupWin,"","Button1") ;存为板块
	Sleep(500) ;wait 0.5 seconds
	If WinExists("TdxW","空") Then
		ControlClick("TdxW","空","Button1")  ;click 确定
	EndIf
	WinWaitClose("TdxW","空")
	WinActivate($smartSelectWin) ;give control back to 智能选股 window

EndFunc


Func dkt_DownloadData()
	Local $downloadWin,$downloadStatus
	dkt_SelectTDXMenu($MENU_SYS,$MENU_DATA_DOWNLOAD)
	WinWait("盘后数据下载")
	$downloadWin = WinGetHandle("盘后数据下载");
	ControlClick($downloadWin,"","[CLASS:Button;INSTANCE:7]") ;click 开始下载
	Sleep(1000) ;一秒钟后检查是不是下载是不是不用下载
	$downloadStatus = ControlGetText($downloadWin,"","[CLASS:Static;INSTANCE:3]")

	If $downloadStatus = "请选择下载项!" Then
		WinActivate($downloadWin)
		ControlClick($downloadWin,"","[CLASS:Button;INSTANCE:8]")  ;Close
		Return
	EndIf

	While ControlGetText($downloadWin,"","[CLASS:Static;INSTANCE:3]") <> "下载完毕."
		Sleep(3000) ;
	WEnd
	WinActivate($downloadWin)
	ControlClick($downloadWin,"","[CLASS:Button;INSTANCE:8]");Close
EndFunc ;==> dkt_DownloadData