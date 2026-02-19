if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\Honkai3rd\1k\Guild-Contribution-ShiftF5-1k.ahk" -Verb RunAs
# Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\StarRail\1k\Abandoned-ShiftF1-1k.ahk" -Verb RunAs
# Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\StarRail\1k\Lock-ShiftF2-1k.ahk" -Verb RunAs
# Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\ZenlessZoneZero\1k\Stage-Abandoned-ShiftF3-1k.ahk" -Verb RunAs
# Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\ZenlessZoneZero\1k\Stage-Lock-ShiftF4-1k.ahk" -Verb RunAs
# Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\basic\F-AltF.ahk" -Verb RunAs
# Start-Process ".\AutoHotkey\v2\AutoHotkey.exe" -ArgumentList ".\basic\LeftClick.ahk" -Verb RunAs
