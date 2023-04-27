############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("masterkeymodule")
#endregion

############################################################
import { ThingyCryptoNode } from "thingy-crypto-node"
import * as secUtl from "secret-manager-crypto-utils"

############################################################
import * as utl from "./utilsmodule.js"
import * as alias from "./aliasmodule.js"
import * as msgBox from "./messageboxmodule.js"

############################################################
cryptoNode = null
context = "Auth Master UI" 


############################################################
masterKey = ""
masterKeyId = ""
masterKeyAlias = ""
storageId = ""

typingFloatingSecret = false
typingAlias = false

############################################################
export initialize = ->
    log "initialize"
    floatingSecretInput.addEventListener("change", floatingSecretChanged)
    floatingSecretInput.addEventListener("keydown", floatingSecretKeyDowned)
    aliasInput.addEventListener("change", aliasChanged)
    aliasInput.addEventListener("keydown", aliasKeyDowned)

    return

############################################################
floatingSecretKeyDowned = ->
    log "floatingSecretKeyDowned"
    return if typingFloatingSecret
    typingFloatingSecret = true
    floatingSecretInput.className = "typing"
    return

aliasKeyDowned = ->
    log "aliasKeyDowned"
    return if typingAlias
    typingAlias = true
    aliasInput.className = "typing"
    return

floatingSecretChanged = ->
    log "floatingSecretChanged"
    typingFloatingSecret = false
    floatingSecretInput.className = "okay"

    masterKey = await utl.seedToKey(floatingSecretInput.value)
    masterKeyId = await secUtl.createPublicKey(masterKey)
    storageId = await secUtl.sha256Hex("#{context}_#{masterKeyId}")
    options = {
        secretKeyHex: masterKey
        publicKeyHex: masterKeyId
        context: context
    }
    cryptoNode = new ThingyCryptoNode(options)

    await alias.loadForStorageId(storageId)
    masterKeyAlias = alias.getAliasForId(masterKeyId)
    
    activateAndFillBottomGroup()
    return

aliasChanged = ->
    log "aliasChanged"
    masterKeyAlias = aliasInput.value
    try 
        alias.setAliasForId(masterKeyAlias, masterKeyId)
        typingAlias = false
        aliasInput.className = "okay"
    catch err
        log err
        msgBox.error(err.message)
        typingAlias = false
        aliasInput.className = "error"

    return

activateAndFillBottomGroup = ->
    log "activateAndFillBottomGroup"
    passiveGroup = document.getElementsByClassName("passive")[0]
    if passiveGroup? then passiveGroup.classList.remove("passive")

    keyIdDisplay.innerHTML = "0x#{masterKeyId}"
    if masterKeyAlias then aliasInput.value = masterKeyAlias
    else aliasInput.setAttribute("placeholder", "Define Alias")
    return

############################################################
export encrypt = (content) -> cryptoNode.encrypt(content)

export decrypt = (encrypted) -> cryptoNode.decrypt(encrypted)
