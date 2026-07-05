#Requires AutoHotkey v2.0
#Include Function.ahk

; 核心修正：允許同一個快速鍵同時執行 2 個線程（1個負責開、1個負責關）
#MaxThreadsPerHotkey 2

global toggle := false

$!f::
{
    global toggle
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
}

DoFClick() {
    Send("{Blind}f")
}

return