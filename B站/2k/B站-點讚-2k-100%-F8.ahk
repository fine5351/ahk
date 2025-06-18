#Include ../../basic/Function.ahk

F8::
{
    if(!WinActive("ahk_exe msedge.exe") && !WinActive("ahk_exe chrome.exe")){
        return
    }
    BlockInput(true)

    ;點讚
    LeftClickAt(277, 1313, 500)
    ;收藏
    LeftClickAt(573, 1313, 500) 
    ;默認收藏夾
    LeftClickAt(1071, 593, 500)
    ;確定
    LeftClickAt(1257, 982, 500)
    ;分享       
    MoveTo(710, 1310, 500)
    ;動態   
    LeftClickAt(513, 1192, 1500)
    ;發布
    LeftClickAt(1556, 951, 1500) 
    ;關閉
    LeftClickAt(1294, 866)

    BlockInput(false)

    return
}