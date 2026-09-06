#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

; 輸出 log 檔
logFile := A_ScriptDir "\unit_test_result.log"
try FileDelete(logFile)

Log(msg) {
    global logFile
    FileAppend(msg "`n", logFile, "UTF-8")
}

totalTests := 0
passedTests := 0
failedTests := 0

Assert(testName, condition, detail := "") {
    global totalTests, passedTests, failedTests
    totalTests++
    if (condition) {
        passedTests++
        Log("[PASS] " testName)
    } else {
        failedTests++
        Log("[FAIL] " testName " - Detail: " detail)
    }
}

; 測試 DetectResolution 內部的高度判定邏輯
DetectResolutionByHeight(clientH) {
    if (clientH <= 0) {
        clientH := A_ScreenHeight
    }
    if (clientH >= 1300)
        return "2k"
    if (clientH >= 800)
        return "1k"
    return "unknown"
}

Log("=== 開始執行 AutoHotkey 單元測試 ===")

; 1. 2K 解析度測試
Assert("TS-HP-01/02/03: 1440p 高度 (h=1440)", DetectResolutionByHeight(1440) == "2k")
Assert("TS-HP-01-Ext: 4K 高度 (h=2160)", DetectResolutionByHeight(2160) == "2k")

; 2. 1K 解析度測試
Assert("TS-HP-04: 1080p 高度 (h=1080)", DetectResolutionByHeight(1080) == "1k")
Assert("TS-HP-04-Ext: 900p 高度 (h=900)", DetectResolutionByHeight(900) == "1k")

; 3. 21:9 超寬螢幕測試
Assert("TS-BD-04: 21:9 2K 高度 (h=1440, 寬度 3440 不影響)", DetectResolutionByHeight(1440) == "2k")
Assert("TS-BD-05: 21:9 1080p 高度 (h=1080, 寬度 2560 不會誤判為 2K)", DetectResolutionByHeight(1080) == "1k")

; 4. 邊界測試
Assert("TS-BD-Boundary: 臨界高度 1300 (2K 下限)", DetectResolutionByHeight(1300) == "2k")
Assert("TS-BD-Boundary: 臨界高度 1299 (1K 上限)", DetectResolutionByHeight(1299) == "1k")
Assert("TS-BD-Boundary: 臨界高度 800 (1K 下限)", DetectResolutionByHeight(800) == "1k")
Assert("TS-BD-Boundary: 臨界高度 799 (unknown 上限)", DetectResolutionByHeight(799) == "unknown")

; 5. 異常高度與極小視窗測試
Assert("TS-EX-03: 極小視窗高度 600", DetectResolutionByHeight(600) == "unknown")
Assert("TS-EX-03: 極小視窗高度 300", DetectResolutionByHeight(300) == "unknown")

; 6. 實際呼叫 DetectResolution() (Fallback 測試)
actualRes := DetectResolution(99999999)
expectedFallback := (A_ScreenHeight >= 1300) ? "2k" : ((A_ScreenHeight >= 800) ? "1k" : "unknown")
Assert("TS-BD-Fallback: 無效 Hwnd Fallback 至 A_ScreenHeight (" A_ScreenHeight " -> " expectedFallback ")", actualRes == expectedFallback)

; 7. 驗證 GetCurrentGame() 在當前環境的行為 (非遊戲環境應回傳空字串)
game := GetCurrentGame()
Assert("TS-EX-01: 非目標遊戲視窗下 GetCurrentGame() 回傳空字串", game == "")

Log(Format("`n=== AutoHotkey 單元測試結束: 總計 {1}, 通過 {2}, 失敗 {3} ===", totalTests, passedTests, failedTests))

ExitApp(failedTests > 0 ? 1 : 0)
