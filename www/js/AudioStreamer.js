(function(){

	/* Get local ref to global PhoneGap/Cordova/cordova object for exec function.
		- This increases the compatibility of the plugin. */
	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

 	/*
  	 * This class exposes the iPhone 'icon badge' functionality to JavaScript
  	 * to add a number (with a red background) to each icon.
  	*/
	function AudioStreamer() { }
 
//	AudioStreamer.prototype.setStreamURL = function(url, autoplay, type, success, fail) {
//        var args = {};
//        args.url = url;
//        args.autoplay = autoplay;
//        args.type = type;
////        console.log("AudioStreamer.prototype.setStreamURL was called");
//        cordovaRef.exec(success, fail, "CDVAudioStreamer", "setStreamURL", [args]);
//	};

	AudioStreamer.prototype.play = function(myurl, options, success, fail) {
            options = options || {url: myurl,
                            autoplay: true,
                               type: "mp3"}; 
        cordovaRef.exec(success, fail, "CDVAudioStreamer", "playStream", [options]);
	};

 
    AudioStreamer.prototype.pause = function(success, fail) {
        cordovaRef.exec(success, fail, "CDVAudioStreamer", "pauseStream", []);
    };

    AudioStreamer.prototype.stop = function(success, fail) {
        cordovaRef.exec(success, fail, "CDVAudioStreamer", "stopStream", []);
    };
 
	cordovaRef.addConstructor(function() {
		if(!window.plugins) {
			window.plugins = {};
		}
		if(!window.plugins.audioStreamer) {
    		window.plugins.audioStreamer = new AudioStreamer();
		}
	});
	
})(); /* End of Temporary Scope. */