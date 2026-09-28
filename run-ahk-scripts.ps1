# 檢查並確保以系統管理員權限執行
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

Set-Location $PSScriptRoot

# 停止目前正在執行的舊版或既有 AutoHotkey 腳本進程
Stop-Process -Name "AutoHotkey*" -Force -ErrorAction SilentlyContinue

$ahkExe = "$PSScriptRoot\AutoHotkey\v2\AutoHotkey.exe"

# 1. 指定欲自動掃描並載入的資料夾清單
$targetFolders = @(
    "$PSScriptRoot\general",
    "$PSScriptRoot\chrome",
    "$PSScriptRoot\basic"
)

# 2. 排除純函式庫或非獨立執行的腳本
$excludeFiles = @(
    "Function.ahk"
)

Write-Host "正在掃描並啟動 AutoHotkey 腳本..." -ForegroundColor Cyan

# 3. 動態迴圈遍歷啟動
foreach ($folder in $targetFolders) {
    if (Test-Path $folder) {
        $scripts = Get-ChildItem -Path $folder -Filter "*.ahk" | Where-Object { $excludeFiles -notcontains $_.Name }
        foreach ($script in $scripts) {
            Write-Host "  [啟動] $($script.Name)" -ForegroundColor Green
            Start-Process $ahkExe -ArgumentList "`"$($script.FullName)`"" -Verb RunAs
        }
    }
}

Write-Host "所有指定資料夾內的腳本已成功啟動！" -ForegroundColor Cyan
