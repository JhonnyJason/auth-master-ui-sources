indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.clientIdInput = document.getElementById("client-id-input")
    global.addClientButton = document.getElementById("add-client-button")
    global.removeClientButton = document.getElementById("remove-client-button")
    global.getClientsButton = document.getElementById("get-clients-button")
    global.clientsToServeList = document.getElementById("clients-to-serve-list")
    global.latestOrdersButton = document.getElementById("latest-orders-button")
    global.latestTickersButton = document.getElementById("latest-tickers-button")
    global.latestBalancesButton = document.getElementById("latest-balances-button")
    global.displayRegularOperationsResponseContainer = document.getElementById("display-regular-operations-response-container")
    global.qrreaderBackground = document.getElementById("qrreader-background")
    global.qrreaderVideoElement = document.getElementById("qrreader-video-element")
    global.messagebox = document.getElementById("messagebox")
    global.qrdisplayBackground = document.getElementById("qrdisplay-background")
    global.qrdisplayContent = document.getElementById("qrdisplay-content")
    global.qrdisplayQr = document.getElementById("qrdisplay-qr")
    return
    
module.exports = indexdomconnect