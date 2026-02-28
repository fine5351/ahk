#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!j::
{
    if (!IsTargetGame()) {
        return
    }

    global toggle := !toggle
    if (toggle) {
        SetTimer DoJClick, 100
        DoJClick()
    } else {
        SetTimer DoJClick, 0
    }
}

DoJClick() {
    Send("j")
}

return