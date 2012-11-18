#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         DKT

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#Include <WinAPI.au3>
AutoItSetOption("MustDeclareVars",1)
; Script Start - Add your code below here


Global Const $MENU_SYS 			=	10  ;系统
Global Const 	$MENU_DATA_DOWNLOAD	=	10  ;盘后数据下载
Global Const $MENU_FUNC 		=	11  ;功能
Global Const	$MENU_BAOJIA		=	2	;报价分析
Global Const 	$MENU_XGQ			=	16   ;选股器
Global Const 		$MENU_ZNXG			=	2  ;智能选股
Global Const $MENU_QUOTE 		=	12   ;报价
Global Const $MENU_ANALYSIS 	=	13   ;分析
Global Const $MENU_HK_OPTION 	=	14   ;港股期货理财
Global Const $MENU_INFO 		=	15   ; 资讯
Global Const $MENU_TOOL 		=	16   ; 资讯

Const $MENU_CLASS	= 	"AfxWnd42"



#cs
   运行通达信，并自动登录

#ce
Func dkt_RunTDX()
		Local $iniFileName = "c:\dktstock.ini"
		Local $app, $appPath
		Local $veriX,$veriY,$passX,$passY,$loginX,$loginY
		Local $tdxHandler, $notifyHandler

		$app = IniRead ( $iniFileName, "App Setting", "TDX_EXE", "TdxW.exe")
		$appPath = IniRead ( $iniFileName, "App Setting", "TDX_PATH", "")
		$veriX = IniRead ( $iniFileName, "App Setting", "VERI_X", "")
		$veriY = IniRead ( $iniFileName, "App Setting", "VERI_Y", "")
		$passX = IniRead ( $iniFileName, "App Setting", "PASS_X", "")
		$passY = IniRead ( $iniFileName, "App Setting", "PASS_Y", "")
		$loginX = IniRead ( $iniFileName, "App Setting", "LOGIN_X", "")
		$loginY = IniRead ( $iniFileName, "App Setting", "LOGIN_Y", "")

		Run($app,$appPath)
		Sleep(15000) ;sleep 10 sec for TDX to initialize, sometime it's slow to startup

		MouseClick("left",$passX,$passY)
		Run("c:\input.exe")
		MouseClick("left",$passX,$passY)  ;click at the password
		Sleep(15000)  ;wait 15 seconds, password input should be finished.
		If WinExists("input") Then
			WinClose("input")
		Endif

		MouseClick("left",$veriX,$veriY) ; click at 验证码
		Send("1234")
		Sleep(500)
		MouseClick("left",$loginX,$loginY)  ;click login
		WinWait("招商证券")
		$tdxHandler = WinGetHandle("招商证券")
		Sleep(6000) ;wait 6 seconds, the notification window may popup
		If WinExists("条件预警") Then
			WinClose("条件预警")
		EndIf
		$notifyHandler = _WinAPI_GetForegroundWindow()
		If $notifyHandler <> $tdxHandler Then
			ControlClick($notifyHandler,"","Button1")
		EndIf


EndFunc ;== dkt_RunTDX

#cs
   选择菜单。
   $mainIndex 是一级菜单序号
   $subIndex 是二级菜单序号
   $thridIndex 是三级菜单序号，默认 -1，-1时候直接选择二级菜单
#ce
Func dkt_SelectTDXMenu($mainIndex, $subIndex, $thirdIndex = -1)
	Local $tdxHandler, $i
	If WinExists("招商证券") Then
		$tdxHandler = WinGetHandle("招商证券")
		WinActivate($tdxHandler)
		If $mainIndex < 10 Then
			$mainIndex = $mainIndex + 0 ;菜单编号从10开始，所以第一个菜单如果直接用1来引用，就要+9
		EndIf
		ControlClick($tdxHandler,"",$MENU_CLASS&$mainIndex)
		For $i = 1 to $subIndex   ;按向下N次，到2级菜单
			Send("{DOWN}")
		Next
		If $thirdIndex >= 0 Then
			;Still have next level Menu
			Send("{RIGHT}")
			For $i = 1 to $thirdIndex
				Send("{DOWN}")
			Next
		EndIf
		Send("{ENTER}")
	EndIf
EndFunc


Func common_SelectTDXMenu($mainIndex, $subIndex, $thirdIndex = -1) ;for compatible
	dkt_SelectTDXMenu($mainIndex, $subIndex, $thirdIndex)
EndFunc

#cs
	选择板块，通过键盘快捷方式
#ce
Func dkt_SelectGroup($groupName)
	Local $tdxHandler, $popupHandler, $i
	If WinExists("招商证券") Then
		$tdxHandler = WinGetHandle("招商证券")
		WinActivate($tdxHandler)
		Send($groupName)
		If WinExists("Tdx") Then
			$popupHandler = WinGetHandle("Tdx")
			$i = ControlCommand($popupHandler,"","ListBox1","FindString",$groupName&"[板块]")
			If $i < 0 Then
				MsgBox(0,"Warning",$groupName&"[板块] not found")
			ElseIf
				ControlCommand($popupHandler,"","ListBox1","FindString",$groupName&"[板块]")
			EndIf
		Else
			MsgBox(0,"Warning","can not detect 小键盘")
		EndIf
	EndIf


EndFunc ;=> dkt_SelectGroup

#cs
  关闭 TdxW提示窗口
#ce
Func dkt_CloseTdxW()
	If WinExists("TdxW","")  Then
		ControlClick("TdxW","","Button1")
	EndIf
EndFunc

#cs

启动登录

#ce
Func common_StartTdxW()
	If Not WinExists("招商证券") Then
		dkt_RunTDX()
		Sleep(5000)
	EndIf

	WinWait("招商证券")
	WinActivate("招商证券")
EndFunc

