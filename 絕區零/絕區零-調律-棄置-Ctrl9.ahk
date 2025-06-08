#Include ../basic/Function.ahk

^9::
{
    if(!WinActive("ahk_exe ZenlessZoneZero.exe")){
        return
    }
    
    ; 記錄當前鼠標位置
    MouseGetPos(&mouseX, &mouseY)
    
    BlockInput(true)

    ;點擊棄置
    LeftClickAt(1041, 216, 150)

    BlockInput(false)
    
    ; 恢復鼠標位置
    MouseMove(mouseX, mouseY)
    
    return
}