#Include ../basic/Function.ahk

!D::
{
    if(!WinActive("ahk_exe StarRail.exe")){
        MsgBox "非崩鐵視窗內"
        return
    }
    BlockInput(true)

    ;點擊棄置
    LeftClickAt(611, 543, 150)

    ;下一個
    LeftClickAt(2152, 722, 150)

    BlockInput(false)
    return
}