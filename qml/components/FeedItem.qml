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
            anchors.fill: parent
            source: item.image_versions2.candidates[0].url

            Image {
                id: likeImage
                width: (parent.width > parent.height) ? parent.height*0.7 : parent.width*0.7
                height: width

                sourceSize.height: height
                sourceSize.width: height

                opacity: 0

                source: "../images/heart.svg"

                anchors{
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                SequentialAnimation {
                    id: doLikeAnimation
                    NumberAnimation { target: likeImage; property: "opacity"; to: 1; from: 0; duration: 300 }
                    NumberAnimation { target: likeImage; property: "opacity"; to: 0; from: 1; duration: 700 }
                }
            }
        }

        Image {
           anchors.centerIn: parent
           source:  "image://theme/icon-cover-play"
           visible: item.media_type == 2 && !playVideo
        }

        MouseArea{
            anchors.fill: parent

            Timer{
                id:timer
                interval: 200
                onTriggered: {
                    goToMedia();
                }
            }

            onClicked: {
                if(timer.running)
                {
                    doLikeAnimation.start()
                    if(item.has_liked)
                    {
                        instagram.unLike(item.id);
                    }
                    else
                    {
                        instagram.like(item.id);
                    }
                    timer.stop()
                }
                else
                {
                    timer.restart()
                }
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
                goToMedia();
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

    Column{
        id: commentsRectangle

        width: parent.width
        spacing: Theme.paddingMedium

        anchors{
            top: description.bottom
        }

        Repeater{
            id: commentsPreview
            model: item.preview_comments
            delegate: CommentItem{item: model}
        }
    }


    function linkClick(link)
    {
        var result = link.split("://");
        if(result[0] === "user")
        {
            instagram.searchUsername(result[1]);
        }

        if(result[0] === "tag")
        {
            pageStack.push(Qt.resolvedUrl("../pages/MediaStreamPage.qml"),{tag: result[1], mode:  MediaStreamMode.TAG_MODE, streamTitle: 'Tagged with ' + "#"+result[1] });
        }
    }

    function goToMedia()
    {
        pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:item});
    }

    Connections{
        target: instagram
        onLikeDataReady:{
            var out = JSON.parse(answer)
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
