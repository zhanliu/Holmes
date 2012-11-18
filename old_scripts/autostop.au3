#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#include <dktUtilities.au3>


Dim $v_offset = 5 ;5 pixel
Local  $tempY




Dim $iniFileName = "c:\dktstock.ini"


If Not WinExists("招商证券") Then
	dkt_RunTDX()
	WinWait("招商证券")
EndIf





While WinExists("招商证券")
	WinWait("条件预警[运行中")
	Local $warningWindow = WinGetHandle("条件预警[运行中")
	Local $warningCount=ControlListView($warningWindow,"","SysListView321","GetItemCount")
    Local $warningProcessed=0;

	If $warningCount > $warningProcessed Then
		; This means we have a new warning
		WinActivate($warningWindow)
		Local $tempY=($warningCount-$warningProcessed-1)*16-1+$v_offset
;		msgbox(0,"y",$tempY)
		ControlClick($warningWindow,"","SysListView321","left",2,10, $tempY)  ;send double Click to list warning window
		$warningProcessed += 1
		dkt_DoStop()
		WinClose("条件预警[运行中")

	Else
		Sleep(2000)
	EndIf
WEnd


Func dkt_clearStop($stockCode)
	Local $warningWindow = WinGetHandle("条件预警[运行中")
	WinActivate($warningWindow)
	ControlClick($warningWindow,"","Button2")
	WinWait("条件预警设置")

	Local $settingWin = WinGetHandle("条件预警设置")
	WinActivate($settingWin)
	Local $settingID = ControlListView($settingWin,"","SysListView321","FindItem",$stockCode)
	if $settingID > 0 Then
		ControlListView($settingWin,"","SysListView321","Select",$settingID)
		ControlClick($settingWin,"","Button3")
		ControlClick($settingWin,"","Button5")
	EndIf


EndFunc


Func dkt_DoStop()
	Local $stockName,$stockCode,$BuyOrSell,$flashWindow,$volSet,$buttonEnabled
	Local $tradeFalg
	Local $LogFile = FileOpen("c:\tradelog.txt",1)
	Local $volumeSettings = IniReadSection($iniFileName,"short stop buy vol")
	WinWait("闪电")
	$flashWindow=WinGetHandle("闪电")
	$BuyOrSell=ControlGetText($flashWindow,"","Button1")
	ControlCommand($flashWindow,"","ComboBox2","SetCurrentSelection",1)  ;报价方式下拉框，选择第二项，5挡既成
	$volSet = False
	if $BuyOrSell = "卖  出" Then
		;predefined selling
		$tradeFalg = "卖出"
		$stockName=ControlGetText($flashWindow,"","Static6")
		$stockCode=ControlGetText($flashWindow,"","Static10")
		$volumeSettings = IniReadSection($iniFileName,"long stop sell vol")
	Else
		$tradeFalg = "买入"
		$stockName=ControlGetText($flashWindow,"","Static2")
		$stockCode=ControlGetText($flashWindow,"","Static7")
		$volumeSettings = IniReadSection($iniFileName,"short stop buy vol")
	EndIf

	For $i = 1 to $volumeSettings[0][0] Step 1
		If $volumeSettings[$i][0] = $stockName OR $volumeSettings[$i][0] = $stockCode Then
			ControlSetText($flashWindow,"","Edit2",$volumeSettings[$i][1])
			$volSet = True
			ExitLoop
		EndIf
	Next
	if NOT $volSet Then
		;let's click the max vol
		Sleep(300)
		ControlClick($flashWindow,"","Button3") ;按一下‘全部’按钮
	EndIf


	$buttonEnabled = ControlCommand($flashWindow,"","Button1","IsEnabled")
	While $buttonEnabled = 0
		Sleep(200) ;not enabled, wait...
		$buttonEnabled = ControlCommand($flashWindow,"","Button1","IsEnabled")
	WEnd
	ControlClick($flashWindow,"","Button1") ;卖出 or 买入
	WinWait("提示")
	ControlClick("提示","","Button1")
	WinWaitClose($flashWindow)
	FileWriteLine($LogFile,dkt_getCurrentTime()&@TAB&$tradeFalg&@TAB&$stockCode&@TAB&$stockName)
	FileClose($LogFile)
	dkt_clearStop($stockCode)
EndFunc

Func dkt_getCurrentTime()
	return @YEAR&"-"&@MON&"-"&@MDAY&" "&@HOUR&":"&@MIN&":"&@SEC
EndFunc



;WinClose("招商证券全能版")
;WinWait("退出确认","")
;ControlClick("退出确认","","Button; INSTANCE:1")
;WinWait("TdxW","是否要下载补全日线数据")
;ControlClick("TdxW","是否要下载补全日线数据","Button; INSTANCE:1")