#Include ../../basic/Function.ahk

+F7::
{
    if(!WinActive("ahk_exe msedge.exe") && !WinActive("ahk_exe chrome.exe")){
        return
    }

    ;三個點
    MoveTo(1250, 903, 500)
    ;稿件舉報
    LeftClickAt(1261, 924, 500) 
    ;違法違禁
    LeftClickAt(691, 473, 500)
    ;滾輪下滑
    Loop 10
        Send("{WheelDown}")
    Sleep(500)
    ;詳細描述       
    LeftClickAt(735, 550, 500)
    ;輸入文字
    Send("違法洩漏遊戲未公開資訊")
    ;提交
    LeftClickAt(1169, 820, 1500) 

    return
}