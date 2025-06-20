#Include ../../basic/Function.ahk

!F2::
{
    if(!WinActive("ahk_exe StarRail.exe")){
        return
    }
    BlockInput(true)
    LeftClickAt(618, 472, 150)

    ;下一個
    LeftClickAt(2152, 722, 150)

    BlockInput(false)
    return
}