#Requires AutoHotkey v2.0
#Include Function.ahk

; 核心修正：允許同一個快速鍵同時執行 2 個線程（1個負責開、1個負責關）
#MaxThreadsPerHotkey 2

global toggle := false

$!l::
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
    Send("{Blind}{LButton}")
}

return
