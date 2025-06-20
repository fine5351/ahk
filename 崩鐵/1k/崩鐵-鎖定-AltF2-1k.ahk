#Include ../../basic/Function.ahk

!F2::
{
    if(!WinActive("ahk_exe StarRail.exe")){
        return
    }
    BlockInput(true)
    LeftClickAt(459, 354, 150)

    ;下一個
    LeftClickAt(1612, 537, 150)

    BlockInput(false)
    return
}