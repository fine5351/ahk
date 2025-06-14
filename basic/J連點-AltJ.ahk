#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!j::
{
  if( !WinActive("ahk_exe GenshinImpact.exe") and !WinActive("ahk_exe StarRail.exe") and !WinActive("ahk_exe ZenlessZoneZero.exe") ){
    return
  }

  global toggle := !toggle
  if(toggle) {
    SetTimer () => AutoLoop("j", 100, &toggle), -1
  }
}

return