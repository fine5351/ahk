#Include ../../basic/Function.ahk

+F5::
{
    if (!IsTargetGame()) {
        return
    }
    BlockInput(true)

    loop 8 {
        ;點擊提交
        LeftClickAt(1354, 974, 150)

        ;點擊提交委託
        LeftClickAt(1208, 856, 150)

        ;點擊放入艦團獎勵池
        LeftClickAt(1001, 815, 150)
        LeftClickAt(1001, 815, 150)
    }
    BlockInput(false)
    return
}
