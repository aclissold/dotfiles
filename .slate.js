// Zooming windows

var zoom = slate.operation("move", {
    "x": "screenOriginX",
    "y": "screenOriginY",
    "width": "screenSizeX",
    "height": "screenSizeY"
});

function unZoom(win) {
    if (slate.screen().id() == 0) {
        win.doOperation(slate.operation("move", {
            "x": "0.125*screenSizeX",
            "y": "0.125*screenSizeY",
            "width": "0.75*screenSizeX",
            "height": "0.75*screenSizeY"
        }));
    } else {
        win.doOperation(slate.operation("move", {
            "x": "1.32*screenSizeX",
            "y": "0.125*screenSizeY",
            "width": "0.75*screenSizeX",
            "height": "0.75*screenSizeY"
        }));
    }
}

// Pushing windows to the left 2/3 and right 1/3

var pushLeft = slate.operation("push", {
    "direction": "left",
    "style": "bar-resize:(2*(screenSizeX/3)-63)"
});

var pushRight = slate.operation("push", {
    "direction": "right",
    "style": "bar-resize:(screenSizeX/3+63)"
});

function pushWindowRight(win) {
    win.doOperation(pushRight);
}

// Moving windows between desktops -- thanks @franzwr! http://git.io/1ZY69A

function moveWindowToPreviousSpace(win) {
  var windowClickCoords = (win.rect().x + win.rect().width/2) + "," + (win.rect().y + 5);
  S.shell(
    "/usr/local/bin/cliclick -r c:" + windowClickCoords +
    " w:50 dd:" + windowClickCoords +
    " kd:ctrl kp:arrow-left w:500 ku:ctrl du:" + windowClickCoords
  );
};
function moveWindowToNextSpace(win) {
  var windowClickCoords = (win.rect().x + win.rect().width/2) + "," + (win.rect().y + 5);
  S.shell(
    "/usr/local/bin/cliclick -r c:" + windowClickCoords +
    " w:50 dd:" + windowClickCoords +
    " kd:ctrl kp:arrow-right w:500 ku:ctrl du:" + windowClickCoords
  );
};

// Bindings

slate.bind("up:ctrl,alt,cmd", zoom);
slate.bind("down:ctrl,alt,cmd", unZoom);
slate.bind("left:ctrl,alt,cmd", pushLeft);
slate.bind("right:ctrl,alt,cmd", pushRight);
slate.bind("left:shift,cmd", moveWindowToPreviousSpace);
slate.bind("right:shift,cmd", moveWindowToNextSpace);
