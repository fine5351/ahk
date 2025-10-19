#Include ../../basic/Function.ahk

+F5::
{
    if(!WinActive("ahk_exe BH3.exe")){
        return
    }
    BlockInput(true)

    Loop 8
    {
        ;點擊提交
        LeftClickAt(1848, 1276, 150)

        ;點擊提交委託
        LeftClickAt(1658, 1137, 150)

        
        ;點擊放入艦團獎勵池
        LeftClickAt(1436, 1086, 150)
        LeftClickAt(1436, 1086, 150)
    }
    BlockInput(false)
    return
}
