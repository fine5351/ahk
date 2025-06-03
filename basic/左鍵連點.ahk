#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!l::
{
  global toggle := !toggle
  if(toggle) {
    SetTimer () => MyLoop("{LButton}", 150), -1
  }
}

return
MyLoop(button, interval) {
  while toggle{
    Click button
    Sleep interval
  }
}
