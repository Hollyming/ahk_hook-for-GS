#Include point.ahk
#Include genshin.ahk

class Teleport {
    static p_yellow_teleport_icon := Point(1971, 1351)
    static color_yellow := '0xFFCC33'
    static p_black_background_around_teleport_icon := Point(1989, 1351)
    static color_black := '0x313131'
    static p_deep_blue_teleport_button := Point(2008, 1351)
    static color_deep_blue := '0x4A5366'
    static is_auto_teleport := false
    static sleep_time := 100

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_yellow_teleport_icon.refresh_pos(width, height)
        this.p_black_background_around_teleport_icon.refresh_pos(width, height)
        this.p_deep_blue_teleport_button.refresh_pos(width, height)
    }

    static switch_auto_teleport() {
        this.refresh_pos()
        this.is_auto_teleport := not this.is_auto_teleport
        teleport() {
            if not Genshin.is_game_exist() or not this.is_auto_teleport {
                SetTimer(teleport, 0)
                this.is_auto_teleport := false
            } else if not Genshin.is_game_active() {
            } else {
                if PixelGetColor(this.p_yellow_teleport_icon.x, this.p_yellow_teleport_icon.y) = this.color_yellow and PixelGetColor(this.p_black_background_around_teleport_icon.x, this.p_black_background_around_teleport_icon.y) = this.color_black and PixelGetColor(this.p_deep_blue_teleport_button.x, this.p_deep_blue_teleport_button.y) = this.color_deep_blue {
                    MouseClick(, this.p_yellow_teleport_icon.x, this.p_yellow_teleport_icon.y)
                }
            }
        }
        SetTimer(teleport, this.sleep_time)
    }
}