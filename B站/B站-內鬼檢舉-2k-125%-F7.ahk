#Include ../basic/Function.ahk

+F7::
{
    if(!WinActive("ahk_exe msedge.exe") && !WinActive("ahk_exe chrome.exe")){
        return
    }

    ;三個點
    MoveTo(1634, 1279, 500)
    ;稿件舉報
    LeftClickAt(1642, 1193, 500) 
    ;違法違禁
    LeftClickAt(858, 589, 500)
    ;滾輪下滑
    Loop 10
        Send("{WheelDown}")
    Sleep(500)
    ;詳細描述       
    LeftClickAt(922, 749, 500)
    ;輸入文字
    Send("違法洩漏遊戲未公開資訊")
    ;提交
    LeftClickAt(1617, 1138, 1500) 

    return
}