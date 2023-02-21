#include point.ahk
#Include genshin.ahk

class PickAndTalk {
    static p_single_f_white := Point(1475, 720)
    static p_multiple_wheel_white := Point(1416.5, 739.5)
    static p_auto_talk_button := Point(133, 69)
    static color_white := '0xFFFFFF'
    static color_deep_blue := '0x3B4354'
    static color_off_white := '0xECE5D8'
    static sleep_time := 50
    static is_auto_pick_and_talk := false
    static is_keep_f_and_wheel_down := false

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_single_f_white.refresh_pos(width, height)
        this.p_multiple_wheel_white.refresh_pos(width, height)
        this.p_auto_talk_button.refresh_pos(width, height)
    }

    static switch_auto_pick_and_talk() {
        this.refresh_pos()
        this.is_auto_pick_and_talk := not this.is_auto_pick_and_talk
        auto_talk_and_pick() {
            if not Genshin.is_game_exist() or not this.is_auto_pick_and_talk {
                SetTimer(auto_talk_and_pick, 0)
                this.is_auto_pick_and_talk := false
            } else if not Genshin.is_game_active() {
            } else {
                if PixelGetColor(this.p_single_f_white.x, this.p_single_f_white.y) = this.color_white or pixelGetColor(this.p_multiple_wheel_white.x, this.p_multiple_wheel_white.y) = this.color_white {
                    sendInput('f')
                    Sleep(20)
                    sendInput('{WheelDown}')
                } else if pixelGetColor(this.p_auto_talk_button.x, this.p_auto_talk_button.y) = this.color_deep_blue {
                    sendInput('{Space}')
                }
            }
        }
        SetTimer(auto_talk_and_pick, this.sleep_time)
    }

    static switch_keep_f_and_wheel_down() {
        this.refresh_pos()
        this.is_keep_f_and_wheel_down := not this.is_keep_f_and_wheel_down
        keep_f_and_wheel_down() {
            if not Genshin.is_game_exist() or not this.is_keep_f_and_wheel_down {
                SetTimer(keep_f_and_wheel_down, 0)
                this.is_keep_f_and_wheel_down := false
            } else if not Genshin.is_game_active() {
            } else {
                sendInput('f')
                Sleep(20)
                sendInput('{WheelDown}')
            }
        }
        SetTimer(keep_f_and_wheel_down, this.sleep_time)
    }
}