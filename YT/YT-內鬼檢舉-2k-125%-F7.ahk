#Include ../basic/Function.ahk

F7::
{
    ; if(!WinActive("ahk_exe msedge.exe") && !WinActive("ahk_exe chrome.exe")){
    ;     return
    ; }

    ;三個點
    LeftClickAt(1703, 1289, 500) 
    ;檢舉
    LeftClickAt(1773, 1218, 500) 
    ;錯誤資訊
    LeftClickAt(1012, 999, 500)
    ;繼續
    LeftClickAt(1253, 1094, 500)
    ;新增詳細資訊
    LeftClickAt(1257, 739, 500)
    ;輸入文字
    Send("散佈米哈遊未公布遊戲開資訊, 大概率為誤導或錯誤資訊")
    ;檢舉
    LeftClickAt(1034, 1119, 1500) 
    ;確定
    LeftClickAt(1034, 1119, 1500) 

    return
}