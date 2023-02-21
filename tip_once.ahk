class TipOnce {
    static tip(str, time := 1000, x := '', y := '') {
        SetTimer(tip, -1)
        tip() {
            if x and y {
                ToolTip(str, x, y)
            } else {
                ToolTip(str)
            }
            Sleep(time)
            toolTip()
        }
    }
}