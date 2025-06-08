# Set encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# List and rename all .ahk files
Get-ChildItem -Path . -Filter *.ahk -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $newName = $_.Name
    
    # Check hotkey in file content
    if ($content -match "F8::") {
        $newName = $_.Name -replace "\.ahk$", "-F8.ahk"
    }
    elseif ($content -match "\^F8::") {
        $newName = $_.Name -replace "\.ahk$", "-CtrlF8.ahk"
    }
    elseif ($content -match "F7::") {
        $newName = $_.Name -replace "\.ahk$", "-F7.ahk"
    }
    elseif ($content -match "\^F9::") {
        $newName = $_.Name -replace "\.ahk$", "-CtrlF9.ahk"
    }
    elseif ($content -match "\^9::") {
        $newName = $_.Name -replace "\.ahk$", "-Ctrl9.ahk"
    }
    elseif ($content -match "F9::") {
        $newName = $_.Name -replace "\.ahk$", "-F9.ahk"
    }
    elseif ($content -match "F10::") {
        $newName = $_.Name -replace "\.ahk$", "-F10.ahk"
    }
    elseif ($content -match "WheelUp::") {
        $newName = $_.Name -replace "\.ahk$", "-WheelUp.ahk"
    }
    elseif ($content -match "!f::") {
        $newName = $_.Name -replace "\.ahk$", "-AltF.ahk"
    }
    elseif ($content -match "!l::") {
        $newName = $_.Name -replace "\.ahk$", "-AltL.ahk"
    }
    elseif ($content -match "!j::") {
        $newName = $_.Name -replace "\.ahk$", "-AltJ.ahk"
    }
    
    if ($newName -ne $_.Name) {
        Write-Host "Renaming $($_.Name) to $newName"
        Rename-Item -Path $_.FullName -NewName $newName
    }
}