#Include Functions.ahk

F9::
BlockInput, On 

loop, 1
{
    ScreenShot(196, 164, 738, 921)
    Translatte()
    NextPage()
}

BlockInput, Off
Return

Translatte(){
    LeftClickAt(1182, 403) ;點翻譯畫面
    Send ^v ;ctrl+v 貼上
    Sleep(1000)
    LeftClickAt(1734, 307) ;點擊下載
    Send("{Esc}") ;關閉下載視窗
    LeftClickAt(1804, 290) ;清除圖片
}

NextPage(){
    LeftClickAt(522, 531, 500) ;點書籍頁
    LeftClickAt(844, 569, 500) ;下一頁
}