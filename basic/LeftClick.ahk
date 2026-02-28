#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!l::
{
    global toggle := !toggle
    if (toggle) {
        SetTimer DoLeftClick, 150
        DoLeftClick()
    } else {
        SetTimer DoLeftClick, 0
    }
}

DoLeftClick() {
    Send("{LButton}")
}

return