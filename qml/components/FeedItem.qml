import QtQuick 2.6

import Sailfish.Silica 1.0
import QtMultimedia 5.0

import "../Helper.js" as Helper
import "../MediaStreamMode.js" as MediaStreamMode

Column {
    id: feedItem
    property var item
    property bool playVideo : false
    property int type: 0

    width: parent.width
    height: childrenRect.height+20

    UserInfoBlock{
        id: header
        height: actions.height*1.1
    }

    spacing: 20

    MainItemLoader {
        id: mainLoader
        width: parent.width
        clip: true

        Image {
            id: likeImage
            width: (parent.width > parent.height) ? parent.height*0.4 : parent.width*0.4
            height: width

            sourceSize.height: height
            sourceSize.width: height

            opacity: 0

            source: "../images/heart.svg"

            anchors.centerIn: parent

            SequentialAnimation {
                id: doLikeAnimation
                NumberAnimation { target: likeImage; property: "opacity"; to: 1; from: 0; duration: 300 }
                NumberAnimation { target: likeImage; property: "opacity"; to: 0; from: 1; duration: 700 }
            }
        }

        MouseArea{
            anchors.centerIn: parent
            width: parent.width*0.5
            height: parent.width*0.5

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
                    if(item.has_liked === false)
                    {
                        instagram.like(item.id);
                        likeUpdate(true)
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
    /**/

    Rectangle{
        id: actions
        anchors{
            left: parent.left
            right: parent.right
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

    Label {
        id: likeCount

        width: parent.width-40
        anchors{
            left: parent.left
            leftMargin: 20
        }

        text:item.like_count+" "+qsTr("likes");
        font.bold: true
        color: Theme.secondaryHighlightColor
    }

    Label {
        id: description
        visible: text!==""

        width: parent.width-40
        anchors{
            left: parent.left
            leftMargin: 20
        }
        text: item.caption ? Helper.formatString(item.caption.text) : ""

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

        width: parent.width-40
        spacing: Theme.paddingMedium

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

    function likeUpdate(like) {       
        item.has_liked = like;
        likeIcon.source = like ? "../images/heart.svg" : "../images/heart-o.svg"
        item.like_count = item.like_count+(like ? 1 : (-1) );
        likeCount.text = item.like_count + " " +qsTr("likes")

    }
}
