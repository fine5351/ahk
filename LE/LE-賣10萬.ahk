#IfWinActive ahk_exe Last Epoch.exe 
WheelUp::
BlockInput, On 
MouseGetPos, StartX, StartY

;點擊上架物品
MouseMove, 2331,646
Send {LButton}
Sleep, 50
;取得物品
MouseMove %StartX%, %StartY%
Sleep, 50
Send {LButton}
Sleep, 50
;移動到上架物品框
MouseMove, 1257,587
Sleep, 50
Send {LButton}
Sleep, 50
;點擊價格欄
MouseMove, 1278,869
Sleep, 50
Send {LButton}
Sleep, 50
;點擊價格欄
MouseMove, 1214,861
Sleep, 50
Send {LButton}
Sleep, 50

MouseMove, 1214,861
Sleep, 50
Send {LButton}
Sleep, 50
;輸入價格 100000
Send, 100000
Sleep, 50
;點擊上架
MouseMove, 1254,941
Sleep, 50
Send {LButton}
Sleep, 50
;點擊確認
MouseMove, 1118,801
Sleep, 50
Send {LButton}

MouseMove %StartX%, %StartY%
BlockInput, Off 
Return