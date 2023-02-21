#Include config.ahk

class Genshin {
    static get_game_pos() 
    {
        if ProcessExist(Config.game_name_cn) 
        {
            WinGetClientPos(, , &width, &height, 'ahk_exe ' Config.game_name_cn)
        } 
        else if ProcessExist(Config.game_name_global) 
        {
            WinGetClientPos(, , &width, &height, 'ahk_exe ' Config.game_name_global)
        } 
        else 
        {
            width := 0
            height := 0
        }
        return [width, height]
    }

    static is_game_exist() 
    {
        return ProcessExist(Config.game_name_cn) or ProcessExist(Config.game_name_global)
    }

    static is_game_active() 
    {
        return WinActive('ahk_exe ' Config.game_name_cn) or WinActive('ahk_exe ' Config.game_name_global)
    }
}