// Pushing to the left 2/3 and right 1/3

var pushLeft = slate.operation("push", {
    "direction": "left",
    "style": "bar-resize:(2*(screenSizeX/3)-34)"
});

var pushRight = slate.operation("push", {
    "direction": "right",
    "style": "bar-resize:(screenSizeX/3+34)"
});

function pushWindowLeft(win) {
    win.doOperation(pushLeft);
}

function pushWindowRight(win) {
    win.doOperation(pushRight);
}

// Moving between workspaces -- thanks @franzwr! http://git.io/1ZY69A

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

slate.bind("left:ctrl,alt,cmd", pushWindowLeft);
slate.bind("right:ctrl,alt,cmd", pushWindowRight);
slate.bind("left:ctrl,cmd", moveWindowToPreviousSpace);
slate.bind("right:ctrl,cmd", moveWindowToNextSpace);
