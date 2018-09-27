import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.5

//reworked

Rectangle {

    property var url
    property var videoUrl
    property bool autoVideoPlay

    width: parent.width
    height: parent.height
    color: settings.backgroundColor()

    Image {
        id: placeholder
        anchors.fill: parent
        source: url;
        visible: video.source == "" || video.status === MediaPlayer.Loading
    }

    BusyIndicator {
        anchors.centerIn: parent
        visible: video.source == "" || video.status === MediaPlayer.Loading
        running: visible
    }

    Video {
        id: video
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        width: parent.width
        autoPlay: autoVideoPlay
        muted: true
        //source: ""
        onPlaybackStateChanged: {
            print("Playback State: "+ playbackState);
            if(playbackState == 0 && visible) {
                video.play();
            }
        }

        onVisibleChanged: {
            //print("Visible: "+visible);
            if(!visible) {
                video.stop();
            }
            else if(playbackState == 0) video.play();
        }
    }

    Component.onDestruction: {
        video.stop();
    }

    Component.onCompleted: {
        //print(videoUrl + autoVideoPlay);
        video.source = videoUrl;//imageCache.getFromCache2(videoUrl);
        placeholder.visible = false;
    }

    Image {
        id: muteOption
        source: "../images/volume-off.svg"
        width: parent.width/14
        height: parent.width/14

        sourceSize.height: height
        sourceSize.width: height

        anchors {
            left: parent.left
            leftMargin: parent.width/25
            bottom: parent.bottom
            bottomMargin: parent.width/25
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(video.muted) {
                    muteOption.source = "../images/volume-up.svg"
                    video.muted = false
                } else {
                    muteOption.source = "../images/volume-off.svg"
                    video.muted = true
                }
            }
        }
    }
}
