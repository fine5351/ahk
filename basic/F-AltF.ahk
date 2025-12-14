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
        SetTimer () => AutoLoop("f", 100, &toggle), -1
    }
}

return