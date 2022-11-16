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
        this.bannerImg = new AR.ImageResource("assets/bannerWithNameField.jpg", {
            onError: World.onError
        });
        this.bannerImgOverlay = new AR.ImageDrawable(this.bannerImg, 0.4, {
            translate: {
                y: 0.6
            }
        });

        this.orderNowButtonImg = new AR.ImageResource("assets/orderNowButton.png", {
            onError: World.onError
        });
        this.orderNowButtonOverlay = new AR.ImageDrawable(this.orderNowButtonImg, 0.3, {
            translate: {
                y: -0.6
            }
        });
    },

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
                Next a onClick handler is added to the orderNowButt onOverlay, making use of the AR.context class to
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