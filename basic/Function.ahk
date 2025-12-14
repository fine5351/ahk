#Requires AutoHotkey v2.0

global TargetGames := ["ahk_exe GenshinImpact.exe", "ahk_exe StarRail.exe", "ahk_exe ZenlessZoneZero.exe",
    "ahk_exe BH3.exe"]

IsTargetGame() {
    for game in TargetGames {
        if WinActive(game)
            return true
    }
    return false
}

ScreenShot(x1, y1, x2, y2, wait := 500) {
    Send("#+s") ; 啟動螢幕截圖工具
    Sleep(wait)
    MouseClickDrag("Left", x1, y1, x2, y2) ; 設定截圖範圍
    Sleep(wait)
}

LeftClickAt(x, y, wait := 100) {
    MoveTo(x, y)
    Send("{LButton}")
    Sleep(wait)
}

RightClickAt(x, y, wait := 100) {
    MoveTo(x, y)
    Send("{RButton}")
    Sleep(wait)
}

MoveTo(x, y, wait := 100) {
    MouseMove(x, y)
    Sleep(wait)
}

AutoLoop(key, sleepTime := 100, &toggle := false) {
    while toggle {
        Send(key)
        Sleep(sleepTime)
    }
}

SearchAndClick(imagePath, x1 := 0, y1 := 0, x2 := A_ScreenWidth, y2 := A_ScreenHeight, wait := 100) {
    ; 使用更精確的搜尋選項
    ; *n: 容差值
    ; *TransN: 指定透明色
    ; *w: 指定寬度
    ; *h: 指定高度
    startTime := A_TickCount
    while (A_TickCount - startTime < 1000) {  ; 最多等待1秒
        if ImageSearch(&foundX, &foundY, x1, y1, x2, y2, "*10 *Trans0xFFFFFF " imagePath) {
            ; 添加固定偏移量來點擊中心
            ; 假設圖標大小約為 32x32 像素
            centerX := foundX + 16
            centerY := foundY + 16

            LeftClickAt(centerX, centerY, wait)
            return true
        }
        Sleep(50)  ; 每次搜尋間隔50毫秒
    }
    return false
}
