#Include ../basic/Function.ahk

F8::
{
    if(!WinActive("ahk_exe msedge.exe") && !WinActive("ahk_exe chrome.exe")){
        return
    }
    BlockInput(true)

    ;點讚
    LeftClickAt(325, 1271, 500)
    ;收藏
    LeftClickAt(624, 1271, 500) 
    ;默認收藏夾
    LeftClickAt(1148, 563, 500)
    ;確定
    LeftClickAt(1269, 1030, 500)
    ;分享       
    MoveTo(797, 1277, 500)
    ;動態
    LeftClickAt(538, 1148, 1500)
    ;發布
    LeftClickAt(1653, 1003, 1500) 
    ;關閉
    LeftClickAt(1243, 899)

    BlockInput(false)

    return
}