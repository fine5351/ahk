#Include ../basic/Function.ahk

F10::{
    if(!WinActive("ahk_exe StarRail.exe")){
        return
    }
    BlockInput(true)

    ;識別當前畫面中選取的遺棄, 判斷是否包含暴擊率、暴擊傷害、速度這3個字串中其中2個
    keywords := ["暴擊率", "暴擊傷害", "速度"]
    matchCount := 0

    for keyword in keywords {
        if (ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 " . keyword . ".png")) {
            matchCount++
        }
    }

    if (matchCount >= 2) {
        MsgBox("符合條件:包含至少2個關鍵詞")
    } else {
        MsgBox("不符合條件:包含少於2個關鍵詞")
    }

    BlockInput(false)
    return
}   