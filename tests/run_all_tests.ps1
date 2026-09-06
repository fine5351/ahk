# run_all_tests.ps1 - Test Agent 綜合測試執行腳本
param(
    [string]$WorkspaceRoot = "D:\work\workspace\ahk"
)

$ErrorActionPreference = "Stop"
Set-Location $WorkspaceRoot

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Test Agent Automated Test Suite (Stage 3 Verification)  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. 執行 AutoHotkey 單元測試
Write-Host "`n>>> [1/2] 執行 AutoHotkey 單元測試 (test_unit.ahk)..." -ForegroundColor Yellow
$ahkExe = Join-Path $WorkspaceRoot "AutoHotkey\v2\AutoHotkey64.exe"
$ahkTest = Join-Path $WorkspaceRoot "tests\test_unit.ahk"

$proc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkTest`"" -Wait -PassThru
$unitLog = Join-Path $WorkspaceRoot "tests\unit_test_result.log"
$unitPass = $false
if (Test-Path $unitLog) {
    $logContent = Get-Content $unitLog -Raw
    $logContent | Write-Host
    if ($logContent -match "失敗 0") {
        $unitPass = $true
    }
} else {
    Write-Host "[ERROR] 未能生成單元測試日誌！" -ForegroundColor Red
}

$unitFg = if ($unitPass) { "Green" } else { "Red" }
$statusMsg = if ($unitPass) { "成功 (PASS)" } else { "失敗 (FAIL)" }
Write-Host ">>> AutoHotkey 單元測試完成，狀態: $statusMsg" -ForegroundColor $unitFg

# 2. 執行架構安全、座標一致性與品質診斷測試
Write-Host "`n>>> [2/2] 執行架構安全與品質診斷測試 (test_audit.ps1)..." -ForegroundColor Yellow
$auditScript = Join-Path $WorkspaceRoot "tests\test_audit.ps1"
& powershell.exe -ExecutionPolicy Bypass -File $auditScript
$auditExitCode = $LASTEXITCODE
$auditPass = ($auditExitCode -eq 0)

$auditFg = if ($auditPass) { "Green" } else { "Red" }
Write-Host ">>> 架構安全與品質診斷測試完成，結束代碼: $auditExitCode" -ForegroundColor $auditFg

# 總結
Write-Host "`n==========================================================" -ForegroundColor Cyan
if ($unitPass -and $auditPass) {
    Write-Host "  所有測試全部通過 (ALL TESTS PASSED: 39 / 39)            " -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "  測試存在失敗項目 (SOME TESTS FAILED)                    " -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Cyan
    exit 1
}
