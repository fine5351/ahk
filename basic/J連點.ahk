#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!j::
{
  global toggle := !toggle
  if(toggle) {
    SetTimer () => AutoLoop("j", 100), -1
  }
}

return
