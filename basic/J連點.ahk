#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!j::
{
  global toggle := !toggle
  if(toggle) {
    SetTimer () => MyLoop("j", 100), -1
  }
}

return

MyLoop(key, interval) {
  while toggle{
    Send(key)
    Sleep interval
  }
}
