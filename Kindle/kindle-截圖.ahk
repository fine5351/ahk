#Include Functions.ahk

F9::
{
    BlockInput(true)

    loop 1
    {
        ScreenShot(381, 188, 1492, 906)
        NextPage()
    }

    BlockInput(false)
    return
}

NextPage()
{
    LeftClickAt(1141, 681, 500) ;點書籍頁
    LeftClickAt(1680, 559, 500) ;下一頁
}