#Include ../../basic/Function.ahk

+F2::
{
    if (!IsTargetGame()) {
        return
    }
    BlockInput(true)
    LeftClickAt(618, 472, 150)

    ;下一個
    LeftClickAt(2152, 722, 150)

    BlockInput(false)
    return
}
