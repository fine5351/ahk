#Include ../../basic/Function.ahk

+F3::
{
    if(!WinActive("ahk_exe ZenlessZoneZero.exe")){
        return
    }
    
    BlockInput(true)

    ;點擊棄置
    LeftClickAt(875, 1143, 150)

    BlockInput(false)

    ; 取消 modal
    LeftClickAt(2045, 514, 150)
    LeftClickAt(2045, 514, 150)
    
    return
}