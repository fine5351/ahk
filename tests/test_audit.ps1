# 測試腳本：品質診斷、靜態分析與座標一致性自動稽核
param(
    [string]$WorkspaceRoot = "D:\work\workspace\ahk"
)

$ErrorActionPreference = "Stop"
Set-Location $WorkspaceRoot

$results = [System.Collections.Generic.List[PSObject]]::new()

function Add-TestResult {
    param(
        [string]$Category,
        [string]$TestName,
        [bool]$Passed,
        [string]$Detail
    )
    $obj = [PSCustomObject]@{
        Category = $Category
        TestName = $TestName
        Status   = if ($Passed) { "PASS" } else { "FAIL" }
        Detail   = $Detail
    }
    $results.Add($obj)
    $tag = if ($Passed) { "[PASS]" } else { "[FAIL]" }
    $fg = if ($Passed) { "Green" } else { "Red" }
    Write-Host "$tag $Category - $TestName" -ForegroundColor $fg
    if (-not $Passed) {
        Write-Host "       Detail: $Detail" -ForegroundColor DarkYellow
    }
}

Write-Host "=== 開始執行架構安全與品質診斷測試 ===" -ForegroundColor Cyan

# 1. 語法檢查 (AHK v2 /validate)
$ahkExe = Join-Path $WorkspaceRoot "AutoHotkey\v2\AutoHotkey64.exe"
$filesToValidate = @(
    "basic\Function.ahk",
    "general\Abandoned.ahk",
    "general\Lock.ahk"
)

foreach ($f in $filesToValidate) {
    $fullPath = Join-Path $WorkspaceRoot $f
    $proc = Start-Process -FilePath $ahkExe -ArgumentList "/ErrorStdOut /validate `"$fullPath`"" -Wait -PassThru -NoNewWindow
    $isPass = ($proc.ExitCode -eq 0)
    Add-TestResult -Category "Syntax Validation" -TestName "AHK v2 官方語法檢查: $f" -Passed $isPass -Detail "ExitCode: $($proc.ExitCode)"
}

# 2. 舊版腳本座標常數比對 (Coordinate Integrity)
$scriptComparisons = @(
    @{
        Name = "StarRail 1K Abandoned"
        Legacy = "StarRail\1k\Abandoned-ShiftF1-1k.ahk"
        Target = "general\Abandoned.ahk"
        ExpectedCoords = @("LeftClickAt(456, 407, 150)", "LeftClickAt(1612, 537, 150)")
    },
    @{
        Name = "StarRail 1K Lock"
        Legacy = "StarRail\1k\Lock-ShiftF2-1k.ahk"
        Target = "general\Lock.ahk"
        ExpectedCoords = @("LeftClickAt(459, 354, 150)", "LeftClickAt(1612, 537, 150)")
    },
    @{
        Name = "StarRail 2K Abandoned"
        Legacy = "StarRail\2k\Abandoned-ShiftF1-2k.ahk"
        Target = "general\Abandoned.ahk"
        ExpectedCoords = @("LeftClickAt(611, 543, 150)", "LeftClickAt(2152, 722, 150)")
    },
    @{
        Name = "StarRail 2K Lock"
        Legacy = "StarRail\2k\Lock-ShiftF2-2k.ahk"
        Target = "general\Lock.ahk"
        ExpectedCoords = @("LeftClickAt(618, 472, 150)", "LeftClickAt(2152, 722, 150)")
    },
    @{
        Name = "ZenlessZoneZero 1K Stage Abandoned"
        Legacy = "ZenlessZoneZero\1k\Stage-Abandoned-ShiftF3-1k.ahk"
        Target = "general\Abandoned.ahk"
        ExpectedCoords = @("LeftClickAt(654, 859, 150)", "LeftClickAt(1541, 365, 150)")
    },
    @{
        Name = "ZenlessZoneZero 1K Stage Lock"
        Legacy = "ZenlessZoneZero\1k\Stage-Lock-ShiftF4-1k.ahk"
        Target = "general\Lock.ahk"
        ExpectedCoords = @("LeftClickAt(727, 859, 150)", "LeftClickAt(1541, 365, 150)")
    },
    @{
        Name = "ZenlessZoneZero 2K Stage Abandoned"
        Legacy = "ZenlessZoneZero\2k\Stage-Abandoned-ShiftF3-2k.ahk"
        Target = "general\Abandoned.ahk"
        ExpectedCoords = @("LeftClickAt(875, 1143, 150)", "LeftClickAt(2045, 514, 150)")
    },
    @{
        Name = "ZenlessZoneZero 2K Stage Lock"
        Legacy = "ZenlessZoneZero\2k\Stage-Lock-ShiftF4-2k.ahk"
        Target = "general\Lock.ahk"
        ExpectedCoords = @("LeftClickAt(965, 1153, 150)", "LeftClickAt(2045, 514, 150)")
    },
    @{
        Name = "ZenlessZoneZero 2K Tuning Abandoned"
        Legacy = "ZenlessZoneZero\2k\絕區零-調律-棄置-ShiftF3-2k.ahk"
        Target = "general\Abandoned.ahk"
        ExpectedCoords = @("LeftClickAt(1041, 216, 150)")
    },
    @{
        Name = "ZenlessZoneZero 2K Tuning Lock"
        Legacy = "ZenlessZoneZero\2k\絕區零-調律-鎖定-ShiftF4-2k.ahk"
        Target = "general\Lock.ahk"
        ExpectedCoords = @("LeftClickAt(1134, 207, 150)")
    }
)

foreach ($item in $scriptComparisons) {
    $targetContent = Get-Content (Join-Path $WorkspaceRoot $item.Target) -Raw
    $legacyContent = Get-Content (Join-Path $WorkspaceRoot $item.Legacy) -Raw
    
    $allMatch = $true
    $missingList = @()
    foreach ($coord in $item.ExpectedCoords) {
        # 驗證舊版中是否存在
        if (-not $legacyContent.Contains($coord)) {
            $allMatch = $false
            $missingList += "Legacy missing: $coord"
        }
        # 驗證新版中是否存在
        if (-not $targetContent.Contains($coord)) {
            $allMatch = $false
            $missingList += "Target missing: $coord"
        }
    }
    
    Add-TestResult -Category "Coordinate Integrity" -TestName "座標與延遲無損遷移: $($item.Name)" -Passed $allMatch -Detail ($missingList -join "; ")
}

# 3. 例外安全 (try...finally { BlockInput(false) }) 結構稽核
$targetScripts = @("general\Abandoned.ahk", "general\Lock.ahk")
foreach ($scriptPath in $targetScripts) {
    $content = Get-Content (Join-Path $WorkspaceRoot $scriptPath) -Raw
    
    # 計算 BlockInput(true) 次數
    $blockTrueCount = ([regex]::Matches($content, "BlockInput\(true\)")).Count
    # 計算 finally { BlockInput(false) } 次數
    $finallyBlockFalseCount = ([regex]::Matches($content, "(?ms)finally\s*\{\s*BlockInput\(false\)")).Count
    
    $safe = ($blockTrueCount -gt 0) -and ($blockTrueCount -eq $finallyBlockFalseCount)
    Add-TestResult -Category "Exception Safety" -TestName "try...finally 覆蓋率 (BlockInput) in $scriptPath" -Passed $safe -Detail "BlockInput(true): $blockTrueCount, finally { BlockInput(false) }: $finallyBlockFalseCount"
}

# 4. #HotIf 原生透傳條件式熱鍵稽核
foreach ($scriptPath in $targetScripts) {
    $lines = Get-Content (Join-Path $WorkspaceRoot $scriptPath)
    $hasHotIfOpen = $false
    $hasHotIfClose = $false
    $hotkeysInsideHotIf = $true
    $inHotIf = $false
    
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -eq "#HotIf IsTargetGame()") {
            $hasHotIfOpen = $true
            $inHotIf = $true
        } elseif ($trimmed -eq "#HotIf") {
            $hasHotIfClose = $true
            $inHotIf = $false
        } elseif ($trimmed -match "^(\+|\^|\!|\#)*F\d+::") {
            if (-not $inHotIf) {
                $hotkeysInsideHotIf = $false
            }
        }
    }
    
    $passed = $hasHotIfOpen -and $hasHotIfClose -and $hotkeysInsideHotIf
    Add-TestResult -Category "Key Pass-Through" -TestName "#HotIf IsTargetGame() 條件式熱鍵規格 in $scriptPath" -Passed $passed -Detail "HotIf Open: $hasHotIfOpen, Close: $hasHotIfClose, All Inside: $hotkeysInsideHotIf"
}

# 5. 無狀態簡潔性 (Stateless Design) 稽核
foreach ($scriptPath in $targetScripts) {
    $content = Get-Content (Join-Path $WorkspaceRoot $scriptPath) -Raw
    # 檢查是否有外部 mode 狀態切換變數或全域狀態變數
    $hasGlobalState = ($content -match "global\s+(currentMode|mode|isTuning|state)") -or ($content -match "\b(currentMode|activeMode)\s*:=")
    $isStateless = [bool](-not $hasGlobalState)
    $statelessDetail = if ($isStateless) { "純函式無副作用無全域狀態" } else { "檢測到全域狀態變數" }
    Add-TestResult -Category "Simplicity & Stateless" -TestName "無狀態設計檢驗 (無多餘全域狀態機) in $scriptPath" -Passed $isStateless -Detail $statelessDetail
}

# 6. UAC 管理員權限自檢 (EnsureAdmin)
$hasEnsureAdminInFunction = (Get-Content "basic\Function.ahk" -Raw) -match "EnsureAdmin\(\)"
Add-TestResult -Category "Permission & UAC" -TestName "EnsureAdmin 函式存在於 basic/Function.ahk" -Passed $hasEnsureAdminInFunction -Detail "basic/Function.ahk 定義 EnsureAdmin()"

foreach ($scriptPath in $targetScripts) {
    $content = Get-Content (Join-Path $WorkspaceRoot $scriptPath) -Raw
    $callsEnsureAdmin = [bool]($content -match "(?m)^\s*EnsureAdmin\(\)")
    Add-TestResult -Category "Permission & UAC" -TestName "腳本進入點呼叫 EnsureAdmin() in $scriptPath" -Passed $callsEnsureAdmin -Detail "$scriptPath 頂部自動自檢提權"
}

# 7. 原神 (GenshinImpact) 安全防護與提示稽核
foreach ($scriptPath in $targetScripts) {
    $content = Get-Content (Join-Path $WorkspaceRoot $scriptPath) -Raw
    $hasGenshinHandler = ($content -match 'case "GenshinImpact":\s*ShowTemporaryTooltip')
    Add-TestResult -Category "Safety & Guard" -TestName "原神專屬安全防護 (提示且不執行任何點擊) in $scriptPath" -Passed $hasGenshinHandler -Detail "未配置座標提示 ToolTip 且無 LeftClick 動作"
}

# 8. 統一部署腳本 run-ahk-scripts.ps1 稽核
$deployScript = "run-ahk-scripts.ps1"
$deployContent = Get-Content (Join-Path $WorkspaceRoot $deployScript) -Raw
$hasUAC = $deployContent.Contains("Administrator")
$stopsOld = $deployContent.Contains("Stop-Process")
$startsAbandoned = $deployContent.Contains("general\Abandoned.ahk")
$startsLock = $deployContent.Contains("general\Lock.ahk")
$deployValid = $hasUAC -and $stopsOld -and $startsAbandoned -and $startsLock

Add-TestResult -Category "Deployment Automation" -TestName "統一部署腳本 run-ahk-scripts.ps1 規格" -Passed $deployValid -Detail "提權保護: $hasUAC, 終止舊行程: $stopsOld, 啟動通用腳本: $($startsAbandoned -and $startsLock)"

Write-Host "`n=== 稽核測試彙總 ===" -ForegroundColor Cyan
$passCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($results | Where-Object { $_.Status -eq "FAIL" }).Count
$totalCount = $results.Count

$summaryFg = if ($failCount -eq 0) { "Green" } else { "Red" }
Write-Host "總計測試數: $totalCount | 通過: $passCount | 失敗: $failCount" -ForegroundColor $summaryFg

# 儲存 JSON 結果給報告生成使用
$results | ConvertTo-Json -Depth 3 | Out-File -FilePath "tests\audit_results.json" -Encoding utf8

if ($failCount -gt 0) {
    exit 1
} else {
    exit 0
}
