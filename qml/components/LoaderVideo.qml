import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.5

Rectangle {
    width: parent.width
    height: parent.height

    Image {
        id: mainImage
        anchors.fill: parent
        source: item.image_versions2.candidates[0].url
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

        height: visible ? parent.height : 0
        width: parent.width

        autoPlay: item.autoVideoPlay

        muted: true

        onPlaybackStateChanged: {
            if(playbackState == 0)
            {
                video.play();
            }
        }
    }
    Component.onDestruction: {
        video.stop();
    }


    Component.onCompleted: {
        video.source = item.video_versions.get(0).url
    }

    Image {
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
                if(video.muted)
                {
                    parent.source = "../images/volume-up.svg"
                    video.muted = false
                }
                else
                {
                    parent.source = "../images/volume-off.svg"
                    video.muted = true
                }
            }
        }
    }
}
