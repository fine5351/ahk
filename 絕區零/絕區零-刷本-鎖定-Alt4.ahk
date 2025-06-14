#Include ../basic/Function.ahk

!4::
{
    if(!WinActive("ahk_exe ZenlessZoneZero.exe")){
        return
    }
    
    BlockInput(true)

    ;點擊棄置
    LeftClickAt(965, 1153, 150)

    BlockInput(false)

    ; 取消 modal
    LeftClickAt(2045, 514, 150)
    LeftClickAt(2045, 514, 150)
    
    return
}