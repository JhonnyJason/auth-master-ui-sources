############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servermodule")
#endregion

############################################################
import * as secUtl from "secret-manager-crypto-utils"
import * as S from "./statemodule.js"
import * as crypto from "./masterkeymodule.js"

############################################################
storageId = ""
servers = {}

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

############################################################
saveServers = ->
    log "saveServers"
    encrypted = await crypto.encrypt(JSON.stringify(servers))
    S.save(storageId, encrypted, true)
    return

############################################################
export loadForStorageId = (rawStorageId) ->
    log "loadForStorageId"
    storageId = "#{rawStorageId}_servers"
    log storageId
    encrypted = S.load(storageId)

    olog {
        encrypted
    }

    if encrypted? and encrypted.referencePointHex?
        servers = JSON.parse(await crypto.decrypt(encrypted))
        olog {
            servers
        }
        return

    servers = {}
    return

