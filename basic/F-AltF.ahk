#Requires AutoHotkey v2.0
#Include Function.ahk

$!f::
{
    static toggle := false
    if (!toggle && !IsTargetGame()) {
        return
    }

    toggle := !toggle
    if (toggle) {
        SetTimer DoFClick, 100
        DoFClick()
    } else {
        SetTimer DoFClick, 0
    }
    KeyWait("f")
}

DoFClick() {
    SendEvent("{Blind}f")
}