#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

logFile := "tests/resolution_test_result.log"
try FileDelete(logFile)

Log(msg) {
    global logFile
    FileAppend(msg "`n", logFile, "UTF-8")
    try FileAppend(msg "`n", "*", "UTF-8")
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

TestWindowResolution(width, height, expectedRes, testName) {
    testGui := Gui("+ToolWindow -Caption", "ResolutionTestGui")
    testGui.Show(Format("w{1} h{2} Hide", width, height))
    
    WinGetClientPos(&x, &y, &w, &actualH, testGui.Hwnd)
    actualRes := DetectResolution(testGui.Hwnd)
    testGui.Destroy()
    
    Assert(testName Format(" (W={1}, H={2}, ActualClientH={3}, Expected={4}, Got={5})", width, height, actualH, expectedRes, actualRes), actualRes == expectedRes, "Expected " expectedRes " but got " actualRes)
}

Log("=== 開始執行 DetectResolution 單元測試 ===")

; TS-HP-01 / TS-HP-02 / TS-HP-03: 1440p (2K)
TestWindowResolution(2560, 1440, "2k", "TS-HP-01/02/03: 標準 2K 解析度 (2560x1440)")

; TS-HP-04: 1080p (1K)
TestWindowResolution(1920, 1080, "1k", "TS-HP-04: 標準 1K 解析度 (1920x1080)")

; TS-BD-04: 21:9 超寬螢幕 2K (3440x1440)
TestWindowResolution(3440, 1440, "2k", "TS-BD-04: 21:9 超寬螢幕 2K (3440x1440)")

; TS-BD-05: 21:9 超寬螢幕 1080p (2560x1080)
TestWindowResolution(2560, 1080, "1k", "TS-BD-05: 21:9 超寬螢幕 1080p (2560x1080)")

; TS-EX-03: 極小視窗 (800x600 以下)
TestWindowResolution(800, 600, "unknown", "TS-EX-03: 極小視窗解析度 (800x600)")

; 邊界值測試
TestWindowResolution(1920, 1300, "2k", "TS-BD-Boundary: 臨界高度 1300 (剛好達標 2K)")
TestWindowResolution(1920, 1299, "1k", "TS-BD-Boundary: 臨界高度 1299 (應落入 1K)")
TestWindowResolution(1920, 800, "1k", "TS-BD-Boundary: 臨界高度 800 (剛好達標 1K)")
TestWindowResolution(1920, 799, "unknown", "TS-BD-Boundary: 臨界高度 799 (未達 800，應為 unknown)")

; Fallback 測試
fallbackExpected := (A_ScreenHeight >= 1300) ? "2k" : ((A_ScreenHeight >= 800) ? "1k" : "unknown")
fallbackActual := DetectResolution(99999999)
Assert("TS-BD-Fallback: 無效 Hwnd Fallback 至螢幕高度 (ScreenHeight=" A_ScreenHeight ")", fallbackActual == fallbackExpected, "Expected " fallbackExpected " but got " fallbackActual)

Log(Format("`n=== DetectResolution 測試總結: 總計 {1}, 通過 {2}, 失敗 {3} ===", totalTests, passedTests, failedTests))

if (failedTests > 0) {
    ExitApp(1)
} else {
    ExitApp(0)
}
