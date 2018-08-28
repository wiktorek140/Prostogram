import QtQuick 2.5

import Sailfish.Silica 1.0
import QtMultimedia 5.0

import "../Helper.js" as Helper
import "../MediaStreamMode.js" as MediaStreamMode
import "../itemLoader.js" as ItemLoader
import "../MediaTypes.js" as MediaType

//Reworked

ListItem {

    id: feedItem
    property var item
    property bool playVideo: false
    property int type: 0
    property bool isLoaded: false

    width: parent.width
    height: header.height + image.height + actions.height +
            likeCount.height + description.height + commentsRectangle.height

    //Component.onCompleted: {
    //height = header.height + mainLoader.height + actions.height +
    //likeCount.height + description.height + commentsRectangle.height
    //}
    Component.onCompleted: {
        //if(item.media_type === MediaType.VIDEO_TYPE) item.media_type = MediaType.VIDEO_PREVIEW_TYPE;

        switch (item.media_type) {
        case MediaType.IMAGE_TYPE:
            image.height = (width/item.image_versions2.candidates[0].width) * item.image_versions2.candidates[0].height;
            ItemLoader.createComponentObjects("LoaderImage.qml", {"url": item.image_versions2.candidates[0].url}, image);
            break;

        case MediaType.VIDEO_TYPE:
            //print(item.video_versions.get(0).url);
            image.height = (width / item.original_width) * item.original_height;
            ItemLoader.createComponentObjects("LoaderVideo.qml", {"url": item.image_versions2.candidates[0].url,
                                                  "videoUrl": item.video_versions.get(0).url,
                                                  "autoVideoPlay": playVideo}, image);
            if(item.image_versions2.candidates[0].url) {
                print(JSON.toString(item))
            }

            break;
        case MediaType.CARUSEL_TYPE:
            //print(item.carousel_media[0].original_height)
            image.height = (width / item.carousel_media.get(0).original_width) *
                    item.carousel_media.get(0).original_height;
            ItemLoader.createComponentObjects("LoaderCarusel.qml", {"url": item.carousel_media}, image);
            break;
        case MediaType.VIDEO_PREVIEW_TYPE:
            image.height = (width/item.image_versions2.candidates[0].width) * item.image_versions2.candidates[0].height;
            ItemLoader.createComponentObjects("LoaderVideoPreview.qml", {"url": item.image_versions2.candidates[1].url}, image);
            break;
        }
        feedItemArea.width = image.width / 3;
        feedItemArea.height = image.width / 3;
        isLoaded = true;
    }

    Column {
        id: itemColumn
        width: parent.width


        UserInfoBlock {
            id: header
            //anchors.top: parent.top
        }

        Rectangle {
            id: image
            width: parent.width
            //height: parent.width * (4/3)
            //clip: true
            //anchors.top: header.bottom



            Image {
                z:5
                id: likeImage
                anchors.top: image.top
                width: image.width / 3
                //(image.width > image.height) ? image.height*0.4 : image.width*0.4
                height: width
                sourceSize.height: height
                sourceSize.width: height
                opacity: 0
                source: "../images/heart.svg"
                anchors.centerIn: parent
                SequentialAnimation {
                    id: doLikeAnimation
                    NumberAnimation { target: likeImage; property: "opacity"; to: 0.9; from: 0; duration: 300; }
                    NumberAnimation { target: likeImage; property: "opacity"; to: 0.95; from: 0.9; duration: 200; }
                    NumberAnimation { target: likeImage; property: "opacity"; to: 0; from: 1; duration: 700; }
                }
            }

            MouseArea {
                id: feedItemArea
                //z:2
                //anchors.centerIn: parent
                //width: image.width
                //height: image.width
                anchors.fill: image
                property real lClick : 0

                onClicked: {
                    var nc = Date.now()
                    if ((nc - lClick) < 500) {
                        doLikeAnimation.start()
                        if(item.has_liked === false)
                        {
                            instagram.like(item.id);
                            likeUpdate(true)
                        }
                    }
                    lClick = nc
                }
            }
        }


        Rectangle {
            id: actions
            anchors{
                left: parent.left
                right: parent.right
                //top: image.bottom
            }

            width: parent.width
            height: commentIcon.height

            Image {
                id: likeIcon
                height: commentIcon.height * 0.7
                width: commentIcon.width * 0.7
                anchors {
                    left: parent.left
                    leftMargin: likeIcon.width / 3
                    verticalCenter: commentIcon.verticalCenter
                }
                source: item.has_liked ? "../images/heart.svg" : "../images/heart-o.svg"
                MouseArea {
                    id: clickLikeIcon
                    anchors.fill: parent
                    onClicked: {
                        if(item.has_liked === true)
                        {
                            instagram.unLike(item.id);
                            likeUpdate(false);
                        }
                        else
                        {
                            instagram.like(item.id);
                            likeUpdate(true);
                        }
                    }
                }
            }

            IconButton {
                id: commentIcon
                anchors {
                    left: likeIcon.right
                    leftMargin: commentIcon.width/3
                }
                icon.source: "image://theme/icon-m-bubble-universal?" +
                             (pressed? Theme.highlightColor: "black" )
                onClicked: { goToComents(); }
            }
        }

        Label {
            id: likeCount
            color: "black"
            width: parent.width-40
            height: Font.bold
            anchors{
                left: parent.left
                leftMargin: 20
                //top:actions.bottom
            }

            text: item.like_count+" "+qsTr("likes");
            font.bold: true
            font.pixelSize: Theme.fontSizeExtraSmall
        }

        Label {
            id: description
            visible: text !== ""

            width: parent.width - 40
            anchors {
                left: parent.left
                leftMargin: 20
                //top: likeCount.bottom
            }

            text: item.caption ? Helper.formatString(item.caption.text) : ""
            clip: true
            maximumLineCount: 3

            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeSmall
            color: "black"
            linkColor: "navy"
            textFormat: Text.StyledText

            onLinkActivated: {
                linkClick(link);
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    goToComents();
                }
            }
        }

        Rectangle {
            //to fix
            id: commentsRectangle
            //anchors.top: description.bottom
            anchors.leftMargin: 20
            width: parent.width
            height: commentsPreview.height + 10
            visible: item.preview_comments !== []

            Repeater {
                id: commentsPreview
                model: item.preview_comments
                delegate: Label {
                    text: "<b>"+ model.user.username + "</b>" + model.text
                    textFormat: Text.StyledText
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width
                    height: font.pixelSize
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
                //CommentItem { item: model }
            }
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

    function goToComents()
    {
        pageStack.push(Qt.resolvedUrl("../pages/CommentsPage.qml"),{"elementId": item.id});
    }

    function likeUpdate(like) {
        item.has_liked = like;
        likeIcon.source = like ? "../images/heart.svg" : "../images/heart-o.svg"
        item.like_count = item.like_count+(like ? 1 : (-1) );
        likeCount.text = item.like_count + " " +qsTr("likes")

    }
}
