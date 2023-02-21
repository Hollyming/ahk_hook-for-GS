#Include point.ahk
#include tip_once.ahk
#Include genshin.ahk

class Login {
    static p_account := Point(1280, 525)
    static p_enter_game := Point(1000, 915)
    static color := '0x393B40'

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_account.refresh_pos(width, height)
        this.p_enter_game.refresh_pos(width, height)
    }

    static login(account, password) {
        this.refresh_pos()
        if PixelGetColor(this.p_enter_game.x, this.p_enter_game.y) != this.color {
            ; TipOnce.tip('不是登录界面')
        } else {
            mouseClick(, this.p_account.x, this.p_account.y)
            Sleep(50)
            sendInput('^a')
            Sleep(50)
            sendInput('{Delete}')
            sleep(50)
            SendText(account)
            sleep(50)
            sendInput('{Tab}')
            sleep(50)
            SendText(password)
            sleep(50)
            mouseClick(, this.p_enter_game.x, this.p_enter_game.y)
        }
    }
}