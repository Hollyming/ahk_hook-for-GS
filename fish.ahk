#Include point.ahk
#Include genshin.ahk

class Fish {
    static p_search_range_1 := Point(944, 100)
    static p_search_range_2 := Point(1616, 200)
    static p_left_highlight_button := Point(2168, 1374)
    static p_right_highlight_button := Point(2322, 1374)
    static p_space_button := Point(2455, 1372)
    static p_now_character_mark_range_1 := Point(2327, 294.5)
    static p_now_character_mark_range_2 := Point(2327, 806.6)
    static p_exit_button := Point(75, 59)
    static color_yellow := '0xFFE92C'
    static color_white := '0xFFFFFF'
    static color_ui := '0xFFFFC0'
    static buoys_should_be_ahead_left_range := 60
    static color_shift := 0
    static is_auto_fish := false
    static sleep_time := 50

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_search_range_1.refresh_pos(width, height)
        this.p_search_range_2.refresh_pos(width, height)
        this.p_left_highlight_button.refresh_pos(width, height)
        this.p_right_highlight_button.refresh_pos(width, height)
        this.p_space_button.refresh_pos(width, height)
        this.p_now_character_mark_range_1.refresh_pos(width, height)
        this.p_now_character_mark_range_2.refresh_pos(width, height)
        this.p_exit_button.refresh_pos(width, height)
        this.buoys_should_be_ahead_left_range := this.buoys_should_be_ahead_left_range * width / 2560
    }

    static switch_auto_fish() {
        this.refresh_pos()
        this.is_auto_fish := not this.is_auto_fish
        fish() {
            if not Genshin.is_game_exist() or not this.is_auto_fish {
                SetTimer(fish, 0)
                this.is_auto_fish := false
            } else if not Genshin.is_game_active() {
            } else {
                if PixelGetColor(this.p_space_button.x, this.p_space_button.y) = this.color_white and not PixelSearch(&x, &y, this.p_now_character_mark_range_1.x, this.p_now_character_mark_range_1.y, this.p_now_character_mark_range_2.x, this.p_now_character_mark_range_2.y, this.color_white) and PixelGetColor(this.p_exit_button.x, this.p_exit_button.y) = this.color_white {
                    if PixelGetColor(this.p_right_highlight_button.x, this.p_right_highlight_button.y) != this.color_yellow {
                        ; 左键提示不是黄的（说明咬钩了）->点左键收杆
                        if PixelGetColor(this.p_left_highlight_button.x, this.p_left_highlight_button.y) != this.color_yellow {
                            MouseClick()
                        }
                        ; 左键提示是黄的（拉扯阶段）
                        else {
                            ; 获取游标左上角坐标
                            PixelSearch(&buoys_x, &buoys_y, this.p_search_range_1.x, this.p_search_range_1.y, this.p_search_range_2.x, this.p_search_range_2.y, this.color_ui, this.color_shift)
                            if buoys_y {
                                ; 计算范围y坐标
                                size := Genshin.get_game_pos()
                                game_height := size[2]
                                range_y := buoys_y + game_height * 17 / 1440
                                ; 游标x坐标不领先范围左边x坐标一定像素则点击
                                PixelSearch(&left_range_x, &left_range_y, this.p_search_range_1.x, range_y, this.p_search_range_2.x, range_y, this.color_ui, this.color_shift)
                                ; 游标x坐标不领先范围左边x坐标一定像素则点击
                                if left_range_x and buoys_x and buoys_x - left_range_x < this.buoys_should_be_ahead_left_range {
                                    MouseClick()
                                }
                            }
                        }
                    }
                }
            }
        }
        SetTimer(fish, this.sleep_time)
    }
}