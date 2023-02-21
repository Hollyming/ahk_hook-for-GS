#Include point.ahk
#Include genshin.ahk

class Artifact {
    static p_auto_add_button := Point(2250, 1025)
    static p_enhance_button := Point(2105, 1360)
    static color_enhance_button := '0x313131'
    static p_details_tab := Point(168, 205)
    static p_enhance_tab := Point(168, 300)
    static time_sleep := 250

    static refresh_pos() {
        size := Genshin.get_game_pos()
        width := size[1]
        height := size[2]
        this.p_auto_add_button.refresh_pos(width, height)
        this.p_enhance_button.refresh_pos(width, height)
        this.p_details_tab.refresh_pos(width, height)
        this.p_enhance_tab.refresh_pos(width, height)
    }

    static enhance_once() {
        this.refresh_pos()
        if PixelGetColor(this.p_enhance_button.x, this.p_enhance_button.y) = this.color_enhance_button {
            MouseClick(, this.p_auto_add_button.x, this.p_auto_add_button.y)
            Sleep(this.time_sleep)
            MouseClick(, this.p_enhance_button.x, this.p_enhance_button.y)
            Sleep(this.time_sleep)
            MouseClick(, this.p_details_tab.x, this.p_details_tab.y)
            Sleep(350)
            MouseClick(, this.p_enhance_tab.x, this.p_enhance_tab.y)
            Sleep(this.time_sleep)
            MouseMove(this.p_auto_add_button.x, this.p_auto_add_button.y)
        }
    }
}
