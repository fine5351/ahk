#Include ../../basic/Function.ahk

+F1::
{
    if (!IsTargetGame()) {
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
