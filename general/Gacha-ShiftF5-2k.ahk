#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

; 強制座標與像素搜尋統一使用視窗客戶區 (Client)
CoordMode("Mouse", "Client")
CoordMode("Pixel", "Client")

; ==============================================================================
; 【五星 / S 級出金檢測參數調整專區】
; 說明：如果未來遊戲改版、畫質設定變更導致檢測出金失敗，請在此專區進行微調。
; 提示：遊戲中可隨時按下「Ctrl + F6」查看滑鼠所在位置的座標與 RGB 色碼！
; ==============================================================================
global GoldDetectionConfig := {
    ; 1. 檢測模式: "Pixel" (像素顏色檢測，推薦) 或 "Image" (圖片截圖比對)
    Mode: "Pixel",

    ; 2. 結算畫面等待時間 (毫秒)：點擊「跳過」後等待幾毫秒再開始檢測
    ;    若過早檢測（畫面還在黑屏或淡入）會抓不到，建議 2000 ~ 3500
    WaitAfterSkipMs: 2500,

    ; 3. 五星金色目標色碼 (RGB 十六進位，如 0xFFD700)
    ;    米哈遊通用五星金色光芒/卡片底色色系：
    ;    - 0xFFD23C: 耀眼亮金
    ;    - 0xFFE066: 淺金高光
    ;    - 0xE5A93C: 偏橙金底色
    TargetColors: [0xFFD23C, 0xFFE066, 0xE5A93C],

    ; 4. 色彩容差值 (0 ~ 255)：
    ;    - 若「抽到五星卻沒停」：代表容差太嚴格，請調大 (例如 30 -> 40 -> 50)
    ;    - 若「沒出金卻誤停」  ：代表容差太寬鬆，請調小 (例如 30 -> 20 -> 15)
    ColorVariation: 30,

    ; 5. 檢測區域 [x1, y1, x2, y2] (以 2K: 2560x1440 為基準，1K 會自動乘以 0.75)
    ;    預設涵蓋中央 10 聯卡片結算區域，避開右上角跳過按鈕與四周黑邊
    SearchArea2K: [400, 250, 2160, 1150],

    ; 6. 若將 Mode 改為 "Image"，截圖存放之相對路徑 (例如 40x40 像素的金色星星圖示)
    ImageFilePath: "images/gold_star.png"
}

; ==============================================================================
; 【遊戲抽卡行為配置清單 (Gacha Profiles)】
; 擴充說明：未來若要加入其他遊戲 (如鳴潮 Wuthering Waves 等)，只需在此陣列依格式追加一組物件！
; 所有座標基準均為 2K (2560x1440)，在 1K (1920x1080) 解析度下系統會自動乘以 0.75 縮放。
; ==============================================================================
global GachaProfiles := [
    {
        name: "原神",
        exes: ["ahk_exe GenshinImpact.exe", "ahk_exe YuanShen.exe"],
        steps: [
            { name: "祈願 10 次", x: 2150, y: 1250, wait: 1200 },
            { name: "確認購買",   x: 1500, y: 900,  wait: 2000 },
            { name: "跳過動畫",   x: 2460, y: 70,   wait: 2000 }
        ],
        closeButton: { name: "關閉結算", x: 2470, y: 70, wait: 500 }
    },
    {
        name: "崩壞：星穹鐵道",
        exes: ["ahk_exe StarRail.exe"],
        steps: [
            { name: "躍遷 10 次", x: 2150, y: 1250, wait: 1200 },
            { name: "確認購買",   x: 1500, y: 900,  wait: 2000 },
            { name: "跳過動畫",   x: 2460, y: 70,   wait: 2000 }
        ],
        closeButton: { name: "關閉結算", x: 2470, y: 70, wait: 500 }
    },
    {
        name: "絕區零",
        exes: ["ahk_exe ZenlessZoneZero.exe"],
        steps: [
            { name: "調頻 10 次", x: 2260, y: 1365, wait: 1200 },
            { name: "確認搜尋",   x: 1500, y: 900,  wait: 2000 },
            { name: "跳過動畫1",  x: 2460, y: 70,   wait: 1500 },
            { name: "跳過動畫2",  x: 2460, y: 70,   wait: 3000 }
        ],
        closeButton: { name: "確認結果", x: 1433, y: 1122, wait: 1000 },
        ; 絕區零專屬出金檢測參數 (依據 resources/zzz/角色出金.png 與 resources/zzz/武器出金.png 配置)
        ; 說明：10 連抽結算畫面中，最高稀有度必固定排在第 1 格 (Row 1, Col 1)
        goldCheck: {
            ; 第 1 格 S 級標籤檢測區域 (2K: 2560x1440 基準: X: 390~490, Y: 610~715)
            sRankArea2K: [390, 610, 490, 715],
            ; 第 1 格卡片頂部邊框檢測區域 (2K 基準: X: 420~680, Y: 495~505)
            cardBorderArea2K: [420, 495, 680, 505],
            ; S 級金色目標色碼 (耀眼亮金、高光金、橙金)
            targetColors: [0xFFD23C, 0xFFE066, 0xF5A623, 0xFFB800, 0xE5A93C],
            colorVariation: 25,
            ; 參考畫面（相對路徑）：resources/zzz/角色出金.png, resources/zzz/武器出金.png
            referenceImages: ["resources/zzz/角色出金.png", "resources/zzz/武器出金.png"]
        }
    }
]

; ==============================================================================
; 全域運行變數
; ==============================================================================
global GachaLoopCount := 8       ; 預設抽卡輪數
global GachaLoopDelayMs := 2000  ; 每輪抽卡之間的延遲時間 (毫秒)
global IsGachaLoopRunning := false

; ------------------------------------------------------------------------------
; 熱鍵 1: Ctrl + Shift + F5 - 設定重複抽卡輪數
; ------------------------------------------------------------------------------
^+F5::
{
    global GachaLoopCount
    ib := InputBox("請輸入重複抽卡輪數：", "設定重複抽卡次數", "w250 h130", String(GachaLoopCount))
    if (ib.Result == "OK" && IsNumber(ib.Value) && Integer(ib.Value) > 0) {
        GachaLoopCount := Integer(ib.Value)
        ShowTemporaryTooltip("已設定重複抽卡輪數為: " GachaLoopCount " 次", 2000)
    }
}

; ------------------------------------------------------------------------------
; 熱鍵 2: Esc - 緊急停止 (僅在抽卡執行期間生效)
; ------------------------------------------------------------------------------
#HotIf IsGachaLoopRunning
Esc::
{
    global IsGachaLoopRunning := false
    ShowTemporaryTooltip("【抽卡腳本】已手動觸發停止！將於當前動作結束後終止循環。", 2500)
}
#HotIf

; ------------------------------------------------------------------------------
; 熱鍵 3: Shift + F5 - 啟動抽卡循環 (出金即停)
; ------------------------------------------------------------------------------
+F5::
{
    if (!IsTargetGame()) {
        ShowTemporaryTooltip("非支援的遊戲視窗，請先切換至遊戲視窗！", 2000)
        return
    }

    currentProfile := GetCurrentProfile()
    if (!currentProfile) {
        ShowTemporaryTooltip("找不到當前遊戲的設定設定檔！", 2000)
        return
    }

    ExecuteGachaLoop(currentProfile)
}

; ------------------------------------------------------------------------------
; 熱鍵 4: Ctrl + F6 - 取色與檢測除錯輔助工具 (方便使用者微調色碼與座標)
; ------------------------------------------------------------------------------
^F6::
{
    MouseGetPos(&mouseX, &mouseY)
    colorHex := PixelGetColor(mouseX, mouseY, "RGB")
    ratio := GetScaleRatio()
    resText := (ratio == 0.75) ? "1K (縮放 0.75)" : "2K (1.0)"

    currentProfile := GetCurrentProfile()
    gameName := currentProfile ? currentProfile.name : "未知遊戲"

    ; 即時測試當前畫面是否符合出金條件
    isGold := CheckIfGoldDetected(currentProfile)

    statusMsg := isGold ? "【✅ 檢測到出金畫面 (停止條件達成)】" : "【❌ 未檢測到出金畫面】"
    msg := "=== 取色與出金檢測除錯 ===`n"
        .  "當前目標遊戲: " gameName "`n"
        .  "當前滑鼠座標: X=" mouseX ", Y=" mouseY "`n"
        .  "當前位置色碼: " Format("0x{:06X}", colorHex) "`n"
        .  "當前螢幕解析度: " resText "`n"
        .  "出金檢測結果: " statusMsg "`n`n"
        .  "說明：絕區零依據結算畫面第 1 格 S 級角色/武器金色標籤與邊框檢測；原神/星鐵使用全域金色檢測。"

    MsgBox(msg, "出金檢測除錯輔助", "T10")
}

; ==============================================================================
; 核心業務邏輯
; ==============================================================================

; 解析度縮放比例換算 (2K 基準為 1.0, 1K 為 0.75)
GetScaleRatio() {
    res := DetectResolution()
    return (res == "1k") ? 0.75 : 1.0
}

ScaleX(x) => Round(x * GetScaleRatio())
ScaleY(y) => Round(y * GetScaleRatio())

; 依據當前活動視窗匹配 Profile
GetCurrentProfile() {
    global GachaProfiles
    for profile in GachaProfiles {
        for exeName in profile.exes {
            if WinActive(exeName)
                return profile
        }
    }
    return ""
}

; 執行抽卡主迴圈
ExecuteGachaLoop(profile) {
    global IsGachaLoopRunning, GachaLoopCount, GachaLoopDelayMs
    IsGachaLoopRunning := true
    
    ShowTemporaryTooltip("開始執行【" profile.name "】抽卡（出金即停模式）...", 2000)

    Loop GachaLoopCount {
        if (!IsGachaLoopRunning)
            break
            
        ; 1. 執行單輪 10 連抽點擊步驟 (調頻/跳過等)
        PerformGachaSteps(profile)
        
        if (!IsGachaLoopRunning)
            break

        ; 2. 等待結算畫面穩定並動態輪詢檢測出金
        ;    絕區零出金時會呈現「調頻結果」結算畫面 (角色出金或武器出金)，動態輪詢確保看到畫面才判定
        isGold := false
        pollInterval := 200
        maxWait := (profile.name == "絕區零") ? 3500 : GoldDetectionConfig.WaitAfterSkipMs
        waited := 0
        
        while (waited < maxWait) {
            if (!IsGachaLoopRunning)
                break
            Sleep(pollInterval)
            waited += pollInterval
            
            ; 輪詢檢測是否已出現出金特徵
            if (CheckIfGoldDetected(profile)) {
                ; 防抖二次確認 (間隔 150ms 再次檢驗，確保畫面完全載入靜止而非動態閃爍)
                Sleep(150)
                if (CheckIfGoldDetected(profile)) {
                    isGold := true
                    break
                }
            }
        }

        if (!IsGachaLoopRunning)
            break

        ; 3. 若檢測到出金：停在當前畫面，發出提示聲並終止迴圈
        if (isGold) {
            SoundBeep(1000, 300)
            Sleep(100)
            SoundBeep(1500, 500)
            ShowTemporaryTooltip("🎉【" profile.name "】恭喜出金！已檢測到出金畫面，停止抽卡迴圈。", 5000)
            IsGachaLoopRunning := false
            break
        }

        ; 4. 若未出金，點擊關閉/確認按鈕回到抽卡主畫面
        BlockInput(true)
        LeftClickAt(ScaleX(profile.closeButton.x), ScaleY(profile.closeButton.y), profile.closeButton.wait)
        BlockInput(false)

        ; 5. 輪次間延遲
        if (A_Index < GachaLoopCount && IsGachaLoopRunning) {
            if (!DelayWithCancelCheck(GachaLoopDelayMs))
                break
        }
    }
    
    IsGachaLoopRunning := false
}

; 執行單輪點擊動作
PerformGachaSteps(profile) {
    global IsGachaLoopRunning
    BlockInput(true)
    for step in profile.steps {
        if (!IsGachaLoopRunning) {
            BlockInput(false)
            return
        }
        LeftClickAt(ScaleX(step.x), ScaleY(step.y), step.wait)
    }
    BlockInput(false)
}

; 檢測結算畫面是否出金 (回傳 true / false)
CheckIfGoldDetected(profile := "") {
    global GoldDetectionConfig
    
    if (!profile)
        profile := GetCurrentProfile()

    ; 針對「絕區零」專屬出金檢測 (依據結算畫面第 1 格 S 級角色/武器金色特徵)
    if (profile && profile.name == "絕區零" && profile.HasOwnProp("goldCheck")) {
        return CheckZZZGoldDetected(profile.goldCheck)
    }

    ; 原神 / 星穹鐵道 通用出金檢測
    ratio := GetScaleRatio()
    sx1 := Round(GoldDetectionConfig.SearchArea2K[1] * ratio)
    sy1 := Round(GoldDetectionConfig.SearchArea2K[2] * ratio)
    sx2 := Round(GoldDetectionConfig.SearchArea2K[3] * ratio)
    sy2 := Round(GoldDetectionConfig.SearchArea2K[4] * ratio)

    ; 模式 A: 圖片截圖比對
    if (GoldDetectionConfig.Mode == "Image") {
        if FileExist(GoldDetectionConfig.ImageFilePath) {
            if ImageSearch(&foundX, &foundY, sx1, sy1, sx2, sy2, "*" GoldDetectionConfig.ColorVariation " " GoldDetectionConfig.ImageFilePath) {
                return true
            }
        }
        return false
    }

    ; 模式 B: 像素顏色搜尋 (預設)
    for color in GoldDetectionConfig.TargetColors {
        if PixelSearch(&foundX, &foundY, sx1, sy1, sx2, sy2, color, GoldDetectionConfig.ColorVariation) {
            return true
        }
    }

    return false
}

; 絕區零專屬出金檢測：依據調頻結果結算畫面第 1 格 S 級角色/武器特徵
; 參考圖標注（相對路徑）：resources/zzz/角色出金.png, resources/zzz/武器出金.png
CheckZZZGoldDetected(goldCheck) {
    ratio := GetScaleRatio()
    
    ; 1. 檢測第 1 格 S RANK 專屬標籤區域 (2K 基準: X: 390~490, Y: 610~715)
    ;    角色出金與武器出金在此處均呈現大尺寸金黃色「S」字與金色標籤；A 級為紫色「A」，B 級為藍色「B」
    sx1 := Round(goldCheck.sRankArea2K[1] * ratio)
    sy1 := Round(goldCheck.sRankArea2K[2] * ratio)
    sx2 := Round(goldCheck.sRankArea2K[3] * ratio)
    sy2 := Round(goldCheck.sRankArea2K[4] * ratio)

    for color in goldCheck.targetColors {
        if PixelSearch(&foundX, &foundY, sx1, sy1, sx2, sy2, color, goldCheck.colorVariation) {
            foundColor := PixelGetColor(foundX, foundY, "RGB")
            r := (foundColor >> 16) & 0xFF
            g := (foundColor >> 8) & 0xFF
            b := foundColor & 0xFF
            ; 嚴格金色光譜檢驗：高紅 (R>=170)、高綠 (G>=115)、低藍 (B<=110)，且紅與綠顯著大於藍 (排除紫色與藍色)
            if (r >= 170 && g >= 115 && b <= 110 && (r - b > 60) && (g - b > 20)) {
                return true
            }
        }
    }

    ; 2. 輔助檢測：檢測第 1 格頂部金色發光邊框 (2K 基準: X: 420~680, Y: 495~505)
    bx1 := Round(goldCheck.cardBorderArea2K[1] * ratio)
    by1 := Round(goldCheck.cardBorderArea2K[2] * ratio)
    bx2 := Round(goldCheck.cardBorderArea2K[3] * ratio)
    by2 := Round(goldCheck.cardBorderArea2K[4] * ratio)

    for color in goldCheck.targetColors {
        if PixelSearch(&foundX, &foundY, bx1, by1, bx2, by2, color, goldCheck.colorVariation) {
            foundColor := PixelGetColor(foundX, foundY, "RGB")
            r := (foundColor >> 16) & 0xFF
            g := (foundColor >> 8) & 0xFF
            b := foundColor & 0xFF
            if (r >= 180 && g >= 120 && b <= 100 && (r - b > 70)) {
                return true
            }
        }
    }

    return false
}

; 可被中斷的延遲等待
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
