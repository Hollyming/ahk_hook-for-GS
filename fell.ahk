#include point.ahk
#include genshin.ahk

class Fell {
    static p_exit_game := Point(60, 1360)
    static p_confirm_exit_game := Point(1600, 1000)
    static flag_auto_fell := false

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_exit_game.refresh_pos(width, height)
        this.p_confirm_exit_game.refresh_pos(width, height)
    }

    static auto_fell() {
        if this.flag_auto_fell {
            this.flag_auto_fell := false
            SetTimer(fell_exit_login, 0)
            return
        } else {
            this.flag_auto_fell := true
            this.refresh_pos()
            SetTimer(fell_exit_login, 1000)
            return
        }
        fell_exit_login() {
            ; 砍四下
            loop 4 {
                if this.exit_auto_fell() {
                    this.flag_auto_fell := false
                    SetTimer(fell_exit_login, 0)
                    return
                } else {
                    MouseClick()
                    if this.break_sleep(2000) {
                        this.flag_auto_fell := false
                        SetTimer(fell_exit_login, 0)
                        return
                    }
                }
            }
            ; 等一秒捡材料
            if this.break_sleep(1000) {
                this.flag_auto_fell := false
                SetTimer(fell_exit_login, 0)
                return
            }
            ; 退出登录
            SendInput('{Esc}')
            if this.break_sleep(1300) {
                this.flag_auto_fell := false
                SetTimer(fell_exit_login, 0)
                return
            }
            MouseClick(, this.p_exit_game.x, this.p_exit_game.y)
            if this.break_sleep(500) {
                this.flag_auto_fell := false
                SetTimer(fell_exit_login, 0)
                return
            }
            MouseClick(, this.p_confirm_exit_game.x, this.p_confirm_exit_game.y)
            if this.break_sleep(2000) {
                this.flag_auto_fell := false
                SetTimer(fell_exit_login, 0)
                return
            }
            ; 等退出完成
            while PixelGetColor(this.p_confirm_exit_game.x - 100, this.p_confirm_exit_game.y - 100) = '0xFFFFFF' {
                if this.break_sleep(2000) {
                    this.flag_auto_fell := false
                    SetTimer(fell_exit_login, 0)
                    return
                }
            }
            ; 尝试进游戏
            loop {
                MouseClick(, this.p_confirm_exit_game.x, this.p_confirm_exit_game.y)
                if this.break_sleep(2000) {
                    this.flag_auto_fell := false
                    SetTimer(fell_exit_login, 0)
                    return
                }
                if PixelGetColor(this.p_confirm_exit_game.x - 100, this.p_confirm_exit_game.y - 100) = '0xFFFFFF' {
                    break
                }
            }
            ; 等进游戏完成
            while PixelGetColor(this.p_confirm_exit_game.x - 100, this.p_confirm_exit_game.y - 100) = '0xFFFFFF' {
                if this.break_sleep(2000) {
                    this.flag_auto_fell := false
                    SetTimer(fell_exit_login, 0)
                    return
                }
            }
        }
    }

    static exit_auto_fell() {
        flag_exit := false
        if not Genshin.is_game_exist() {
            flag_exit := true
        } else if not Genshin.is_game_active() {
            flag_exit := true
        } else if not this.flag_auto_fell {
            flag_exit := true
        }
        return flag_exit
    }

    static break_sleep(length) {
        loop {
            if this.exit_auto_fell() {
                return true
            } else {
                if length > 100 {
                    Sleep(100)
                    length := length - 100
                } else {
                    Sleep(length)
                    return false
                }
            }
        }
    }
}