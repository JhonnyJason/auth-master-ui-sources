import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = {

    appcoremodule: true
    deleteconfirmation: true
    # aliasmodule: true
    # configmodule: true
    # contentmodule: true
    masterkeymodule: true
    # messageboxmodule: true
    # qrdisplaymodule: true
    # qrreadermodule: true
    servermodule: true
    
}

addModulesToDebug(modulesToDebug)