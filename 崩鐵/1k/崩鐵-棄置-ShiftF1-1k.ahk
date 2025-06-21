#Include ../../basic/Function.ahk

+F1::
{
    if(!WinActive("ahk_exe StarRail.exe")){
        return
    }
    BlockInput(true)

    ;點擊棄置
    LeftClickAt(456, 407, 150)

    ;下一個
    LeftClickAt(1612, 537, 150)

    BlockInput(false)
    return
}