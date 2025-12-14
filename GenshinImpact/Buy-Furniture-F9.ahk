#Include ../basic/Function.ahk

F9::
{
    if (!IsTargetGame()) {
        return
    }
    ; BlockInput(true)

    loop 10 {

        ;物品
        LeftClickAt(1051, 242, 150)
        ;兌換
        LeftClickAt(2303, 1368, 150)
        ;兌換
        LeftClickAt(1502, 1050, 150)
        LeftClickAt(1502, 1050, 150)

    }

    ; BlockInput(false)
    return
}
