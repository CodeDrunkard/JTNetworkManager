console = {
    log: function(string) {
        window.webkit.messageHandlers.WKJSMessageHandler.postMessage({className: "Console", functionName: "log", message: String});
    }
}
