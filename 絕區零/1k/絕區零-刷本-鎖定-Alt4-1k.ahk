#Include ../../basic/Function.ahk

!4::
{
    if(!WinActive("ahk_exe ZenlessZoneZero.exe")){
        return
    }
    
    ; 記錄當前鼠標位置
    MouseGetPos(&mouseX, &mouseY)

    BlockInput(true)

    ;點擊棄置
    LeftClickAt(727, 859, 150)

    BlockInput(false)

    ; 取消 modal
    LeftClickAt(1541, 365, 150)

    ; 恢復鼠標位置
    MouseMove(mouseX, mouseY)

    return
}