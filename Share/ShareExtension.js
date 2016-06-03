
var MyExtensionJavaScriptClass = function() {};

MyExtensionJavaScriptClass.prototype = {
    getImage: function() {
        var metas = document.getElementsByTagName('img');
        var metaContents = "";
        metaContents = ( metas[0].getAttribute("src"));
        for (i=1; i<metas.length; i++) {
                metaContents = metaContents + "'#~@"+( metas[i].getAttribute("src"));
        }
        return metaContents;
    },
    getDescription: function() {
        var metas = document.getElementsByTagName('a');
        for (i=0; i<metas.length; i++) {
            if (metas[i].getAttribute("name") == "background-image") {

                return metas[i].getAttribute("background-image");
            }
        }
        return "xyz";
    },
    run: function(arguments) {
    // Pass the baseURI of the webpage to the extension.
        arguments.completionFunction({"url": document.baseURI, "host": document.location.hostname, "title": document.title, "description":this.getDescription(), "image": this.getImage()});
    },
// Note that the finalize function is only available in iOS.
    finalize: function(arguments) {
        // arguments contains the value the extension provides in [NSExtensionContext completeRequestReturningItems:completion:].
    // In this example, the extension provides a color as a returning item.
    // document.body.style.backgroundColor = arguments["bgColor"];
    }
};

// The JavaScript file must contain a global object named "ExtensionPreprocessingJS".
var ExtensionPreprocessingJS = new MyExtensionJavaScriptClass;
