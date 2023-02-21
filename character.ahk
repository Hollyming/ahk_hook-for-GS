class Character {
    static switch_character(index) {
        if GetKeyState('XButton1', 'P') {
            SendInput('{Alt Down}')
            Sleep(50)
            SendInput(index)
            Sleep(50)
            SendInput('{Alt Up}')
        } else {
            SendInput(index)
        }
    }
}