# 檢查並確保以系統管理員權限執行
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

Set-Location $PSScriptRoot

# 停止目前正在執行的舊版或既有 AutoHotkey 腳本進程
Stop-Process -Name "AutoHotkey*" -Force -ErrorAction SilentlyContinue

$ahkExe = "$PSScriptRoot\AutoHotkey\v2\AutoHotkey.exe"

# 啟動通用跨遊戲行為腳本與各項常駐工具腳本
Start-Process $ahkExe -ArgumentList "$PSScriptRoot\general\Abandoned.ahk" -Verb RunAs
Start-Process $ahkExe -ArgumentList "$PSScriptRoot\general\Lock.ahk" -Verb RunAs
Start-Process $ahkExe -ArgumentList "$PSScriptRoot\general\Gacha-2k.ahk" -Verb RunAs
Start-Process $ahkExe -ArgumentList "$PSScriptRoot\basic\F-AltF.ahk" -Verb RunAs
Start-Process $ahkExe -ArgumentList "$PSScriptRoot\basic\LeftClick.ahk" -Verb RunAs
Start-Process $ahkExe -ArgumentList "$PSScriptRoot\chrome\mute-Alt1.ahk" -Verb RunAs
