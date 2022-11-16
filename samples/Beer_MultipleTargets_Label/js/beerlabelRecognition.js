var World = {
    score: 5,
    beerList: "",
    beer: {},

    init: function initFn() {
        this.createOverlays();

        AR.platform.sendJSONObject({
            "beerName": "All beers",
            "isAdd": false
        })
    },

    createOverlays: function createOverlaysFn() {

        this.targetCollectionResource = new AR.TargetCollectionResource("assets/beerlabels.wtc", {
            onError: World.onError
        });
        this.tracker = new AR.ImageTracker(this.targetCollectionResource, {
            onTargetsLoaded: this.worldLoaded
        });

        var bannerImg = new AR.ImageResource("assets/beerOverlay.png", {
            onError: World.onError
        });

        var bannerImgOverlay = new AR.ImageDrawable(bannerImg, 0.4, {
            translate: {
                y: 0.6
            }
        })

        var orderNowButtonImg = new AR.ImageResource("assets/addButton.png", {
            onError: World.onError
        });            

        this.scanBeer = new AR.ImageTrackable(this.tracker, "*", {
            drawables: {
                cam: [bannerImgOverlay]
            },
            onImageRecognized: function(target) {
                var orderNowButtonOverlay = new AR.ImageDrawable(orderNowButtonImg, 0.3, {
                    translate: {
                        y: -0.6
                    },
                    onClick: function() {
                        AR.platform.sendJSONObject({
                            "beerName": target.name,
                            "isAdd": true
                        })
                    } 
                });                

                this.addImageTargetCamDrawables(target, orderNowButtonOverlay);

                this.beerName = new AR.Label(target.name, 0.06, {
                    translate: {
                        y: 0.72
                    },
                    zOrder: 2
                })

                this.addImageTargetCamDrawables(target, this.beerName);

                this.beerLabel = new AR.ImageResource("assets/" + target.name + ".jpg", {
                    onError: World.onError
                });
                this.beerLabelOverlay = new AR.ImageDrawable(this.beerLabel, 0.2, {
                    translate: {
                        x: -0.37,
                        y: 0.55
                    },
                    zOrder: 1
                });

                this.addImageTargetCamDrawables(target, this.beerLabelOverlay);

                // Below function locates the correct beer in the list based on the target name. 
                //It is not used because of parsin errors
                
                // World.search(target.name, World.beerList);

                this.averageScore = new AR.Label(World.score + "/5 average", 0.06, {
                    translate: {
                        y: 0.60
                    },
                    zOrder: 3
                });

                this.addImageTargetCamDrawables(target, this.averageScore);

                AR.platform.sendJSONObject({
                    "beerName": target.name,
                    "isAdd": false
                })
                World.hideInfoBar;
            } ,
            onError: World.onError
        });
    },

    updateScore: function retrieveScoreFn(score) {
        World.score = score;
    },

    updateBeers: function updateBeersFn(beers) {
        World.beerList = beers;
        console.log("arrived");
        console.log(beers);
    },

    search: function searchFn(nameKey, beers) {
        console.log("arrived");
        var beerJSON = JSON.parse(beers);
        for (var i=0; i < beerJSON.length; i++) {
            if (beers[i].name === nameKey) {
                World.beer = beers[i];
                console.log(beers[i].name)
                console.log(beers[i].barcode)
            }
        }
    },

    onError: function onErrorFn(error) {
        alert(error);
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