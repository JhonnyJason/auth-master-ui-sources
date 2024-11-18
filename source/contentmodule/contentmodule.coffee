############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
export setToNoMasterkeyState = ->
    log "setToNoMasterkeyState"
    content.className = "set-master-key"
    return

############################################################
export setToDisplayServerState = -> 
    log "setToDisplayServerState"
    content.className = "display-servers"
    return

############################################################
export setToEditServerState = ->
    log "setToEditServerState"
    content.className = "edit-server"
    return
