#Include point.ahk
#Include config.ahk
#Include pick_and_talk.ahk
#Include fish.ahk
#Include teleport.ahk
#Include genshin.ahk
#Include fell.ahk

class Tip {
    static p_tooltip := Point(2560, 150)
    static tips_tooltip_num := 3

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_tooltip.refresh_pos(width, height)
    }

    static show_tips() {
        if Config.show_tips {
            this.refresh_pos()
            show() {
                msg := ''
                if not Genshin.is_game_exist() {
                    SetTimer(show, 0)
                } else if not (PickAndTalk.is_auto_pick_and_talk or PickAndTalk.is_keep_f_and_wheel_down or Fish.is_auto_fish or Teleport.is_auto_teleport or Fell.flag_auto_fell) {
                    SetTimer(show, 0)
                } else if not Genshin.is_game_active() {
                } else {
                    if PickAndTalk.is_auto_pick_and_talk {
                        msg := msg '自动拾取+自动对话`n'
                    }
                    if PickAndTalk.is_keep_f_and_wheel_down {
                        msg := msg '快速发送“f”+“滚轮下”`n'
                    }
                    if Fish.is_auto_fish {
                        msg := msg '自动钓鱼`n'
                    }
                    if Teleport.is_auto_teleport {
                        msg := msg '自动传送`n'
                    }
                    if Fell.flag_auto_fell {
                        msg := msg '自动砍树`n'
                    }
                }
                ToolTip(msg, this.p_tooltip.x, this.p_tooltip.y, this.tips_tooltip_num)
            }
            SetTimer(show, 500)
        }
    }
}