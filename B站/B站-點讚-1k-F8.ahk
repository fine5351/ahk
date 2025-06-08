#Include ../basic/Function.ahk

F8::
{
    if(!WinActive("ahk_exe msedge.exe") && !WinActive("ahk_exe chrome.exe")){
        return
    }

    ;點讚
    LeftClickAt(217, 972, 500)
    ;收藏
    LeftClickAt(450, 980, 500) 
    ;默認收藏夾
    LeftClickAt(840, 440, 500)
    ;確定
    LeftClickAt(957, 734, 500)
    ;分享       
    MoveTo(566, 971, 500)
    ;動態   
    LeftClickAt(402, 876, 1500)
    ;發布
    LeftClickAt(1168, 715, 1500) 
    ;關閉
    LeftClickAt(976, 671)

    return
}