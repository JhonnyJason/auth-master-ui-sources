############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as nav from "navhandler"
import * as S from "./statemodule.js"

import * as uiState from "./uistatemodule.js"
import * as triggers from "./navtriggers.js"
import * as servers from "./servermodule.js"

import { appVersion } from "./configmodule.js"

############################################################
serviceWorker = null
if navigator? and navigator.serviceWorker?
    serviceWorker = navigator.serviceWorker

############################################################
currentVersion = document.getElementById("current-version")
newVersion = document.getElementById("new-version")
menuVersion = document.getElementById("menu-version")

############################################################
appBaseState = "no-servers"
appUIMod = "none"


############################################################
export initialize = ->
    log "initialize"
    nav.initialize(loadWithNavState, updateNavState, false)

    if currentVersion? then currentVersion.textContent = appVersion

    if serviceWorker?
        serviceWorker.register("serviceworker.js", {scope: "/"})
        if serviceWorker.controller?
            serviceWorker.controller.postMessage("App is version: #{appVersion}!")
        serviceWorker.addEventListener("message", onServiceWorkerMessage)
        serviceWorker.addEventListener("controllerchange", onServiceWorkerSwitch)

    S.addOnChangeListener("allServers", updateBaseState)
    return

############################################################
updateBaseState = ->
    log "updateBaseState"
    allServers = S.get("allServers")
    if allServers? and isArray(allServers) and allServers.length > 0
        appBaseState = "display-servers"
    else appBaseState = "no-servers"
    return

############################################################
loadWithNavState = (navState) ->
    log "loadWithNavState"
    baseState = navState.base
    modifier = navState.modifier
    context = navState.context
    S.save("navState", navState)

    setUIState()
    return

############################################################
updateNavState = (navState) ->
    log "navStateUpdate"
    return


############################################################
#region internal Functions
setUIState = (base, mod, ctx) ->
    log "setUIState"

    switch base
        when "RootState"
            if accountAvailable then base = "user-images"
            else base = "no-code"
        when "screenings-list" 
            if appBaseState != "screenings-list" 
                screeningsList.updateScreenings()

    ########################################
    setAppState(base, mod)

    switch mod
        when "logoutconfirmation" then confirmLogoutProcess()
        when "invalidcode" then invalidCodeProcess()
        when "codeverification"
            if urlCode? then await urlCodeDetectedProcess()
            else nav.toMod("none")
    

    ########################################
    # setAppState(base, mod)
    return

############################################################
#region Event Listeners

loadAppWithNavState = (navState) ->
    log "loadAppWithNavState"
    await startUp()

    setUIState(baseState, modifier, context)
    return

############################################################
setNavState = (navState) ->
    log "setNavState"
    baseState = navState.base
    modifier = navState.modifier
    context = navState.context
    S.save("navState", navState)

    # reset always
    accountToUpdate = null
    
    setUIState(baseState, modifier, context)
    return

#endregion

############################################################
startUp = ->
    log "startUp"    
    await checkAccountAvailability()
    if accountAvailable then await prepareAccount()

    updateUIData()
    return

############################################################
checkAccountAvailability = ->
    log "checkAccountAvailability"
    try 
        await account.getUserCredentials()
        accountAvailable = true
        return # return fast if we have an account
    catch err then log err
    # log "No Account Available"
    
    # no account available
    accountAvailable = false
    return

############################################################
updateUIData = ->
    log "updateUIData"
    # update data in the UIs
    menuModule.updateAllUsers()
    codeDisplay.updateCode()
    usernameDisplay.updateUsername()
    return

############################################################
setAppState = (base, mod) ->
    log "setAppState"
    if base then appBaseState = base
    if mod then appUIMod = mod
    log "#{appBaseState}:#{appUIMod}"

    uiState.applyUIState(appBaseState, appUIMod)
    return
    
############################################################
onServiceWorkerMessage = (evnt) ->
    log("  !  onServiceWorkerMessage")
    if typeof evnt.data == "object" and evnt.data.version?
        serviceworkerVersion = evnt.data.version
        # olog { appVersion, serviceworkerVersion }
        if serviceworkerVersion == appVersion then return
        newVersion.textContent = serviceworkerVersion
        menuVersion.classList.add("to-update")
    return

onServiceWorkerSwitch = ->
    # console.log("  !  onServiceWorkerSwitch")
    serviceWorker.controller.postMessage("Hello I am version: #{appVersion}!")
    serviceWorker.controller.postMessage("tellMeVersion")
    return
    
#endregion

############################################################
#region User Interaction Processes

urlCodeDetectedProcess = ->
    log "urlCodeDetectedProcess"
    log "urlCode is: #{urlCode}"
    try
        credentials = await verificationModal.pickUpConfirmedCredentials(urlCode)
        await account.addValidAccount(credentials)
    catch err then log err
    finally nav.toRoot(true)
    return

#endregion