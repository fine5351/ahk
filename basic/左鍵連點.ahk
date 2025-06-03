#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!l::
{
  global toggle := !toggle
  if(toggle) {
    SetTimer () => AutoLoop("{LButton}", 150), -1
  }
}

return
