; REMOVED: #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance ignore
Persistent
; REMOVED: SetBatchLines, -1

supported_resolutions:="
(
1280 x 720
1440 x 900
1600 x 900
1920 x 1080
2560 x 1080
2560 x 1440
3440 x 1440
3840 x 2160
)"


version:="1.0"
isCNServer:=0



TrayTip("Genshin Fishing Automata", "Genshin Fishing Automata Start`nv" version "`n原神钓鱼启动")

img_list:=Map("bar", Map("filename", "bar.png"), "casting", Map("filename", "casting.png"), "cur", Map("filename", "cur.png"), "left", Map("filename", "left.png"), "ready", Map("filename", "ready.png"), "reel", Map("filename", "reel.png"), "right", Map("filename", "right.png"))




DllCall("QueryPerformanceFrequency", "Int64P", &freq)
freq/=1000
CoordMode("Pixel", "Client")
state:="unknown"
statePredict:="unknown"
stateUnknownStart:=0
isResolutionValid:=0

OnExit(exit, )
;SetTimer, main_fishing, -100
;MsgBox, 这是一个证明读取钓鱼文件正常的弹窗（我改代码到凌晨4点时写下的这段话）.
;Return


fuckfish(){
SetTimer(main_fishing,-100) ;启动钓鱼主函数操作
Return
}

log_init:
pLogfile:=FileOpen("genshinfishing.log", "a")
Return

log(txt,level:=0)
{
	global logLevel, pLogfile
	if(logLevel >= level) {
		pLogfile.WriteLine(A_Hour ":" A_Min ":" A_Sec "." A_MSec "[" level "]:" txt)
	}
}

genshin_window_exist()
{
	; global isCNServer
	genshinHwnd := WinExist("ahk_exe GenshinImpact.exe")
	; isCNServer := 0
	if not genshinHwnd
	{
		genshinHwnd := WinExist("ahk_exe YuanShen.exe")
		; isCNServer := 1
	}
	;ToolTip,flag genshin_window_exist,900,100,1
	return genshinHwnd
}

ttm(txt, delay:=1500)
{
	ToolTip(txt)
	SetTimer(kttm,-delay)
	Return
	kttm()
{ ; V1toV2: Added bracket
	ToolTip()
	Return
}
} ; V1toV2: Added bracket before function

tt(txt, delay:=2000)
{
	ToolTip(txt, 1, 1)
	SetTimer(ktt,-delay)
	Return
	ktt()
{ ; V1toV2: Added bracket
	ToolTip()
	Return
}
; 图标位置
; 右下角 w 82.5% h 87.5%
; Bar
; w 25%~75%
; h 0%~30%
; 浮漂
; w 25%~75%
; h 由 bar 参数 barY-10 ~ barY+30

genshin_hwnd := genshin_window_exist()
} ; V1toV2: Added bracket before function


getClientSize(hWnd, &w := "", &h := "")
{
	rect := Buffer(16, 0) ; V1toV2: if 'rect' is a UTF-16 string, use 'VarSetStrCapacity(&rect, 16)'
	DllCall("GetClientRect", "ptr", hWnd, "ptr", rect)
	w := NumGet(rect, 8, "int")
	h := NumGet(rect, 12, "int")
}

dLinePt(p)
{
	global dLine
	return Ceil(p*dLine)
}

; iconSize = dLinePt(0.0353) * dLinePt(0.0442)

getState()
;ToolTip,flag getstate,900,100,1
{ ; V1toV2: Added bracket
if(isCNServer) {
	iconLeftPt := 0.167
} else {
	iconLeftPt := 0.222
}
iconTopPt := 0.084
iconBottomPt := 0
iconRightPt := 0
} ; V1toV2: Added bracket before function

if(last_iconX>0) {
	last_iconLeftPt := (winW - last_iconX)/dLine
	last_iconTopPt := (winH - last_iconY)/dLine
	
	iconBottomPt := (winH - last_iconY - dLinePt(0.0442*1.5))/dLine
	iconRightPt := (winW - last_iconX - dLinePt(0.0353*1.5))/dLine
	if(iconBottomPt<0){
		iconBottomPt := 0
	}
	if(iconRightPt<0){
		iconRightPt := 0
	}
	iconLeftPt := last_iconLeftPt + (0.0353*0.5)
	iconTopPt := last_iconTopPt + (0.0442*0.5)
	log("lastIcon=" last_iconX ", " last_iconY "  dLine=" dLine, 3)
}

ErrorLevel := !ImageSearch(&iconX, &iconY, winW-dLinePt(iconLeftPt), winH-dLinePt(iconTopPt), winW-dLinePt(iconRightPt), winH-dLinePt(iconBottomPt), "*32 *TransFuchsia " "assets/" winW winH "/" img_list.ready.filename)
if(!ErrorLevel){
	last_iconX := iconX
	last_iconY := iconY
	state:="ready"
	statePredict:=state
	stateUnknownStart := 0
	log("state->" statePredict, 1)
	return
}
ErrorLevel := !ImageSearch(&iconX, &iconY, winW-dLinePt(iconLeftPt), winH-dLinePt(iconTopPt), winW-dLinePt(iconRightPt), winH-dLinePt(iconBottomPt), "*32 *TransFuchsia " "assets/" winW winH "/" img_list.reel.filename)
if(!ErrorLevel){
	last_iconX := iconX
	last_iconY := iconY
	state:="reel"
	statePredict:=state
	stateUnknownStart := 0
	log("state->" statePredict, 1)
	return
}
ErrorLevel := !ImageSearch(&iconX, &iconY, winW-dLinePt(iconLeftPt), winH-dLinePt(iconTopPt), winW-dLinePt(iconRightPt), winH-dLinePt(iconBottomPt), "*32 *TransFuchsia " "assets/" winW winH "/" img_list.casting.filename)
if(!ErrorLevel){
	last_iconX := iconX
	last_iconY := iconY
	state:="casting"
	statePredict:=state
	stateUnknownStart := 0
	log("state->" statePredict, 1)
	return
}
state:="unknown"
if(stateUnknownStart == 0) {
	stateUnknownStart := A_TickCount
}
if(statePredict!="unknown" && A_TickCount - stateUnknownStart>=2000){
	last_iconX := 0
	last_iconY := 0
	statePredict:="unknown"
	; Click, Up
	log("state->" statePredict, 1)
}
Return

main_fishing()
{

	;ToolTip,flag main,900,100,1
	genshin_hwnd := genshin_window_exist()
if(!genshin_hwnd){
	SetTimer(main_fishing,-800)
	Return
}
if(WinExist("A") != genshin_hwnd) {
	SetTimer(main_fishing,-500)
	Return
}
getClientSize(genshin_hwnd, winW, winH)
if(oldWinW!=winW || oldWinH!=winH) {
	log("Get dimension=" winW "x" winH,1)
	if(InStr(FileExist("assets/" winW winH), "D")) {
		fileCount:=0
		for k, v in img_list
		{
			if(FileExist("assets/" winW winH "/" v.filename)) {
				fileCount += 1
			}
		}
		if(fileCount < img_list.Count) {
			isResolutionValid:=0
		} else {
			isResolutionValid:=1
			dline:=Ceil(((winW**2)+(winH**2))**0.5)
			barR_left:=dLinePt(0.27)
			barR_top:=dLinePt(0.03)
			barR_right:=dLinePt(0.59)
			barR_bottom:=dLinePt(0.1)
			
			delta_left:=dLinePt(0.025)
			delta_top:=dLinePt(0.005)
			delta_right:=dLinePt(0.035)
			delta_bottom:=dLinePt(0.014)

			barS_left:=dLinePt(0.22)
			barS_right:=dLinePt(0.64)
		}
	} else {
		isResolutionValid:=0
	}
}
oldWinW:=winW
oldWinH:=winH
if(!isResolutionValid) {
	tt("Unsupported resolution`n不支持的分辨率`n" winW "x" winH "`n`nThe supported resolutions are as follows`n支持的分辨率如下`n" supported_resolutions)
	SetTimer(main_fishing,-800)
	Return
}

if(statePredict=="unknown" || statePredict=="ready") {
	getState()
	if(statePredict!="unknown" && debugmode){
		tt("state = " state "`nstatePredict = " statePredict "`n" winW "," winH)
	}
	if(statePredict=="reel"){
		SetTimer(main_fishing,-40)
	} else {
		barY := 0
		SetTimer(main_fishing,-800)
	}
	Return
} else if(statePredict=="casting") {
	getState()
	if(debugmode){
		tt("state = " statePredict)
	}
	if(statePredict=="reel") {
		Click("Down")
		SetTimer(main_fishing,-40)
	} else{
		SetTimer(main_fishing,-200)
	}
	Return
} else if(statePredict=="reel") {
	DllCall("QueryPerformanceCounter", "Int64P", &startTime)
	if(barY<2) {
		ErrorLevel := !ImageSearch(&_, &barY, barR_left, barR_top, barR_right, barR_bottom, "*20 *TransFuchsia " "assets/" winW winH "/" img_list.bar.filename)
		if(ErrorLevel){
			if(barY == 0) {
				barY := 1
				Click("Down")
			} else if(barY == 1) {
				barY := 0
				Click("Up")
			}
		} else {
			Click("Up")
			avrDetectTime:=[]
			leftX:=0
			rightX:=0
			curX:=0
			log("get barY=" barY,2)
		}
		DllCall("QueryPerformanceCounter", "Int64P", &endTime)
	} else {
		if(leftX > 0) {
			ErrorLevel := !ImageSearch(&leftX, &leftY, leftX-delta_left, barY-delta_top, leftX+delta_right, barY+delta_bottom, "*16 *TransFuchsia " "assets/" winW winH "/" img_list.left.filename)
		} else {
			ErrorLevel := !ImageSearch(&leftX, &leftY, barS_left, barY-delta_top, barS_right, barY+delta_bottom, "*16 *TransFuchsia " "assets/" winW winH "/" img_list.left.filename)
		}
		if(ErrorLevel){
			leftX := 0
			leftY := "Null"
		} else {
			leftPredictX := 2*leftX - leftXOld
			leftXOld := leftX
		}
		
		if(rightX > 0) {
			ErrorLevel := !ImageSearch(&rightX, &rightY, rightX-delta_left, barY-delta_top, rightX+delta_right, barY+delta_bottom, "*16 *TransFuchsia " "assets/" winW winH "/" img_list.right.filename)
		} else {
			ErrorLevel := !ImageSearch(&rightX, &rightY, barS_left, barY-delta_top, barS_right, barY+delta_bottom, "*16 *TransFuchsia " "assets/" winW winH "/" img_list.right.filename)
		}
		if(ErrorLevel){
			rightX := 0
			rightY := "Null"
		} else {
			rightPredictX := 2*rightX - rightXOld
			rightXOld := rightX
		}

		if(curX > 0) {
			ErrorLevel := !ImageSearch(&curX, &curY, curX-delta_left, barY-delta_top, curX+delta_right, barY+delta_bottom, "*16 *TransFuchsia " "assets/" winW winH "/" img_list.cur.filename)
		} else {
			ErrorLevel := !ImageSearch(&curX, &curY, barS_left, barY-delta_top, barS_right, barY+delta_bottom, "*16 *TransFuchsia " "assets/" winW winH "/" img_list.cur.filename)
		}
		if(ErrorLevel){
			curX := 0
			curY := "Null"
		} else {
			curPredictX := 2*curX - curXOld
			curXOld := curX
		}
		if(leftY == "Null" && rightY == "Null" && curY == "Null") {
			getState()
			Click("Up")
		} else {
			if(leftX+rightX < leftXOld+rightXOld) {
				k := 0.2
			} else if(leftX+rightX > leftXOld+rightXOld) {
				k:= 0.8
			} else {
				k := "0.4"
			}
			if(curPredictX<(k*rightPredictX + (1-k)*leftPredictX)){
				Click("Down")
			} else {
				Click("Up")
			}
		}
		DllCall("QueryPerformanceCounter", "Int64P", &endTime)

		detectTime:=(endTime-startTime)//freq
		if(avrDetectTime.Length<8){
			avrDetectTime.Push(detectTime)
		} else {
			avrDetectTime.Pop()
			avrDetectTime.Push(detectTime)
		}
		sum := 0
		For index, value in avrDetectTime
			sum += value

		avrDetectMs := sum//avrDetectTime.Length

		log("dt=" detectTime "ms`tleftX=" leftX "`trightX=" rightX "`t" "curX=" curX "`tleftXpre=" leftPredictX "`trightXpre=" rightPredictX "`tcurXpre=" curPredictX,2)
		if(debugmode){
			tt("barY = " barY "`n" "leftX = " leftX "`n" "rightX = " rightX "`n" "curX = " curX "`n" "barMove = " (leftX+rightX)-(leftXOld+rightXOld) "`n" state "`n" avrDetectMs "ms")
		}
	}
	lastTime:=(endTime-startTime)//freq
	if(lastTime>60) {
		SetTimer(main_fishing,-10)
	} else {
		SetTimer(main_fishing,lastTime-70)
	}
	Return
}


}
Return


exit(A_ExitReason, ExitCode)
{ ; V1toV2: Added bracket
pLogfile.Close()
ExitApp()
} ; V1toV2: Added Bracket before label
donothing:
Return
















