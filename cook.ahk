#Include point.ahk
#Include tip_once.ahk
#Include genshin.ahk

class Cook {
    static p_cook := Point(1345, 1354)
    static p_auto_cook := Point(890, 1354)
    static p_finish := Point(1280, 1254)
    static p_search_range1 := Point(840, 960)
    static p_search_range2 := Point(1720, 1100)
    static p_cook_icon := Point(102, 57)
    static color_off_white := '0xECE5D8'
    static color_yellow_best := '0xFFC040'
    static color_yellow_cook_icon := '0xD3BC8E'
    static is_auto_cook := false

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_cook.refresh_pos(width, height)
        this.p_auto_cook.refresh_pos(width, height)
        this.p_finish.refresh_pos(width, height)
        this.p_search_range1.refresh_pos(width, height)
        this.p_search_range2.refresh_pos(width, height)
        this.p_cook_icon.refresh_pos(width, height)
    }

    static swith_auto_cook() {
        this.refresh_pos()
        this.is_auto_cook := not this.is_auto_cook
        SetTimer(cook, 500)
        cook() {
            if not Genshin.is_game_exist() or not this.is_auto_cook {
                this.is_auto_cook := false
                SetTimer(cook, 0)
            } else if not Genshin.is_game_active() {
                this.is_auto_cook := false
                SetTimer(cook, 0)
            } else if pixelGetColor(this.p_cook_icon.x, this.p_cook_icon.y) != this.color_yellow_cook_icon {
                TipOnce.tip('不是烹饪界面')
                this.is_auto_cook := false
                SetTimer(cook, 0)
            } else if pixelGetColor(this.p_auto_cook.x, this.p_auto_cook.y) = this.color_off_white {
                TipOnce.tip('已经熟练')
                this.is_auto_cook := false
                SetTimer(cook, 0)
            } else {
                mouseClick(, this.p_cook.x, this.p_cook.y)
                Sleep(800)
                time := A_TickCount
                while not PixelSearch(&x_best_left, &y_best_left, this.p_search_range2.x, this.p_search_range2.y, this.p_search_range1.x, this.p_search_range1.y, this.color_yellow_best) {
                    if A_TickCount - time > 7000 {
                        TipOnce.tip('超时退出')
                        this.is_auto_cook := false
                        SetTimer(cook, 0)
                        break
                    }
                }
                time := A_TickCount
                while pixelGetColor(x_best_left, y_best_left) = this.color_yellow_best {
                    if A_TickCount - time > 7000 {
                        TipOnce.tip('超时退出')
                        this.is_auto_cook := false
                        SetTimer(cook, 0)
                        break
                    }
                }
                mouseClick(, this.p_finish.x, this.p_finish.y)
                Sleep(600)
                SendInput('{Esc}')
                Sleep(1000)
            }
        }
    }
}