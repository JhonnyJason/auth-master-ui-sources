############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("deleteconfirmation")
#endregion

############################################################
import M from "mustache"

############################################################
import { ModalCore } from "./modalcore.js"
import { getServer }  from "./servermodule.js"

############################################################
#region Internal Variables
core = null

############################################################
deleteconfirmationContentMessageTemplate = document.getElementById("deleteconfirmation-content-message-template")

messageTemplate = deleteconfirmationContentMessageTemplate.innerHTML
messageElement = null

############################################################
promiseConsumed = false

#endregion

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(deleteconfirmation)
    core.connectDefaultElements()

    messageElement = deleteconfirmation.getElementsByClassName("modal-content")[0]
    return

############################################################
export userConfirmation = ->
    log "userConfirmation"
    core.activate() unless core.modalPromise?
    promiseConsumed = true
    return core.modalPromise

############################################################
#region UI State Manipulation

export turnUpModal = (ctx) ->
    log "turnUpModal"
    return if core.modalPromise? # already up

    if !ctx.index? then throw new Error("Deleteconfirmation called without index of server to delete!")

    server = getServer(ctx.index)
    
    if typeof server.name == "string" and server.name.length > 0
        serverName = "(#{server.name})"
    else serverName = ""

    messageElement.innerHTML = M.render(messageTemplate, {serverName})
    promiseConsumed = false
    
    core.activate()
    return

export turnDownModal = (reason) ->
    log "turnDownModal"
    if core.modalPromise? and !promiseConsumed 
        core.modalPromise.catch(()->return)
        # core.modalPromise.catch((err) -> log("unconsumed: #{err}"))

    core.reject(reason)
    promiseConsumed = false
    return

#endregion