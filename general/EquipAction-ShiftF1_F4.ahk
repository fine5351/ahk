#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

; 自動以管理員權限重新執行腳本（若尚未具備管理員權限）
EnsureAdmin()

; 跨遊戲通用裝備操作函式 (action: "Lock" 或 "Abandon")
ExecuteEquipAction(action, *) {
    game := GetCurrentGame()
    if (!game) {
        return
    }

    actionName := (action == "Lock") ? "鎖定" : "棄置"
    res := DetectResolution()

    switch game {
        case "StarRail":
            if (res == "unknown") {
                ShowTemporaryTooltip("【星穹鐵道】未知的解析度，無法執行" . actionName, 1500)
                return
            }

            BlockInput(true)
            try {
                if (res == "2k") {
                    ; 點擊動作 (鎖定 / 棄置)
                    if (action == "Lock") {
                        LeftClickAt(618, 472, 150)
                    } else {
                        LeftClickAt(611, 543, 150)
                    }
                    ; 下一個
                    LeftClickAt(2152, 722, 150)
                } else {
                    ; 點擊動作 (1K)
                    if (action == "Lock") {
                        LeftClickAt(459, 354, 150)
                    } else {
                        LeftClickAt(456, 407, 150)
                    }
                    ; 下一個 (1K)
                    LeftClickAt(1612, 537, 150)
                }
            } finally {
                BlockInput(false)
            }

        case "ZenlessZoneZero":
            if (res == "unknown") {
                ShowTemporaryTooltip("【絕區零】未知的解析度，無法執行" . actionName, 1500)
                return
            }

            ui := DetectZZZUI(res)
            if (ui == "unknown") {
                ShowTemporaryTooltip("【絕區零】未偵測到相符的介面（支援：刷本、調律、背包、個人裝備）", 1500)
                return
            }

            ; 記錄當前鼠標位置
            MouseGetPos(&mouseX, &mouseY)

            BlockInput(true)
            try {
                switch ui {
                    case "Equip":
                        ; === 個人裝備模式 ===
                        if (res == "2k") {
                            ; 點擊動作 (鎖定 / 棄置)
                            if (action == "Lock") {
                                LeftClickAt(1753, 67, 150)
                            } else {
                                LeftClickAt(1597, 67, 150)
                            }
                        } else { ; 1k
                            ; 點擊動作 (1K)
                            if (action == "Lock") {
                                LeftClickAt(1315, 50, 150)
                            } else {
                                LeftClickAt(1198, 50, 150)
                            }
                        }
                        ; 下一個驅動盤
                        Sleep(50)
                        Send("{Right}")
                        Sleep(100)

                    case "Tune":
                        ; === 調律模式 ===
                        if (res == "2k") {
                            if (action == "Lock") {
                                LeftClickAt(1134, 207, 150)
                            } else {
                                LeftClickAt(1041, 216, 150)
                            }
                        } else { ; 1k
                            if (action == "Lock") {
                                LeftClickAt(851, 155, 150)
                            } else {
                                LeftClickAt(781, 162, 150)
                            }
                        }
                        ; 下一個驅動盤
                        Sleep(50)
                        Send("{Right}")
                        Sleep(100)

                    case "Settle":
                        ; === 刷本結算模式 ===
                        if (res == "2k") {
                            ; 點擊動作 (鎖定 / 棄置)
                            if (action == "Lock") {
                                LeftClickAt(965, 1153, 150)
                            } else {
                                LeftClickAt(875, 1143, 150)
                            }
                            ; 取消 modal (下一個)
                            LeftClickAt(2045, 514, 150)
                        } else { ; 1k
                            ; 點擊動作 (1K)
                            if (action == "Lock") {
                                LeftClickAt(727, 859, 150)
                            } else {
                                LeftClickAt(654, 859, 150)
                            }
                            ; 取消 modal (1K)
                            LeftClickAt(1541, 365, 150)
                        }

                    case "Bag":
                        ; === 背包倉庫模式 ===
                        if (res == "2k") {
                            ; 點擊動作 (鎖定 / 棄置)
                            if (action == "Lock") {
                                LeftClickAt(2040, 1115, 150)
                            } else {
                                LeftClickAt(1930, 1115, 150)
                            }
                        } else { ; 1k
                            ; 點擊動作 (1K)
                            if (action == "Lock") {
                                LeftClickAt(1530, 836, 150)
                            } else {
                                LeftClickAt(1448, 836, 150)
                            }
                        }
                        ; 下一個驅動盤
                        Sleep(50)
                        Send("{Right}")
                        Sleep(100)
                }
                ; 恢復鼠標位置
                MouseMove(mouseX, mouseY)
            } finally {
                BlockInput(false)
            }

        case "GenshinImpact":
            ShowTemporaryTooltip("【原神】尚未設定" . actionName . "座標", 1500)
    }
}

; 絕區零 UI 介面偵測函式 (回傳 "Equip", "Tune", "Settle", "Bag", 或 "unknown")
DetectZZZUI(res) {
    prevCoord := A_CoordModePixel
    CoordMode("Pixel", "Client")

    ui := "unknown"
    try {
        if (res == "2k") {
            ; 1. 個人裝備模式：頂部垃圾桶 (1597, 67) 或 R 鍵標籤 (1520, 67)
            if (IsBrightPixel(1597, 67, 200) || IsBrightPixel(1520, 67, 200)) {
                ui := "Equip"
            ; 2. 調律模式：鎖頭圖標 (1134, 207) 或「調律獲得」標題 (1270, 170)
            } else if (IsBrightPixel(1134, 207, 200) || IsGrayText(1270, 170)) {
                ui := "Tune"
            ; 3. 刷本結算模式：彈窗鎖頭 (965, 1153) 或彈窗垃圾桶 (875, 1143)
            } else if (IsBrightPixel(965, 1153, 200) || IsBrightPixel(875, 1143, 200)) {
                ui := "Settle"
            ; 4. 背包倉庫模式：常駐「DETAIL」標題 (1915, 220) 或右下垃圾桶 (1930, 1115)
            } else if (IsBrightPixel(1915, 220, 200) || IsBrightPixel(1930, 1115, 200)) {
                ui := "Bag"
            }
        } else { ; 1k (1920x1080)
            ; 1. 個人裝備模式 (1K)
            if (IsBrightPixel(1198, 50, 200) || IsBrightPixel(1140, 50, 200)) {
                ui := "Equip"
            ; 2. 調律模式 (1K)
            } else if (IsBrightPixel(851, 155, 200) || IsGrayText(952, 127)) {
                ui := "Tune"
            ; 3. 刷本結算模式 (1K)
            } else if (IsBrightPixel(727, 859, 200) || IsBrightPixel(654, 859, 200)) {
                ui := "Settle"
            ; 4. 背包倉庫模式 (1K)
            } else if (IsBrightPixel(1436, 165, 200) || IsBrightPixel(1448, 836, 200)) {
                ui := "Bag"
            }
        }
    } finally {
        CoordMode("Pixel", prevCoord)
    }
    return ui
}

; 檢查像素是否為高亮度 (白色系)
IsBrightPixel(x, y, minVal := 200) {
    try {
        color := PixelGetColor(x, y)
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF
        return (r >= minVal && g >= minVal && b >= minVal)
    } catch {
        return false
    }
}

; 檢查像素是否為灰色文字 (如「調律獲得」字樣)
IsGrayText(x, y) {
    try {
        color := PixelGetColor(x, y)
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF
        return (Abs(r - 128) < 30 && Abs(g - 128) < 30 && Abs(b - 128) < 30)
    } catch {
        return false
    }
}

; 僅在目標遊戲視窗中攔截熱鍵，其餘應用程式原生透傳
#HotIf IsTargetGame()

; 裝備操作熱鍵 (Shift+F1 棄置、Shift+F2 鎖定)
+F1::ExecuteEquipAction("Abandon")
+F2::ExecuteEquipAction("Lock")

#HotIf
