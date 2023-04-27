indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.content = document.getElementById("content")
    global.masterkeydisplay = document.getElementById("masterkeydisplay")
    global.masterkeyAlias = document.getElementById("masterkey-alias")
    global.masterkeyId = document.getElementById("masterkey-id")
    global.masterkeyStorageId = document.getElementById("masterkey-storage-id")
    global.clientIdInput = document.getElementById("client-id-input")
    global.addClientButton = document.getElementById("add-client-button")
    global.removeClientButton = document.getElementById("remove-client-button")
    global.getClientsButton = document.getElementById("get-clients-button")
    global.clientsToServeList = document.getElementById("clients-to-serve-list")
    global.floatingSecretInput = document.getElementById("floating-secret-input")
    global.keyIdDisplay = document.getElementById("key-id-display")
    global.storageIdDisplay = document.getElementById("storage-id-display")
    global.aliasInput = document.getElementById("alias-input")
    global.acceptButton = document.getElementById("accept-button")
    global.usermodal = document.getElementById("usermodal")
    global.useractionFrame = document.getElementById("useraction-frame")
    global.useractionCloseButton = document.getElementById("useraction-close-button")
    global.useractionRejectButton = document.getElementById("useraction-reject-button")
    global.useractionAcceptButton = document.getElementById("useraction-accept-button")
    global.qrreaderBackground = document.getElementById("qrreader-background")
    global.qrreaderVideoElement = document.getElementById("qrreader-video-element")
    global.messagebox = document.getElementById("messagebox")
    global.qrdisplayBackground = document.getElementById("qrdisplay-background")
    global.qrdisplayContent = document.getElementById("qrdisplay-content")
    global.qrdisplayQr = document.getElementById("qrdisplay-qr")
    return
    
module.exports = indexdomconnect