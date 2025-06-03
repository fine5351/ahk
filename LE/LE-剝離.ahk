#IfWinActive ahk_exe Last Epoch.exe 
WheelUp::
BlockInput, On 
MouseGetPos, StartX, StartY

Send, +{RButton}
Sleep, 50
MouseMove, 595,896
Sleep, 50
Send {LButton}
Sleep, 50
MouseMove, 287,990
Sleep, 50
Send {LButton}
MouseMove, 516,1176
Sleep, 50
Send {LButton}

MouseMove %StartX%, %StartY%
BlockInput, Off 
Return