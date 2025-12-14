#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

^j::
{
    if (!IsTargetGame()) {
        return
    }

    global toggle := !toggle
    if (toggle) {
        SetTimer () => AutoLoop("j", 100, &toggle), -1
    }
}

return