#Requires AutoHotkey v2.0
#Include ../basic//Function.ahk

global toggle := false
global attackStep := 0

!1::
{
    if (!IsTargetGame()) {
        return
    }

    global toggle := !toggle
    global attackStep
    if (toggle) {
        attackStep := 0
        SetTimer DoAttackLoop, 300
        DoAttackLoop()
    } else {
        SetTimer DoAttackLoop, 0
    }
}

DoAttackLoop() {
    global attackStep
    if (attackStep == 0) {
        Send("E")
    } else if (attackStep == 1) {
        Send("{LButton}")
    } else if (attackStep == 2) {
        Send("Q")
    } else if (attackStep == 3) {
        Send("Q")
    }
    attackStep := Mod(attackStep + 1, 4)
}

return