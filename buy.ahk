#Include point.ahk
#Include tip_once.ahk
#include genshin.ahk

class Buy {
    static p_buy_button := Point(2134, 1360)
    static p_upper_limit_of_quantity := Point(1576, 837)
    static p_confirm_buy_button := Point(1357, 1011)
    static p_store_icon := Point(111, 72)
    static color_black := '0x313131'
    static color_yellow_store_icon := '0xD3BC8E'
    static is_auto_buy := false

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_buy_button.refresh_pos(width, height)
        this.p_upper_limit_of_quantity.refresh_pos(width, height)
        this.p_confirm_buy_button.refresh_pos(width, height)
        this.p_store_icon.refresh_pos(width, height)
    }

    static switch_auto_buy() {
        this.refresh_pos()
        this.is_auto_buy := not this.is_auto_buy
        SetTimer(buy, 700)
        buy() {
            if not Genshin.is_game_exist() or not this.is_auto_buy {
                this.is_auto_buy := false
                SetTimer(buy, 0)
            } else if not Genshin.is_game_active() {
            } else if PixelGetColor(this.p_store_icon.x, this.p_store_icon.y) != this.color_yellow_store_icon or PixelGetColor(this.p_buy_button.x, this.p_buy_button.y) != this.color_black {
                TipOnce.tip('不是商店页面')
                this.is_auto_buy := false
                SetTimer(buy, 0)
            } else {
                MouseClick(, this.p_buy_button.x, this.p_buy_button.y)
                Sleep(100)
                MouseClick(, this.p_upper_limit_of_quantity.x, this.p_upper_limit_of_quantity.y)
                Sleep(100)
                MouseClick(, this.p_confirm_buy_button.x, this.p_confirm_buy_button.y)
                Sleep(100)
                sendInput('{Esc}')
                Sleep(300)
            }
        }
    }
}