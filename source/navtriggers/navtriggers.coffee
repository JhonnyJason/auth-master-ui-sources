############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("navtriggers")
#endregion

############################################################
import * as nav from "navhandler"

############################################################
import * as S from "./statemodule.js"

############################################################
## Navigation Action Triggers

############################################################
export mainView = ->
    return nav.toBaseAt("display-servers", null, 1)

############################################################
export editServer = (ctx) ->
    return nav.toBaseAt("edit-server", ctx, 2)

export deleteServer = (ctx) ->
    return nav.toMod("delete-confirmation", ctx)

export manageServer = (ctx) ->
    return nav.toBaseAt("manage-server", ctx, 2)


############################################################
export reset = ->
    return nav.toRoot(true)

############################################################
export back = ->
    return nav.back(1)
    
# ############################################################
# export menu = (menuOn) ->
#     if menuOn then return nav.toMod("menu")
#     else return nav.toMod("none")
 
# ############################################################
# export requestCode = ->
#     return await nav.toBase("request-code")

# ############################################################
# export addCode = ->
#     return await nav.toBaseAt("add-code", null, 1)

# ############################################################
# export invalidCode = ->
#     return nav.toMod("invalidcode")

# export showQR = ->
#     return nav.toBase("show-qr")
    

