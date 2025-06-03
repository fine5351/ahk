#Requires AutoHotkey v2.0

ScreenShot(x1,y1,x2,y2,wait:=500)
{
    Send("#+s") ; 啟動螢幕截圖工具
    Sleep(wait) 
    MouseClickDrag("Left", x1,y1,x2,y2) ; 設定截圖範圍
    Sleep(wait) 
}

LeftClickAt(x,y, wait:=100)
{
    MoveTo(x, y)
    Send("{LButton}")
    Sleep(wait)
}

RightClickAt(x,y, wait:=100)
{
    MoveTo(x, y)
    Send("{RButton}")
    Sleep(wait)
}

MoveTo(x,y, wait:=100)
{
    MouseMove(x, y)
    Sleep(wait)
}

MyLoop(key, sleepTime:=100)
{
    while toggle {
        Send(key)
        Sleep(sleepTime)
    }
}