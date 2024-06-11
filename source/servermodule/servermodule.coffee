############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servermodule")
#endregion

############################################################
import * as secUtl from "secret-manager-crypto-utils"

import * as S from "./statemodule.js"
import * as crypto from "./masterkeymodule.js"
import * as utl from "./utilsmodule.js"
import * as msgBox from "./messageboxmodule.js"
import * as masterKey from "./masterkeymodule.js"

############################################################
storageId = ""
servers = {}

############################################################
addServerName = ""
serverNameBaseClass = ""
addServerURL = ""
serverURLBaseClass = ""
addServerId = ""
serverIdBaseClass = ""

############################################################
https = "https://"

############################################################
tempClient = null

############################################################
export initialize = ->
    log "initialize"    
    serverNameInput.addEventListener("change", serverNameChanged)
    serverNameInput.addEventListener("keyup", serverNameKeyUpped)

    serverUrlInput.addEventListener("change", serverUrlChanged)
    serverUrlInput.addEventListener("keyup", serverUrlKeyUpped)

    serverIdInput.addEventListener("change", serverIdChanged)
    serverIdInput.addEventListener("keyup", serverIdKeyUpped)

    statedServerIdDisplay.addEventListener("click", statedServerIdDisplayClicked)

    addserverbutton.addEventListener("click", addServerButtonClicked)
    cancelEditButton.addEventListener("click", cancelEditButtonClicked)
    acceptEditButton.addEventListener("click", acceptEditButtonClicked)

    return

############################################################
#region event Listeners

serverNameChanged = ->
    log "serverNameChanged"
    addServerName = serverNameInput.value

    # TODO maybe check if we already have this server name in use

    if addServerName.length > 0
        serverNameBaseClass = "okay"
    else 
        serverNameBaseClass = ""

    serverNameInput.className = serverNameBaseClass
    return

serverNameKeyUpped = ->
    log "serverNameKeyUpped"
    if addServerName == serverNameInput.value
        serverNameInput.className = serverNameBaseClass
    else
        serverNameInput.className = "typing"
    return

serverUrlChanged = ->
    log "serverUrlChanged"
    addServerURL = serverUrlInput.value
    if addServerURL.length == 0
        serverURLBaseClass = ""
        serverUrlInput.className = serverURLBaseClass
        return

    if addServerURL.length <= https.length
        isOnlyHTTPS = true
        for c,i in addServerURL when c != https[i] 
            isOnlyHTTPS = false
        # our serverURL is any incomplete version of https:// -> ignore
        if isOnlyHTTPS
            serverURLBaseClass = ""
            serverUrlInput.className = serverURLBaseClass
            checkAcceptable()
            return

    if addServerURL.indexOf(https) != 0
        addServerURL = "#{https}#{addServerURL}"
        serverUrlInput.value = addServerURL

    serverAvailable = false
    serverId = ""
    try
        tempClient = masterKey.getAuthMasterClient(addServerURL)
        # serverId = await tempClient.getServerId()
        serverId = await tempClient.getServerId()
        serverAvailable = true
    catch err 
        log err
        log typeof err

    if serverAvailable
        statedServerIdDisplay.innerHTML = serverId
        serverURLBaseClass = "okay"
    else
        serverURLBaseClass = "error"

    checkAcceptable()
    serverUrlInput.className = serverURLBaseClass
    return

serverUrlKeyUpped = ->
    log "serverUrlKeyUpped"
    if addServerURL == serverUrlInput.value
        serverUrlInput.className = serverURLBaseClass
    else
        serverUrlInput.className = "typing"
    return

serverIdChanged = ->
    log "serverIdChanged"
    addServerId = serverIdInput.value
    if addServerId.length == 0
        serverIdBaseClass = ""
        serverIdInput.className = serverIdBaseClass
        return

    try
        if addServerId.length < 64 then throw new Error("Invalid Id!")
        if !utl.isValidKey(addServerId) then throw new Error("Invalid Id!")
        serverIdBaseClass = "okay"

        checkAcceptable()
    catch err 
        log err
        msgBox.error(err.message)
        serverIdBaseClass = "error"

    serverIdInput.className = serverIdBaseClass
    return

serverIdKeyUpped = ->
    log "serverIdKeyUpped"
    if addServerId == serverIdInput.value
        serverIdInput.className = serverIdBaseClass
    else
        serverIdInput.className = "typing"
    return

statedServerIdDisplayClicked = ->
    log "statedServerIdDisplayClicked"
    serverId = statedServerIdDisplay.textContent
    if serverId and !serverIdInput.value
        serverIdInput.value = serverId
        serverIdChanged()
    return

acceptEditButtonClicked = ->
    log "acceptEditButtonClicked"
    throw new Error("Not implemented!")
    return

cancelEditButtonClicked = ->
    log "cancelEditButtonClicked"
    content.className = "main-view"    
    return

addServerButtonClicked = ->
    log "addServerButtonClicked"
    content.className = "edit-server"    
    return

#endregion

############################################################
saveServers = ->
    log "saveServers"
    encrypted = await crypto.encrypt(JSON.stringify(servers))
    S.save(storageId, encrypted, true)
    return

checkAcceptable = ->
    log "checkAcceptable"
    

    if serverURLBaseClass != "" then acceptEditButton.classList.remove("passive")
    else acceptEditButton.classList.add("passive")


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
