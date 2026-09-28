#Requires AutoHotkey v2.0
#Include Function.ahk

$!j::
{
    static toggle := false
    if (!toggle && !IsTargetGame()) {
        return
    }

    toggle := !toggle
    if (toggle) {
        SetTimer DoJClick, 100
        DoJClick()
    } else {
        SetTimer DoJClick, 0
    }
    KeyWait("j")
}

DoJClick() {
    SendEvent("{Blind}j")
}