indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.serverEntryTemplateElement = document.getElementById("server-entry-template-element")
    global.serverList = document.getElementById("server-list")
    global.addserverbutton = document.getElementById("addserverbutton")
    global.masterkeydisplay = document.getElementById("masterkeydisplay")
    global.masterkeyAlias = document.getElementById("masterkey-alias")
    global.masterkeyId = document.getElementById("masterkey-id")
    global.masterkeyStorageId = document.getElementById("masterkey-storage-id")
    global.serverNameInput = document.getElementById("server-name-input")
    global.serverUrlInput = document.getElementById("server-url-input")
    global.statedServerIdDisplay = document.getElementById("stated-server-id-display")
    global.serverIdInput = document.getElementById("server-id-input")
    global.errorMessage = document.getElementById("error-message")
    global.cancelEditButton = document.getElementById("cancel-edit-button")
    global.acceptEditButton = document.getElementById("accept-edit-button")
    global.clientIdInput = document.getElementById("client-id-input")
    global.addClientButton = document.getElementById("add-client-button")
    global.removeClientButton = document.getElementById("remove-client-button")
    global.getClientsButton = document.getElementById("get-clients-button")
    global.clientsToServeList = document.getElementById("clients-to-serve-list")
    global.floatingSecretInput = document.getElementById("floating-secret-input")
    global.keyIdDisplay = document.getElementById("key-id-display")
    global.storageIdDisplay = document.getElementById("storage-id-display")
    global.aliasInput = document.getElementById("alias-input")
    global.acceptUseButton = document.getElementById("accept-use-button")
    global.deleteconfirmation = document.getElementById("deleteconfirmation")
    global.qrreaderBackground = document.getElementById("qrreader-background")
    global.qrreaderVideoElement = document.getElementById("qrreader-video-element")
    global.messagebox = document.getElementById("messagebox")
    global.qrdisplayBackground = document.getElementById("qrdisplay-background")
    global.qrdisplayContent = document.getElementById("qrdisplay-content")
    global.qrdisplayQr = document.getElementById("qrdisplay-qr")
    return
    
module.exports = indexdomconnect