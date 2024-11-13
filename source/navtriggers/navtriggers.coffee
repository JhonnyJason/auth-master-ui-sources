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
export home = ->
    return nav.toRoot(true)
    
############################################################
export menu = (menuOn) ->
    if menuOn then return nav.toMod("menu")
    else return nav.toMod("none")
 
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
    

