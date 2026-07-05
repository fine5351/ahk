#Requires AutoHotkey v2.0
#Include Function.ahk

$!l::
{
    static toggle := false
    toggle := !toggle
    if (toggle) {
        SetTimer DoLeftClick, 150
        DoLeftClick()
    } else {
        SetTimer DoLeftClick, 0
    }
    KeyWait("l")
}

DoLeftClick() {
    SendEvent("{Blind}{LButton}")
}

