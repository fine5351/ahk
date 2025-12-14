#Include ../../basic/Function.ahk

+F4::
{
    if (!IsTargetGame()) {
        return
    }
    ; 記錄當前鼠標位置
    MouseGetPos(&mouseX, &mouseY)

    BlockInput(true)

    ;點擊棄置
    LeftClickAt(965, 1153, 150)

    BlockInput(false)

    ; 取消 modal
    LeftClickAt(2045, 514, 150)

    ; 恢復鼠標位置
    MouseMove(mouseX, mouseY)

    return
}
