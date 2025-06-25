#Requires AutoHotkey v2.0
#Include ../../basic/Function.ahk

; 設定圖片目錄的絕對路徑
imageDir := A_ScriptDir "\images-normal\"

F8::
{
    ; 檢查是否在支援的瀏覽器中
    if(!WinActive("ahk_exe msedge.exe") and !WinActive("ahk_exe chrome.exe")) {
        return
    }

    ; 檢查圖片目錄是否存在
    if !DirExist(imageDir) {
        MsgBox "圖片目錄不存在: " imageDir
        return
    }

    ; 定義所有需要點擊的圖片和等待時間
    steps := [
        {image: "finger.png", wait: 250},
        {image: "star.png", wait: 250},
        {image: "default-collection.png", wait: 250},
        {image: "agree.png", wait: 250},
        {image: "share.png", wait: 250},
        {image: "info.png", wait: 250},
        {image: "publish.png", wait: 500}
    ]

    ; 檢查所有圖片是否存在
    for step in steps {
        if !FileExist(imageDir "\" step.image) {
            MsgBox "找不到圖片文件: " imageDir "\" step.image
            return
        }
    }

    ; 依序執行每個步驟
    for step in steps {
        if(!SearchAndClick(imageDir "\" step.image)) {
            MsgBox "找不到" step.image "圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
            return
        }
        Sleep(step.wait)
    }

    ; 最後點擊關閉圖示
    LeftClickAt(1338, 907)
}


