############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
#region imported UI modules
import * as content from "./contentmodule.js"
import * as servers from "./servermodule.js"
import * as masterKey from "./masterkeymodule.js"
import * as clientManager from "./clientmanagermodule.js"

## User Modals
import * as deleteConfirmation from "./deleteconfirmation.js"

#endregion

############################################################
applyBaseState = {}
applyModifier = {}

############################################################
currentBase = null
currentModifier = null
currentContext = null

############################################################
#region Base State Application Functions

applyBaseState["no-masterkey"] = (ctx) ->
    content.setToNoMasterkeyState(ctx)
    masterKey.focusFloatingSecretInput()
    return

applyBaseState["display-servers"] = (ctx) ->
    content.setToDisplayServerState(ctx)
    servers.display(ctx)
    return

applyBaseState["edit-server"] = (ctx) ->
    content.setToEditServerState(ctx)
    servers.setEditData(ctx)
    return

applyBaseState["manage-clients"] = (ctx) ->
    content.setToManageClientsState(ctx)
    clientManager.setServer(ctx)
    return



#endregion

############################################################
resetAllModifications = ->
    deleteConfirmation.turnDownModal("uiState changed")
    return

############################################################
#region Modifier State Application Functions

applyModifier["none"] = (ctx) ->
    resetAllModifications()
    return

applyModifier["delete-confirmation"] = (ctx) ->
    resetAllModifications()
    deleteConfirmation.turnUpModal(ctx)
    return


#endregion


############################################################
#region exported general Application Functions
export applyUIState = (base, modifier, ctx) ->
    log "applyUIState"
    currentContext = ctx

    if base? then applyUIStateBase(base)
    if modifier? then applyUIStateModifier(modifier)
    return

############################################################
export applyUIStateBase = (base) ->
    log "applyUIBaseState #{base}"
    applyBaseFunction = applyBaseState[base]

    if typeof applyBaseFunction != "function" then throw new Error("on applyUIStateBase: base '#{base}' apply function did not exist!")

    currentBase = base
    applyBaseFunction(currentContext)
    return

############################################################
export applyUIStateModifier = (modifier) ->
    log "applyUIStateModifier #{modifier}"
    applyModifierFunction = applyModifier[modifier]

    if typeof applyUIStateModifier != "function" then throw new Error("on applyUIStateModifier: modifier '#{modifier}' apply function did not exist!")

    currentModifier = modifier
    applyModifierFunction(currentContext)
    return

############################################################
export getModifier = -> currentModifier
export getBase = -> currentBase
export getContext = -> currentContext

#endregion