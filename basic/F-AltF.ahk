#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!f::
{
    if (!IsTargetGame()) {
        return
    }

    global toggle := !toggle
    if (toggle) {
        SetTimer DoFClick, 100
        DoFClick()
    } else {
        SetTimer DoFClick, 0
    }
}

DoFClick() {
    Send("f")
}

return