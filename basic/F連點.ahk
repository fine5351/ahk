#Requires AutoHotkey v2.0
#Include Function.ahk

global toggle := false

!f::
{
  if( !WinActive("ahk_exe GenshinImpact.exe") and !WinActive("ahk_exe StarRail.exe") ){
    return
  }

  global toggle := !toggle
  if(toggle) {
    SetTimer () => AutoLoop("f", 100), -1
  }
}

return