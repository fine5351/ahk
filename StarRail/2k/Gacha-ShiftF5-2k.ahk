#Include ../../basic/Function.ahk

+F5::
{
    if (!IsTargetGame()) {
        return
    }
    BlockInput(true)
    
    ; 1. 點擊「躍遷 10 次」
    LeftClickAt(2150, 1250, 1000)
    
    ; 2. 點擊「確認」購買
    LeftClickAt(1500, 900, 1000)
    
    ; 3. 點擊「跳過」
    LeftClickAt(2460, 70, 1000)
    
    ; 5. 點擊「X」關閉結果畫面
    LeftClickAt(2470, 70, 150)
    
    BlockInput(false)
    return
}
