#Include ../basic/Function.ahk

^L::
{
    if(!WinActive("ahk_exe StarRail.exe")){
        MsgBox "非崩鐵視窗內"
        return
    }
    BlockInput(true)

    ;點擊鎖定
    LeftClickAt(618, 472, 150)

    ;下一個
    LeftClickAt(2152, 722, 150)

    BlockInput(false)
    return
}