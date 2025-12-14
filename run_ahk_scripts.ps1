if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\Honkai3rd\2k\Guild-Contribution-ShiftF5-2k.ahk" -Verb RunAs
Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\StarRail\2k\Abandoned-ShiftF1-2k.ahk" -Verb RunAs
Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\StarRail\2k\Lock-ShiftF2-2k.ahk" -Verb RunAs
Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\ZenlessZoneZero\2k\Stage-Abandoned-ShiftF3-2k.ahk" -Verb RunAs
Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\ZenlessZoneZero\2k\Stage-Lock-ShiftF4-2k.ahk" -Verb RunAs
Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\basic\F-AltF.ahk" -Verb RunAs
Start-Process "C:\Program Files\Autohotkey\v2\AutoHotkey.exe" -ArgumentList "D:\work\workspace\ahk\basic\LeftClick.ahk" -Verb RunAs
