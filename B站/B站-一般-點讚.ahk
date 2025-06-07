#Requires AutoHotkey v2.0
#Include ../basic/Function.ahk

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

    ; 檢查所有圖片是否存在
    imageFiles := ["finger.png", "star.png", "default-collection.png", "agree.png", "share.png", "info.png", "publish.png"]
    for imageFile in imageFiles {
        if !FileExist(imageDir "\" imageFile) {
            MsgBox "找不到圖片文件: " imageDir "\" imageFile
            return
        }
    }

    ; 1. 點擊手指圖示
    if(!SearchAndClick(imageDir "\finger.png")) {
        MsgBox "找不到手指圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(250)

    ; 2. 點擊星星圖示
    if(!SearchAndClick(imageDir "\star.png")) {
        MsgBox "找不到星星圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(250)

    ; 3. 點擊收藏圖示
    if(!SearchAndClick(imageDir "\default-collection.png")) {
        MsgBox "找不到收藏圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(250)

    ; 4. 點擊同意圖示
    if(!SearchAndClick(imageDir "\agree.png")) {
        MsgBox "找不到同意圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(250)

    ; 5. 點擊分享圖示
    if(!SearchAndClick(imageDir "\share.png")) {
        MsgBox "找不到分享圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(250)

    ; 6. 點擊資訊圖示
    if(!SearchAndClick(imageDir "\info.png")) {
        MsgBox "找不到資訊圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(250)

    ; 7. 點擊發布圖示
    if(!SearchAndClick(imageDir "\publish.png")) {
        MsgBox "找不到發布圖示`n請確認：`n1. 圖片是否清晰`n2. 圖片是否在正確位置`n3. 瀏覽器視窗是否在最前"
        return
    }
    Sleep(500)

    ; 8. 點擊關閉圖示
    LeftClickAt(1338, 907)
    
}

