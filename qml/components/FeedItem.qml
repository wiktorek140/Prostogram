import QtQuick 2.0

import Sailfish.Silica 1.0
import QtMultimedia 5.0

import "../Helper.js" as Helper

Item {
    property var item
    property bool playVideo : false

    width: parent.width
    height: childrenRect.height


    UserInfoBlock{
        id: header
        height: actions.height*1.1
    }


    Rectangle {
        id: image
        anchors{
            left: parent.left
            right: parent.right
            top: header.bottom
            topMargin: header.height*0.1
        }

        height: parent.width/item.image_versions2.candidates[0].width*item.image_versions2.candidates[0].height
        color: "transparent"

        Image {
            id: mainImage
            visible: !playVideo
            anchors.fill: parent
            source: item.image_versions2.candidates[0].url
        }

        BusyIndicator {
            anchors.centerIn: parent
            visible: playVideo && video.status === MediaPlayer.Loading
            running: visible
        }

        Image {
           anchors.centerIn: parent
           source:  "image://theme/icon-cover-play"
           visible: item.media_type == 2 && !playVideo
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(playVideo)
                {
                    video.stop()
                }
                else
                {
                    video.play();
                }
            }
            visible: item.media_type == 2 && !playVideo

        }

        Video {
            id: video
            anchors.left: parent.left
            anchors.right: parent.right
            height: visible ? parent.height : 0
            width: parent.width
            visible: (item.media_type == 2) ? true : false
            source: (item.video_versions) ? item.video_versions[0].url : ""

            onStopped: {
                playVideo = false;
            }

            onPlaying: {
                playVideo = true;
            }
        }
    }

    Rectangle{
        id: actions
        anchors{
            left: parent.left
            right: parent.right
            top: image.bottom
        }

        width: parent.width
        height: likeIcon.height*1.1

        color: "transparent"

        ClickIcon {
            id: likeIcon

            height: commentIcon.height*0.6
            width: commentIcon.width*0.6

            anchors{
                left: parent.left
                leftMargin: likeIcon.width/3
                verticalCenter: commentIcon.verticalCenter
            }

            source: item.has_liked ? "../images/heart.svg" : "../images/heart-o.svg"
            onClicked: {
                if(item.has_liked)
                {
                    instagram.unLike(item.id);
                }
                else
                {
                    instagram.like(item.id);
                }
            }

        }

        IconButton {
            id: commentIcon

            anchors{
                left: likeIcon.right
                leftMargin: commentIcon.width/3
            }

            icon.source: "image://theme/icon-m-bubble-universal?" + (pressed
                         ? Theme.highlightColor
                         : Theme.primaryColor)
            onClicked: {
                console.log("COMMENT")
            }
        }
    }

    Label{
        id: likeCount

        anchors{
            top: actions.bottom
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
            bottomMargin: Theme.paddingMedium
        }

        text:item.like_count+" "+qsTr("likes");
        font.bold: true
        color: Theme.secondaryHighlightColor
    }

    Label {
        id: description
        visible: text!==""
        text: item.caption ? Helper.formatString(item.caption.text) : ""
        anchors{
            top: likeCount.bottom
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
            bottomMargin: Theme.paddingMedium
        }

        clip: true;

        maximumLineCount: 3

        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.highlightColor
        linkColor: Theme.highlightColor

        textFormat: Text.StyledText

        onLinkActivated: {
            linkClick(link);
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

    Connections{
        target: instagram
        onLikeDataReady:{
            var out = JSON.parse(answer)
            console.log(answer)
            if(out.status == "ok")
            {
                item.has_liked= true;
                likeIcon.source = "../images/heart.svg"
                likeCount.text = item.like_count+1 + " " +qsTr("likes")
            }
        }
    }

    Connections{
        target: instagram
        onUnLikeDataReady:{
            var out = JSON.parse(answer)
            if(out.status == "ok")
            {
                item.has_liked= false;
                likeIcon.source = "../images/heart-o.svg"
                likeCount.text = item.like_count-1 + " " +qsTr("likes")
            }
        }
    }
}
