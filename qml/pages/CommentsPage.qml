import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

import "../components"
import "../CoverMode.js" as CoverMode
import "../MediaStreamMode.js" as  MediaStreamMode
import "../Helper.js" as Helper

Page {
    allowedOrientations:  Orientation.All
    property var elementId
    property var comments
    property var relationStatus
    property bool reloaded: false

    Rectangle {
        anchors.fill: parent
        color: settings.backgroundColor()
    }

    ListModel {
        id: commentModel
    }

    SilicaFlickable {
        id: flick
        anchors {
            fill: parent
            bottom: doComment.top
        }
        contentHeight: header.height + mainComment.height +commentsRepeater.height + 20
        contentWidth: parent.width
        //height: parent.height - doComment.height

        PullDownMenu {
            MenuItem {
                id: reload
                text: qsTr("Reload")
                color: settings.fontColor()
                onClicked: {
                    //todo loadMore();
                }
            }
            MenuItem {
                id: loadMore
                text: qsTr("Load More")
                color: settings.fontColor()
                onClicked: {
                    //todo loadMore();
                }
            }
        }

        PageHeader {
            id: header
            _titleItem.color: settings.fontColor()
            title: qsTr("Comments")
        }

        Rectangle {
            id: mainComment
            width: parent.width
            height: width * 0.1852
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
            }
            color: settings.backgroundColor()

            Image {
                id: userPic
                width: parent.width * 0.15
                height: width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                    topMargin: Theme.paddingMedium

                }
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: userPic.width
                        height: userPic.height
                        Rectangle {
                            anchors.centerIn: parent
                            width: userPic.width
                            height: userPic.height
                            radius: width
                        }
                    }
                }
            }

            Label {
                id: description
                anchors {
                    top: mainComment.top
                    left: userPic.right
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }

                wrapMode: Text.Wrap
                font.pixelSize: settings.extra_small
                color: settings.fontColor()
                linkColor: settings.linkColor()
                textFormat: Text.StyledText
                onLinkActivated: {
                    linkClick(link);
                }
            }
        }

        Border {
            id: border
            anchors.top: mainComment.bottom
        }

        ColumnView {
            id: commentsRepeater
            width: parent.width
            anchors {
                top: border.bottom
                left: parent.left
                right: parent.right

                leftMargin: Theme.paddingMedium
                rightMargin: Theme.paddingMedium
            }
            itemHeight: Screen.width * 0.19
            model:commentModel

            delegate: CommentItem {
                item: model
            }
        }
    }


    Rectangle {
        id: doComment
        anchors.bottom: parent.bottom
        width: parent.width
        height: childrenRect.height
        color: settings.backgroundColor()

        Border {}

        IconButton {
            id: sendCommentButton
            icon.source: "image://theme/icon-m-bubble-universal?" + (pressed
                                                                     ? Theme.highlightColor
                                                                     : settings.fontColor())
            anchors.right: parent.right
            onClicked: {
                commentBody.readOnly = true
                if(commentBody.text.length > 0) {
                    instagram.comment(elementId, commentBody.text)
                }
            }
        }

        TextField {
            id: commentBody
            color: settings.fontColor()
            width: parent.width - sendCommentButton.width
            anchors{
                verticalCenter: sendCommentButton.verticalCenter
                left: parent.left
            }
        }
    }


    function linkClick(link)
    {
        var result = link.split("://");
        if(result[0] === "user") {
            console.log("Load user "+result[1])
            instagram.searchUsername(result[1]);
        }

        if(result[0] === "tag") {
            console.log("Load tag "+result[1])
            pageStack.push(Qt.resolvedUrl("../pages/MediaStreamPage.qml"),{tag: result[1], mode:  MediaStreamMode.TAG_MODE, streamTitle: 'Tagged with ' + "#"+result[1] });
        }
    }

    Component.onCompleted: {
        refreshCallback = null

        instagram.getComments(elementId);
    }

    Connections {
        target: instagram

        onMediaDeleted: {
            pageStack.pop();
        }
        onMediaCommentsDataReady: {
            //print(answer);
            var data = JSON.parse(answer);

            userPic.source = data.caption.user.profile_pic_url;
            description.text = "<b>"+data.caption.user.username+"</b> "+ Helper.formatString(data.caption.text);
            mainComment.height = 10 + ( userPic.height > description.contentHeight ? userPic.height : description.contentHeight);

            if(reloaded) commentModel = data.comments;
            else {
                for(var i=0; i < data.comments.length; i++){
                    //print("Counter: "+i)
                    commentModel.append(data.comments[i]);
                }
            }
            reloaded = false;
        }
        onCommentPosted: {
            //print(answer)
            instagram.getComments(elementId);
            commentBody.readOnly = false
            commentBody.text = "";
            reloaded = true;
        }
        onSearchUsernameDataReady: {
            var data = JSON.parse(answer)
            if(data.status === "ok") {
                pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"),{user: data.user});
            }
        }

        onInfoByIdDataReady: {
            //print(answer)
            var out = JSON.parse(answer)
            pageStack.push(Qt.resolvedUrl("UserProfilPage.qml"),
                           {user: out.user})
        }
    }
}
