#include point.ahk
#Include genshin.ahk

class Team {
    ; “队伍配置”相关坐标
    static p_quick_team := Point(1940, 1360)
    static teams := [Point(1208, 64), Point(1256, 64), Point(1304, 64), Point(1352, 64)]
    static p_switch_left_team := Point(88, 720)
    static p_switch_right_team := Point(2472, 720)
    static p_confirm_team := Point(2270, 1360)
    static color_white := '0xFFFFFF'
    static color_off_white := '0xECE5D8'

    ; 更新坐标
    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_quick_team.refresh_pos(width, height)
        for i in this.teams {
            i.refresh_pos(width, height)
        }
        this.p_switch_left_team.refresh_pos(width, height)
        this.p_switch_right_team.refresh_pos(width, height)
        this.p_confirm_team.refresh_pos(width, height)
    }

    ; 切换出战队伍
    static switch_team(want_team) {
        this.refresh_pos()
        ; 打开“队伍配置”
        SendInput("l")
        time := A_TickCount
        while (PixelGetColor(this.p_quick_team.x, this.p_quick_team.y) != this.color_off_white) {
            Sleep(20)
            if A_TickCount - time > 4000 {
                return
            }
        }
        ; 判断当前队伍
        for i in [1, 2, 3, 4] {
            if PixelGetColor(this.teams[i].x, this.teams[i].y) = this.color_white {
                now_team := i
            }
        }
        ; 切换目标队伍
        positive_distance := Mod(want_team - now_team + 4, 4)
        if positive_distance <= 2 {
            loop positive_distance {
                MouseClick(, this.p_switch_right_team.x, this.p_switch_right_team.y)
                Sleep(50)
            }
        } else {
            loop 4 - positive_distance {
                MouseClick(, this.p_switch_left_team.x, this.p_switch_left_team.y)
                Sleep(50)
            }
        }
        ; 退出“队伍配置”
        MouseClick(, this.p_confirm_team.x, this.p_confirm_team.y)
        Sleep(50)
        ; 退出“队伍配置”
        SendInput("{Esc}")
    }
}