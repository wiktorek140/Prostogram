import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.5

import "../components"
import "../CoverMode.js" as CoverMode
import "../MediaStreamMode.js" as  MediaStreamMode
import "../Helper.js" as Helper

Page {

    allowedOrientations:  Orientation.Portrait
    property bool isVideo: false
    property bool loadedAll: false
    property string userId: ""
    property bool playVideo : false
    property int counter: 0
    property int last: 1


    ListModel {
        id: storiesList
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: parent.height
        contentWidth: parent.width

        Rectangle {

            width: parent.width
            height: parent.height

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            visible: loadedAll
            id: column
            color: "transparent"


            MouseArea {
                id: moveLeft
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: parent.width/3
                height: parent.height - 100
                onClicked: {
                    mLeft()
                }
            }

            MouseArea {
                id: end
                anchors {
                    left: moveLeft.right
                    top: parent.top
                    bottom: parent.bottom
                }
                width: parent.width/3
                height: parent.height - 100
                onClicked: {
                    pageStack._navigateBack();
                }
            }
            MouseArea {
                id: moveRight
                anchors {
                    left: end.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                width: parent.width/3
                height: parent.height - 100
                onClicked: {
                    mRight()
                }
            }

            Image {
                id: imageItem
                visible: loadedAll && !isVideo
                source: ""
                width: parent.width
                height: parent.height

                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
            }

            Video {
                id: video
                visible: isVideo
                anchors.left: parent.left
                anchors.right: parent.right

                height: visible ? parent.height : 0
                width: parent.width

                autoPlay: true
                muted: false
            }

            Label {
                id: userNameLabel
                height: parent.height/10
                anchors {
                    right: parent.right
                    top: parent.top
                    rightMargin: Theme.paddingMedium
                    topMargin: height/2;
                }

                text: ""
                fontSizeMode: Theme.iconSizeSmall
                visible: loadedAll
            }
        }
    }

    function linkClick(link)
    {
        var result = link.split("://");
        if(result[0] === "user")
        {
            console.log("Load user "+result[1])
            instagram.searchUsername(result[1]);
        }

        if(result[0] === "tag")
        {
            console.log("Load tag "+result[1])
            pageStack.push(Qt.resolvedUrl("../pages/MediaStreamPage.qml"),{tag: result[1], mode:  MediaStreamMode.TAG_MODE, streamTitle: 'Tagged with ' + "#"+result[1] });
        }
    }

    function mLeft() {
        if(counter >= 1) {
            counter--;
            console.log("Left")
            checkType();
            //imageItem.source = storiesList.get(counter).image_versions2.candidates[0].url;
        }
        else pageStack._navigateBack();
    }

    function mRight(){
        if(counter < last-1) {
            counter++;
            console.log("Right")
            //imageItem.source = storiesList.get(counter).image_versions2.candidates[0].url;
            checkType();
        }
        else pageStack._navigateBack();
    }


    function checkType() {
        if(storiesList.get(counter).media_type === 2) {
            isVideo = true
            video.source = storiesList.get(counter).video_versions.get(0).url
        }
        else {
            isVideo = false
            imageItem.source = storiesList.get(counter).image_versions2.candidates[0].url;
        }
    }

    Component.onCompleted: {
            instagram.getUserReelsMediaFeed(userId);
    }

    Connections{
        target: instagram

        onUserReelsMediaFeedDataReady: {
            //print(answer)
            var data = JSON.parse(answer)

            for(var i=0; i<data.items.length; i++){
                storiesList.append(data.items[i])
                console.log("Added");

            }

            imageItem.source = data.items[0].image_versions2.candidates[0].url
            checkType();
            userNameLabel.text = data.user.username
            last = data.items.length
            loadedAll = true
        }
    }
}
