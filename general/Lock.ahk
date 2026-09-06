#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

; 自動以管理員權限重新執行腳本（若尚未具備管理員權限）
EnsureAdmin()

; 跨遊戲通用鎖定函式
ExecuteLock(isTuning := false) {
    game := GetCurrentGame()
    if (!game) {
        return
    }

    res := DetectResolution()

    switch game {
        case "StarRail":
            if (res == "unknown") {
                ShowTemporaryTooltip("【星穹鐵道】未知的解析度，無法執行鎖定", 1500)
                return
            }

            BlockInput(true)
            try {
                if (res == "2k") {
                    ; 點擊鎖定
                    LeftClickAt(618, 472, 150)
                    ; 下一個
                    LeftClickAt(2152, 722, 150)
                } else {
                    ; 點擊鎖定 (1K)
                    LeftClickAt(459, 354, 150)
                    ; 下一個 (1K)
                    LeftClickAt(1612, 537, 150)
                }
            } finally {
                BlockInput(false)
            }

        case "ZenlessZoneZero":
            if (res == "unknown") {
                ShowTemporaryTooltip("【絕區零】未知的解析度，無法執行鎖定", 1500)
                return
            }

            ; 記錄當前鼠標位置
            MouseGetPos(&mouseX, &mouseY)

            BlockInput(true)
            try {
                if (isTuning) {
                    ; 調律模式
                    if (res == "2k") {
                        LeftClickAt(1134, 207, 150)
                    } else {
                        LeftClickAt(851, 155, 150)
                    }
                } else {
                    ; 結算模式
                    if (res == "2k") {
                        ; 點擊鎖定
                        LeftClickAt(965, 1153, 150)
                        ; 取消 modal
                        LeftClickAt(2045, 514, 150)
                    } else {
                        ; 點擊鎖定 (1K)
                        LeftClickAt(727, 859, 150)
                        ; 取消 modal (1K)
                        LeftClickAt(1541, 365, 150)
                    }
                }
                ; 恢復鼠標位置
                MouseMove(mouseX, mouseY)
            } finally {
                BlockInput(false)
            }

        case "GenshinImpact":
            ShowTemporaryTooltip("【原神】尚未設定鎖定座標", 1500)
    }
}

; 僅在目標遊戲視窗中攔截熱鍵，其餘應用程式原生透傳
#HotIf IsTargetGame()

; 標準/結算鎖定熱鍵
+F2::
+F4::ExecuteLock(false)

; 調律鎖定熱鍵
^+F2::
^+F4::ExecuteLock(true)

#HotIf
