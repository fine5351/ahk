#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

; 自動以管理員權限重新執行腳本（若尚未具備管理員權限）
EnsureAdmin()

; 跨遊戲通用棄置函式
ExecuteAbandoned(isTuning := false) {
    game := GetCurrentGame()
    if (!game) {
        return
    }

    res := DetectResolution()

    switch game {
        case "StarRail":
            if (res == "unknown") {
                ShowTemporaryTooltip("【星穹鐵道】未知的解析度，無法執行棄置", 1500)
                return
            }

            BlockInput(true)
            try {
                if (res == "2k") {
                    ; 點擊棄置
                    LeftClickAt(611, 543, 150)
                    ; 下一個
                    LeftClickAt(2152, 722, 150)
                } else {
                    ; 點擊棄置 (1K)
                    LeftClickAt(456, 407, 150)
                    ; 下一個 (1K)
                    LeftClickAt(1612, 537, 150)
                }
            } finally {
                BlockInput(false)
            }

        case "ZenlessZoneZero":
            if (res == "unknown") {
                ShowTemporaryTooltip("【絕區零】未知的解析度，無法執行棄置", 1500)
                return
            }

            ; 記錄當前鼠標位置
            MouseGetPos(&mouseX, &mouseY)

            BlockInput(true)
            try {
                if (isTuning) {
                    ; 調律模式
                    if (res == "2k") {
                        LeftClickAt(1041, 216, 150)
                    } else {
                        LeftClickAt(781, 162, 150)
                    }
                } else {
                    ; 結算模式
                    if (res == "2k") {
                        ; 點擊棄置
                        LeftClickAt(875, 1143, 150)
                        ; 取消 modal
                        LeftClickAt(2045, 514, 150)
                    } else {
                        ; 點擊棄置 (1K)
                        LeftClickAt(654, 859, 150)
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
            ShowTemporaryTooltip("【原神】尚未設定棄置座標", 1500)
    }
}

; 僅在目標遊戲視窗中攔截熱鍵，其餘應用程式原生透傳
#HotIf IsTargetGame()

; 標準/結算棄置熱鍵
+F1::
+F3::ExecuteAbandoned(false)

; 調律棄置熱鍵
^+F1::
^+F3::ExecuteAbandoned(true)

#HotIf
