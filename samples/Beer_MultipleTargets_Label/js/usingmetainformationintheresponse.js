var World = {
    loaded: false,
    tracker: null,
    cloudRecognitionService: null,
    score: 5,

    init: function initFn() {
        this.createTracker();
        this.createOverlays();
    },

    /*
        First an AR.ImageTracker connected with an AR.CloudRecognitionService needs to be created in order to start
        the recognition engine. It is initialized with your client token and the id of one of your target collections.
        Optional parameters are passed as object in the last argument. In this case callback functions for the
        onInitialized and onError triggers are set. Once the tracker is fully loaded the function trackerLoaded() is
        called, should there be an error initializing the CloudRecognitionService the function trackerError() is
        called instead.
    */
    createTracker: function createTrackerFn() {
        this.cloudRecognitionService = new AR.CloudRecognitionService(
            "2aa7bbf4656923d28d41b550cd757040",
            "E7ow8dg5d",
            "6372062a1010a50069bf23e6", {
                onInitialized: World.trackerLoaded,
                onError: World.onError
            }
        );

        World.tracker = new AR.ImageTracker(this.cloudRecognitionService, {
            onError: World.onError
        });
    },

    startContinuousRecognition: function startContinuousRecognitionFn(interval) {
        /*
            With this function call the continuous recognition mode is started. It is passed four parameters, the
            first defines the interval in which a new recognition is started. It is set in milliseconds and the
            minimum value is 500. The second parameter defines a callback function that is called by the server if
            the recognition interval was set too high for the current network speed. The third parameter is again a
            callback which is fired when a recognition cycle is completed. The fourth and last paramater defines
            another callback function that is called in case an error occured during the client/server interaction.
        */
        this.cloudRecognitionService.startContinuousRecognition(interval, this.onInterruption, this.onRecognition, this.onRecognitionError);
    },

    createOverlays: function createOverlaysFn() {
        /*
            To display a banner containing information about the current target as an augmentation an image
            resource is created and passed to the AR.ImageDrawable. A drawable is a visual component that can be
            connected to an IR target (AR.ImageResource) or a geolocated object (AR.GeoObject). The AR.ImageDrawable
            is initialized by the image and its size. Optional parameters allow to position it relative to the
            recognized target.
        */
        var weatherWidget = new AR.HtmlDrawable({
            uri: "assets/weather.html"
        }, 0.25, {
            viewportWidth: 320,
            viewportHeight: 100,
            backgroundColor: "#FFFFFF",
            translate: {
                x: 0.36,
                y: 0.5
            },
            horizontalAnchor: AR.CONST.HORIZONTAL_ANCHOR.RIGHT,
            verticalAnchor: AR.CONST.VERTICAL_ANCHOR.TOP,
            clickThroughEnabled: true,
            allowDocumentLocationChanges: false,
            onDocumentLocationChanged: function onDocumentLocationChangedFn(uri) {
                AR.context.openInBrowser(uri);
            },
            onError: World.onError
        });


        this.bannerImg = new AR.ImageResource("assets/bannerWithNameField.jpg", {
            onError: World.onError
        });
        this.bannerImgOverlay = new AR.ImageDrawable(this.bannerImg, 0.4, {
            translate: {
                y: 0.6
            }
        });

        /*
            Additionally to the banner augmentation from the previous examples another drawable is created. This
            drawable will be a button which the user can click to open the shop's website in the browser.
        */
        this.orderNowButtonImg = new AR.ImageResource("assets/orderNowButton.png", {
            onError: World.onError
        });
        this.orderNowButtonOverlay = new AR.ImageDrawable(this.orderNowButtonImg, 0.3, {
            translate: {
                y: -0.6
            }
        });
    },

    /*
        The onRecognition callback function defines two parameters. The first parameter is a boolean value which
        indicates if the server was able to detect the target, its value will be 0 or 1 depending on the outcome.
        The second parameter a JSON Object will contain metadata about the recognized target, if no target was
        recognized the JSON object will be empty.
    */
    onRecognition: function onRecognitionFn(recognized, response) {
        if (recognized) {
            /* Clean Resources from previous recognitions. */
            if (World.beerLabel !== undefined) {
                World.beerLabel.destroy();
            }

            if (World.beerLabelOverlay !== undefined) {
                World.beerLabelOverlay.destroy();
            }

            AR.platform.sendJSONObject({
                "beerId": response.metadata.beerId,
                "isAdd": false
            });

            /*
                To display the label of the recognized wine on top of the previously created banner, another
                overlay is defined. From the response object returned from the server the 'targetInfo.name' property
                is read to load the equally named image file. The zOrder property (defaults to 0) is set to 1 to
                 make sure it will be positioned on top of the banner.
            */
            World.beerLabel = new AR.ImageResource("assets/" + response.metadata.name + ".jpg", {
                onError: World.onError
            });
            World.beerLabelOverlay = new AR.ImageDrawable(World.beerLabel, 0.2, {
                translate: {
                    x: -0.37,
                    y: 0.55
                },
                zOrder: 1
            });

            /*
                When the cloud archive was created custom metadata for every target was defined. You are a free to
                choose the number of fields and there names depending on your needs. For this example
                'metadata.name' which represents the real name of the wine and 'metadata.shop_url' a url to a
                webshop stocking the particular wine were defined. To display the real name of the wine in the
                banner overlay, an AR.Label is created. The first parameter defines the text of the label, the
                second it's height in SDUs, the third parameter set's some optional options. To set the first
                parameter of the AR.Label we read the before mentioned real name from the custom metadata object.
            */
            World.beerName = new AR.Label(response.metadata.name, 0.06, {
                translate: {
                    y: 0.72
                },
                zOrder: 2
            });

            World.averageScore = new AR.Label(World.score + "/5 average rating", 0.06, {
                translate: {
                    y: 0.60
                },
                zOrder: 3
            });

            /* Destroy the augmentation if there already was one from a previous target recognition. */
            if (World.beerLabelAugmentation !== undefined) {
                World.beerLabelAugmentation.destroy();
            }

            /*
                Next a onClick handler is added to the orderNowButtonOverlay, making use of the AR.context class to
                open the shop's website in browser. Again the server response object is utilized to read the url
                from the custom metadata of the current target.
            */
            World.orderNowButtonOverlay.onClick = function() {
                AR.platform.sendJSONObject({
                    "beerId": response.metadata.beerId,
                    "isAdd": true
                })
                world.hideInfoBar();
                onRecognition.destroy();
            };

            /*
                The following combines everything by creating an AR.ImageTrackable using the CloudRecognitionService,
                the name of the image target and the drawables that should augment the recognized image.
            */
            World.beerLabelAugmentation = new AR.ImageTrackable(World.tracker, response.targetInfo.name, {
                drawables: {
                    cam: [World.bannerImgOverlay, World.beerLabelOverlay, World.beerName, World.orderNowButtonOverlay, World.averageScore]
                },
                onError: World.onError
            });

            World.hideInfoBar();
        }
    },

    onRecognitionError: function onRecognitionErrorFn(errorCode, errorMessage) {
        World.cloudRecognitionService.stopContinuousRecognition();
        alert("error code: " + errorCode + " error message: " + JSON.stringify(errorMessage));
    },

    updateScore: function retrieveScoreFn(score) {
        World.score = score;        
    },

    /*
        In case the current network the user is connected to, isn't fast enough for the set interval. The server
        calls this callback function with a new suggested interval. To set the new interval the recognition mode
        first will be restarted.
    */
    onInterruption: function onInterruptionFn(suggestedInterval) {
        World.cloudRecognitionService.stopContinuousRecognition();
        World.startContinuousRecognition(suggestedInterval);
    },

    trackerLoaded: function trackerLoadedFn() {
        World.startContinuousRecognition(750);
        World.showInfoBar();
    },

    onError: function onErrorFn(error) {
        alert(error)
    },

    hideInfoBar: function hideInfoBarFn() {
        document.getElementById("infoBox").style.display = "none";
    },

    showInfoBar: function worldLoadedFn() {
        document.getElementById("infoBox").style.display = "table";
        document.getElementById("loadingMessage").style.display = "none";
    }
};

World.init();