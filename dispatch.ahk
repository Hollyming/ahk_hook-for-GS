#Include point.ahk
#Include genshin.ahk

class Dispatch {
    static p_area_range_1 := Point(500, 160)
    static p_area_range_2 := Point(1800, 1230)
    static p_dispatch_button := Point(2465, 1360)
    static characters := [Point(600, 230), Point(600, 394), Point(600, 558), Point(600, 722), Point(600, 886), Point(600, 1050), Point(600, 1214)]
    static dispatch_countries := [Point(160, 215), Point(160, 313), Point(160, 410)]
    static p_dispatch_icon := Point(102, 60)
    static p_choose_character_icon := Point(100, 68)
    static color_off_white := '0xECE5D8'
    static color_yellow_choose_character_icon := '0xD3BC8E'
    static color_green_under_avatar := '0xD3E6AE'
    static sleep_time := 300

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_area_range_1.refresh_pos(width, height)
        this.p_area_range_2.refresh_pos(width, height)
        this.p_dispatch_button.refresh_pos(width, height)
        for i in this.characters {
            i.refresh_pos(width, height)
        }
        for i in this.dispatch_countries {
            i.refresh_pos(width, height)
        }
        this.p_dispatch_icon.refresh_pos(width, height)
        this.p_choose_character_icon.refresh_pos(width, height)
    }

    static dispatch() {
        this.refresh_pos()
        if PixelGetColor(this.p_dispatch_button.x, this.p_dispatch_button.y) = this.color_off_white and PixelGetColor(this.p_dispatch_icon.x, this.p_dispatch_icon.y) = this.color_off_white {
            for country in this.dispatch_countries {
                MouseClick(, country.x, country.y)
                Sleep(this.sleep_time)
                while PixelSearch(&x, &y, this.p_area_range_1.x, this.p_area_range_1.y, this.p_area_range_2.x, this.p_area_range_2.y, this.color_green_under_avatar) {
                    MouseClick(, x, y)
                    Sleep(this.sleep_time)
                    MouseClick(, this.p_dispatch_button.x, this.p_dispatch_button.y)
                    Sleep(this.sleep_time)
                    MouseClick(, this.p_dispatch_button.x, this.p_dispatch_button.y)
                    Sleep(this.sleep_time)
                    MouseClick(, this.p_dispatch_button.x, this.p_dispatch_button.y)
                    Sleep(this.sleep_time)
                    ; 选人
                    for character in this.characters {
                        mouseClick(, character.x, character.y)
                        Sleep(this.sleep_time)
                        if PixelGetColor(this.p_choose_character_icon.x, this.p_choose_character_icon.y) != this.color_yellow_choose_character_icon {
                            break
                        }
                    }
                    Sleep(this.sleep_time)
                }
            }
            size := Genshin.get_game_pos()
            width := size[1]
            height := size[2]
            TipOnce.tip('完成', , width / 2, height / 2)
        } else {
            size := Genshin.get_game_pos()
            width := size[1]
            height := size[2]
            TipOnce.tip('当前不是派遣界面', , width / 2, height / 2)
        }
    }
}