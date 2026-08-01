#Include ../basic/Function.ahk

global GachaLoopCount := 8       ; 預設抽卡輪數 (1 次 = 不影響原本單次功能)
global GachaLoopDelayMs := 2000  ; 每輪抽卡之間的延遲時間 (毫秒)
global IsGachaLoopRunning := false

; 按 Ctrl+Shift+F5 可彈出視窗動態指定重複抽卡輪數
^+F5::
{
    global GachaLoopCount
    ib := InputBox("請輸入重複抽卡輪數：", "設定重複抽卡次數", "w250 h130", String(GachaLoopCount))
    if (ib.Result == "OK" && IsNumber(ib.Value) && Integer(ib.Value) > 0) {
        GachaLoopCount := Integer(ib.Value)
        ToolTip("已設定重複抽卡輪數為: " GachaLoopCount " 次")
        SetTimer(() => ToolTip(), -2000)
    }
}

; 緊急停止熱鍵 Esc：僅在抽卡循環執行期間生效，隨時按 Esc 可立刻停止後續輪數
#HotIf IsGachaLoopRunning
Esc::
{
    global IsGachaLoopRunning := false
    ToolTip("【抽卡腳本】已手動觸發停止！將於當前輪次結束後終止循環。")
    SetTimer(() => ToolTip(), -2000)
}
#HotIf

+F5::
{
    if (!IsTargetGame()) {
        return
    }

    ExecuteGachaLoop()
    return
}

ExecuteGachaLoop() {
    global IsGachaLoopRunning, GachaLoopCount, GachaLoopDelayMs
    IsGachaLoopRunning := true
    
    Loop GachaLoopCount {
        if (!IsGachaLoopRunning)
            break
            
        if (WinActive("ahk_exe ZenlessZoneZero.exe")) {
            GachaZenlessZoneZero2K()
        } else if (WinActive("ahk_exe StarRail.exe")) {
            GachaStarRail2K()
        } else if (WinActive("ahk_exe GenshinImpact.exe")) {
            GachaGenshinImpact2K()
        }
        
        ; 若非最後一輪，執行可中斷的延遲
        if (A_Index < GachaLoopCount && IsGachaLoopRunning) {
            if (!DelayWithCancelCheck(GachaLoopDelayMs))
                break
        }
    }
    
    IsGachaLoopRunning := false
}

DelayWithCancelCheck(ms) {
    step := 50
    elapsed := 0
    while (elapsed < ms) {
        if (!IsGachaLoopRunning)
            return false
        Sleep(step)
        elapsed += step
    }
    return IsGachaLoopRunning
}

GachaZenlessZoneZero2K() {
    BlockInput(true)
    
    ; 1. 點擊「調頻 / 搜尋 10 次」(x: 2260, y: 1365)
    ; 等待彈窗完全載入 (1200ms)
    LeftClickAt(2260, 1365, 1200)
    
    ; 2. 點擊「確認」購買/搜尋 (x: 1500, y: 900)
    ; 等待動畫載入並出現右上角 SKIP 按鈕 (3000ms)
    LeftClickAt(1500, 900, 2000)
    
    ; 3. 點擊右上角「跳過」(x: 2460, y: 70)
    ; 等待跳過動畫並展現 10 連抽結果畫面 (2500ms)
    LeftClickAt(2460, 70, 1500)
    LeftClickAt(2460, 70, 4000)
    
    ; 3. 點擊確認
    LeftClickAt(1433, 1122, 1000)
    
    BlockInput(false)
}

GachaStarRail2K() {
    BlockInput(true)
    
    ; 1. 點擊「躍遷 10 次」
    LeftClickAt(2150, 1250, 1200)
    
    ; 2. 點擊「確認」購買
    LeftClickAt(1500, 900, 2000)
    
    ; 3. 點擊「跳過」
    LeftClickAt(2460, 70, 2000)
    
    ; 4. 點擊「X」關閉結果畫面
    LeftClickAt(2470, 70, 500)
    
    BlockInput(false)
}

GachaGenshinImpact2K() {
    BlockInput(true)
    
    ; 1. 點擊「祈願 10 次」
    LeftClickAt(2150, 1250, 1200)
    
    ; 2. 點擊「確認」購買
    LeftClickAt(1500, 900, 2000)
    
    ; 3. 點擊「跳過」
    LeftClickAt(2460, 70, 2000)
    
    ; 4. 點擊「X」關閉結果畫面
    LeftClickAt(2470, 70, 500)
    
    BlockInput(false)
}
