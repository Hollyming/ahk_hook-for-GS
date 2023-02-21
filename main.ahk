#SingleInstance
#Include genshin.ahk

#HotIf Genshin.is_game_active()

#Include pick_and_talk.ahk
#Include tip.ahk
#Include character.ahk
#Include team.ahk
#Include fish.ahk
#Include dispatch.ahk
#Include teleport.ahk
#Include cook.ahk
#Include buy.ahk
#Include artifact.ahk
#Include login.ahk
#include fell.ahk
;#Include 钓鱼.ahk

UAC()
{
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run("*RunAs `"" A_ScriptFullPath "`" /restart")
			else
				Run("*RunAs `"" A_AhkPath "`" /restart `"" A_ScriptFullPath "`"")
		}
		ExitApp()
	}
}


UAC()

;管理员权限




;快速对话+拾取
;~v & f::{
F5::{
    ;KeyWait("v")
    ;KeyWait("f")
    PickAndTalk.switch_auto_pick_and_talk()
    Tip.show_tips()
}

;一直发送f与滚轮下（无识别）
;~f & r::{
F8::{
    ;KeyWait("f")
    ;KeyWait("r")
    PickAndTalk.switch_keep_f_and_wheel_down()
    Tip.show_tips()
}

f:: {
    SendInput('f')
    Sleep(300)
    pick() {
        if GetKeyState('f', 'P') {
            SendInput('{WheelDown}')
            Sleep(30)
            SendInput('f')
        } else {
            SetTimer(pick, 0)
        }
    }
    SetTimer(pick, 30)
}

;Space:: SendInput('{Space}')
;CapsLock:: SendInput('{Space Down}')
;CapsLock Up:: SendInput('{Space Up}')

XButton1:: SendInput("t")
XButton2:: SendInput("{Esc}")

;1:: Character.switch_character(1)
;2:: Character.switch_character(2)
;3:: Character.switch_character(3)
;4:: Character.switch_character(4)

^1:: {
    KeyWait("Ctrl")
    KeyWait("1")
    Team.switch_team(1)
}
^2:: {
    KeyWait("Ctrl")
    KeyWait("2")
    Team.switch_team(2)
}
^3:: {
    KeyWait("Ctrl")
    KeyWait("3")
    Team.switch_team(3)
}
^4:: {
    KeyWait("Ctrl")
    KeyWait("4")
    Team.switch_team(4)
}

;自动钓鱼
;!y:: {
0:: {
    Fish.switch_auto_fish()
    Tip.show_tips()
}

;5::钓鱼.fuckfish()



;自动派遣
;!p:: Dispatch.dispatch()
7:: Dispatch.dispatch()

;帮忙点击传送
!t:: {
    Teleport.switch_auto_teleport()
    Tip.show_tips()
}

;自动烹饪
;!k:: {
9::{
    if Config.auto_cook {
        Cook.swith_auto_cook()
    }
}

;商店最大购买
;!b:: {
8::{
    if Config.auto_buy {
        Buy.switch_auto_buy()
    }
}

;强化圣遗物，跳过动画!q
F6:: Artifact.enhance_once()

;登录第几个账号。(在`config.ahk`里面设置，
;accounts := ['123456789', '68795', 'vhhc3', 'vhhc4']
;第几个字符串就是第几个账号，
;passwords := ['passwod', 'mima222', 'mima33', 'mima44']
;第几个字符串就是第几个账号的密码)
~q & 1::Login.login(Config.accounts[1], Config.passwords[1])
~q & 2::Login.login(Config.accounts[2], Config.passwords[2])
~q & 3::Login.login(Config.accounts[3], Config.passwords[3])
~q & 4::Login.login(Config.accounts[4], Config.passwords[4])

;自动砍树4下!f
6:: {
    Fell.auto_fell()
    Tip.show_tips()
}

#HotIf