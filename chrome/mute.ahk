#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe chrome.exe")

; 啟用鍵設為 Alt+1 (!1)
!1:: {
    ; 按下 Alt+V
    Send "!v"

    ; 等待 200 毫秒讓擴充功能或選單反應 (可依需求調整時間)
    Sleep 200

    ; 按下 0
    Send "0"
}

#HotIf