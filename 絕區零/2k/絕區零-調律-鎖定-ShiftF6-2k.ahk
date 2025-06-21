#Include ../../basic/Function.ahk

+F6::
{
    if(!WinActive("ahk_exe ZenlessZoneZero.exe")){
        return
    }
    
    ; 記錄當前鼠標位置
    MouseGetPos(&mouseX, &mouseY)

    BlockInput(true)

    ;點擊棄置
    LeftClickAt(1134, 207, 150)

    BlockInput(false)
    
    ; 恢復鼠標位置
    MouseMove(mouseX, mouseY)

    return
}