############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servermodule")
#endregion

############################################################
import M from "mustache"
import { NOT_AUTHORIZED } from "thingy-post-rpc-client"

############################################################
import * as S from "./statemodule.js"
import * as utl from "./utilsmodule.js"
import * as msgBox from "./messageboxmodule.js"
import * as master from "./masterkeymodule.js"
import * as triggers from "./navtriggers.js"

############################################################
serverEntryTemplateElement = document.getElementById("server-entry-template-element")
entryTemplate = serverEntryTemplateElement.outerHTML
# noServerPlaceholder = noServerIndication
noServerPlaceholder = document.getElementById("no-server-indication")

############################################################
storageId = ""
servers = []
editingServerIndex = null

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
#region Event Listeners

############################################################
#region Edit Interface
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
        tempClient = master.getAuthMasterClient(addServerURL)
        serverId = await tempClient.getServerId()
        serverAvailable = true
    catch err 
        if err.rpcCode == NOT_AUTHORIZED
            setErrorMessage("You are no Master of this Server!")
        else setErrorMessage(err.message)
        # #     "You are no Master of this Server!")
        # log err
        # else msgBox.error(err.message)
        # # log err.stack
        # # log typeof err

    if tempClient? and tempClient.serverId? 
        statedServerIdDisplay.textContent = tempClient.serverId

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

#endregion

############################################################
#region Server Entry
editButtonClicked = (evnt) ->
    log "editButtonClicked"
    #entry->entry-top->server-buttons->edit.button
    entry = this.parentNode.parentNode.parentElement
    index = entry.getAttribute("server-index")
    log index
    triggers.editServer({index})
    return

deleteButtonClicked = (evnt) ->
    log "deleteButtonClicked"
    #entry->entry-top->server-buttons->delete.button
    entry = this.parentNode.parentNode.parentElement
    index = entry.getAttribute("server-index")
    log index
    triggers.deleteServer({index})
    return

manageButtonClicked = (evnt) ->
    log "manageButtonClicked"
    #entry->entry-bottom->edit.button
    entry = this.parentNode.parentElement
    index = entry.getAttribute("server-index")
    log index
    triggers.manageServer({index})
    return

#endregion



############################################################
acceptEditButtonClicked = ->
    log "acceptEditButtonClicked"

    if editingServerIndex?
        server = servers[editingServerIndex]
        server.name = addServerName
        server.url = addServerURL
        server.id = addServerId

        editingServerIndex = null
    else
        server = {
            name: addServerName,
            url: addServerURL
            id: addServerId
        }
        servers.push(server)

    await saveServers()
    reset()
    # triggers.back()
    triggers.mainView()
    return

cancelEditButtonClicked = ->
    log "cancelEditButtonClicked"
    reset()
    # triggers.back()
    triggers.mainView()
    return

addServerButtonClicked = ->
    log "addServerButtonClicked"
    triggers.editServer({})
    return

#endregion

############################################################
saveServers = ->
    log "saveServers"
    encrypted = await master.encrypt(JSON.stringify(servers))
    S.save(storageId, encrypted, true)
    return

checkAcceptable = ->
    log "checkAcceptable"
    if serverURLBaseClass != "" then acceptEditButton.classList.remove("passive")
    else acceptEditButton.classList.add("passive")
    return

############################################################
loadForStorageId = (rawStorageId) ->
    log "loadForStorageId"
    storageId = "#{rawStorageId}_servers"
    log storageId
    encrypted = S.load(storageId)

    olog {
        encrypted
    }

    if encrypted? and encrypted.referencePointHex?
        servers = JSON.parse(await master.decrypt(encrypted))
        olog {
            servers
        }
        return

    if !Array.isArray(servers) then servers = []
    return


############################################################
setErrorMessage = (message) ->
    errorMessage.textContent = message
    errorMessage.parentNode.classList.add("error")
    return

############################################################
reset = ->
    log "reset"
    addServerName = ""
    serverNameInput.value = ""
    serverNameBaseClass = ""
    serverNameInput.className = ""

    addServerURL = ""
    serverUrlInput.value = ""
    serverURLBaseClass = ""
    serverUrlInput.className = ""

    statedServerIdDisplay.textContent = ""  
    
    addServerId = ""
    serverIdInput.value = ""
    serverIdBaseClass = ""
    serverIdInput.className = ""

    errorMessage.parentNode.className = ""
    errorMessage.textContent = ""

    acceptEditButton.classList.add("passive")
    return

############################################################
attachEventListeners = ->
    log "attachEventListeners"
    editButtons = serverList.getElementsByClassName("edit-button")
    deleteButtons = serverList.getElementsByClassName("delete-button")
    manageButtons = serverList.getElementsByClassName("manage-button")

    btn.addEventListener("click", editButtonClicked) for btn in editButtons
    btn.addEventListener("click", deleteButtonClicked) for btn in deleteButtons
    btn.addEventListener("click", manageButtonClicked) for btn in manageButtons

    return

############################################################
export display = ->
    log "display"
    await loadForStorageId(master.getStorageId())
    serverListHTML = ""
    utl.clearElement(serverList)
    
    for server,index in servers
        log index
        olog server
        cObj = { index, server}
        serverListHTML += M.render(entryTemplate, cObj) 

    if serverListHTML.length > 0 
        serverList.className = ""
        serverList.innerHTML = serverListHTML
    else 
        serverList.className = "empty"
        serverList.appendChild(noServerPlaceholder)

    attachEventListeners()
    return 

export setEditData = (ctx) ->
    log "setupEditData"
    olog ctx
    reset() #ensure clear state

    if !ctx.index? then return # case we add a new server
    
    editingServerIndex = ctx.index
    server = servers[editingServerIndex]

    serverNameInput.value = server.name
    serverNameChanged()

    serverUrlInput.value = server.url
    serverUrlChanged()

    serverIdInput.value = server.id
    serverIdChanged()

    return


############################################################
export getServer = (index) -> servers[index]

export deleteServer = (index) ->
    servers.splice(index, 1)
    await saveServers()
    return