############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usermodalmodule")
#endregion

############################################################
import * as deleteConfirmation from "./deleteconfirmation.js"

############################################################
export initialize = ->
    log "initialize"
    deleteConfirmation.initialize()
    return






## Old Code

# ############################################################
# userActionPromiseReject = null
# userActionPromiseAccept = null

# ############################################################
# export initialize = ->
#     log "initialize"
#     usermodal.addEventListener("click", rejectUserAction)
#     useractionCloseButton.addEventListener("click", rejectUserAction)
#     useractionFrame.addEventListener("click", absorbCLick)
#     useractionAcceptButton.addEventListener("click", acceptUserAction)
#     useractionRejectButton.addEventListener("click", rejectUserAction)
#     return

# ############################################################
# #region event Listeners
# rejectUserAction = (evnt) ->
#     log "rejectUserAction"
#     evnt.stopPropagation()
#     reject = userActionPromiseReject
#     userActionPromiseReject = null
#     userActionPromiseAccept = null
#     usermodal.classList.remove("shown")
#     if reject? then reject("cancel")
#     return 

# acceptUserAction = (evnt) ->
#     log "acceptUserAction"
#     evnt.stopPropagation()
#     resolve = userActionPromiseAccept
#     userActionPromiseAccept = null
#     userActionPromiseReject = null
#     usermodal.classList.remove("shown")
#     if resolve? then resolve()
#     return

# absorbCLick = (evnt) ->
#     log "absorbCLick"
#     evnt.stopPropagation()
#     return


# #endregion

# ############################################################
# export userDeleteConfirm = ->
#     log "userDeleteConfirm"
#     ## TODO get hidden html pieces to set up modal
#     userActionPromise = new Promise (resolve, reject) ->
#         userActionPromiseAccept = resolve
#         userActionPromiseReject = reject
    
#     usermodal.classList.add("shown")
#     return userActionPromise