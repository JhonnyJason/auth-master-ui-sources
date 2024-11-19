############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("clientmanagermodule")
#endregion

############################################################
import M from "mustache"

############################################################
import { info, error } from "./messageboxmodule.js"
import * as serverModule from "./servermodule.js"
import * as masterKey from "./masterkeymodule.js"
import * as utl from "./utilsmodule.js"
import * as aliasModule from "./aliasmodule.js"


############################################################
clientEntryTemplateElement = document.getElementById("client-entry-template-element")
clientEntryTemplate = clientEntryTemplateElement.outerHTML

noClientsMessage = document.getElementById("no-clients-message")
noClientsMessageHTML = noClientsMessage.outerHTML

############################################################
masterClient = null


############################################################
addClientAlias = ""
addClientId = ""

clientAliasBaseClass = ""
clientIdBaseClass = ""

############################################################
currentClients = []

############################################################
export initialize = ->
    log "initialize"
    clientAliasInput.addEventListener("change", clientAliasChanged)
    clientAliasInput.addEventListener("keyup", clientAliasKeyUpped)

    clientIdInput.addEventListener("change", clientIdChanged)
    clientIdInput.addEventListener("keyup", clientIdKeyUpped)

    startAddButton.addEventListener("click", startAddButtonClicked)
    stopAddButton.addEventListener("click", stopAddButtonClicked)
    addClientButton.addEventListener("click", addClientButtonClicked)
    return



############################################################
attachEventListeners = ->
    log "attachEventListeners"
    deleteButtons = clientsToServeList.getElementsByClassName("delete-button")
    btn.addEventListener("click", deleteButtonClicked) for btn in deleteButtons
    return

############################################################
#region Event Listeners

clientAliasChanged = (evnt) ->
    log "clientAliasChanged"
    addClientAlias = clientAliasInput.value

    if addClientAlias.length > 0
        clientAliasBaseClass = "okay"
    else 
        clientAliasBaseClass = ""

    clientAliasInput.className = clientAliasBaseClass

    return

clientAliasKeyUpped = (evnt) ->
    log "clientAliasKeyUpped"
    if addClientAlias == clientAliasInput.value
        clientAliasInput.className = clientAliasBaseClass
    else
        clientAliasInput.className = "typing"
    return


############################################################
clientIdChanged = (evnt) ->
    log "clientIdChanged"
    addClientId = clientIdInput.value
    if addClientId.length == 0
        clientIdBaseClass = ""
        clientIdInput.className = clientIdBaseClass
        return

    try
        if addClientId.length < 64 then throw new Error("Invalid Id!")
        if !utl.isValidKey(addClientId) then throw new Error("Invalid Id!")
        clientIdBaseClass = "okay"

        activateAddButton()
    catch err
        log err
        error(err.message)
        clientIdBaseClass = "error"
        deactivateAddButton()

    clientIdInput.className = clientIdBaseClass
    return

clientIdKeyUpped = (evnt) ->
    log "clientIdKeyUpped"
    if addClientId == clientIdInput.value
        clientIdInput.className = clientIdBaseClass
    else
        clientIdInput.className = "typing"
        deactivateAddButton()
    return

############################################################
startAddButtonClicked = ->
    log "startAddButtonClicked"
    clientmanager.classList.add("add-client")
    clientAliasInput.focus()
    return

stopAddButtonClicked = ->
    log "stopAddButtonClicked"
    clientmanager.classList.remove("add-client")
    return

############################################################
addClientButtonClicked = (evnt) ->
    log "addClientButtonClicked"
    try
        clientId = clientIdInput.value
        alias = clientAliasInput.value
        if alias? then aliasModule.setAliasForId(alias, clientId)

        reply = await masterClient.addClient(clientId)
        olog {reply}
        info("ADD appearently successful!")

        resetAddFrame()
        updateClients()
    catch err 
        m = "Error on trying to add a new client: #{err.message}"
        log(m)
        error(m)
    return

deleteButtonClicked = (evnt) ->
    log "deleteButtonClicked"
    #entry->entry-right->delete-button
    entry = this.parentNode.parentElement
    index = entry.getAttribute("client-index")
    client = currentClients[index]
    olog client

    try
        reply = await masterClient.removeClient(client.id)
        olog {reply}
        info("REMOVE appearently successful!")
        
        resetAddFrame()
        updateClients()
    catch err 
        m = "Error on trying to remove client: #{err.message}"
        error(m)
        log(m)     
    return

#endregion

############################################################
activateAddButton = ->
    log "activateAddButton"
    addClientButton.classList.remove("passive")
    return

deactivateAddButton = ->
    log "deactivateAddButton"
    addClientButton.classList.add("passive")
    return

############################################################
resetAddFrame = ->
    log "resetAddFrame"
    clientAliasInput.value = ""
    clientAliasInput.className = ""
    clientIdInput.value = ""
    clientIdInput.className = ""

    clientmanager.classList.remove("add-client")
    return

updateClients = ->
    log "updateClients"
    try
        clientmanager.classList.remove("error")

        # clientIds = [
        #     "d9e98e2094d244db4bffa3d20bdb33e62fc5bef931dff5a239b622a2d41fee41"
        #     "90caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "91caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "92caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "93caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "94caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "95caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "96caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "97caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "98caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "99caa31a2bfa97611cb504b8e077bf8552bbf362a67630ddc0796ac8a80674ea"
        #     "d0e98e2094d244db4bffa3d20bdb33e62fc5bef931dff5a239b622a2d41fee41"
        # ]

        clientIds = await masterClient.getClients() 
        olog {clientIds}
        info("GETCLIENTS appearently successful!")

        currentClients = []

        html = ""
        for id,index in clientIds
            alias = aliasModule.getAliasForId(id)
            if !alias? then alias = "Unnamed"
            client = {alias, id}
            currentClients.push(client)

            cObj = {index, client}
            html += M.render(clientEntryTemplate, cObj)

        clientsToServeList.innerHTML = html

        if html.lengh == 0 then clientsToServeList.innerHTML = noClientsMessageHTML

        attachEventListeners()
    catch err
        m = "Error on retrieveing clients to serve: #{err.message}"
        log(m)
        error(m)
        clientmanager.classList.add("error")
    return

############################################################
createMasterClientForServer = (server) ->
    log "createMasterClientForServer"
    masterClient = masterKey.getAuthMasterClient(server.url, server.id)
    return

############################################################
export setServer = (ctx) ->
    log "prepare"
    if !ctx.index? then throw new Error("Called prepare on clientmanagermodule without server Index!")

    server = serverModule.getServer(ctx.index)
    
    createMasterClientForServer(server)
    resetAddFrame()
    updateClients()
    return

