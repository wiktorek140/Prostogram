.pragma library

//24-20-28-32-40-64-50

var TINY = 20;
var EXTRA_SMALL = 24;
var SMALL = 28;
var MEDIUM = 32;
var LARGE = 40;
var EXTRA_LARGE = 50;
var HUGE = 64;


var STYLE_COLOR_BACKGROUND = "white";
var STYLE_COLOR_FONT = "black";
var STYLE_COLOR_LINK = "navy";
var STYLE_COLOR_BUTTON = "gray";

var STYLE_COLOR_INBOX_GRAY = STYLE_COLOR_BUTTON;

function profileFontSize() {
    return SMALL;
}

function feedFontSize() {
    return SMALL;
}
function feedLikeFontSize() {
    return EXTRA_SMALL;
}
function inboxFontSize() {
    return SMALL;
}
function storyTitleSize() {
    return TINY;
}

//tech function
function skrocLiczbe(input){
    var arg = parseInt(input);
    if(arg < 1000) return arg;
    if(arg < 1000000) {
        return (arg/1000).toFixed(1) + "k";
    }
    if(arg <1000000000) {
        return (arg/1000000).toFixed(1) + "m";
    } else {
        return (arg/1000000000).toFixed(1) + "b";
    }
}


