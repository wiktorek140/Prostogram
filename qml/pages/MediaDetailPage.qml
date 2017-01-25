import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../components"
import "../CoverMode.js" as CoverMode
import "../MediaStreamMode.js" as  MediaStreamMode
import "../Helper.js" as Helper

Page {

    allowedOrientations:  Orientation.All

    property var item
    property var relationStatus
    property bool playVideo : false
    property bool userLikedThis : false
    property bool likeStatusLoaded : false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + header.height + 10
        contentWidth: parent.width

        PageHeader {
            id: header
            title: qsTr("Details")
        }

        ListModel{
            id: commentsModel
        }

        Column {

            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            id: column
            spacing: Theme.paddingSmall

            Label {
                id: likesCommentsCount
                text: item.like_count + " " +qsTr("likes") + " - " + item.comment_count + " " + qsTr("comments")  + (item.has_liked? " - " + qsTr("You liked this.") : "")
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeTiny
                color: userLikedThis? Theme.highlightColor : Theme.secondaryHighlightColor

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("LikesPage.qml"), {mediaId: item.id});
                    }
                }
            }

            Rectangle {
                id: image
                anchors.left: parent.left
                anchors.right: parent.right
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


            Label {
                id: description
                visible: text!==""
                text: item.caption ? Helper.formatString(item.caption.text) : ""
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium

                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                linkColor: Theme.highlightColor

                textFormat: Text.StyledText

                onLinkActivated: {
                    linkClick(link);
                }
            }

            UserInfoBlock {
                id:userInfo
            }

            Rectangle{
                id: doComment
                width: parent.width
                height: childrenRect.height
                color: "transparent"

                IconButton{
                    id: sendCommentButton
                    icon.source: "image://theme/icon-m-bubble-universal?" + (pressed
                                     ? Theme.highlightColor
                                     : Theme.primaryColor)
                    anchors.right: parent.right

                    onClicked: {
                        commentBody.readOnly = true
                        if(commentBody.text.length > 0)
                        {
                            instagram.postComment(item.id, commentBody.text)
                        }
                    }
                }

                TextField{
                    id: commentBody
                    width: parent.width-sendCommentButton.width
                    anchors{
                        verticalCenter: sendCommentButton.verticalCenter
                        left: parent.left
                    }
                }
            }

            Repeater {
                id: commentsRepeater
                model: commentsModel
                width: parent.width
                delegate: CommentItem{item: modelData}
            }
        }


        PullDownMenu {

            MenuItem {
                id: followMenu
                text: qsTr("Follow")
                visible: item.user.pk != app.user.pk && item.user.friendship_status.following
                onClicked: {
                    instagram.follow(item.user.pk)
                    followMenu.visible = false
                    unFollowMenu.visible = true
                }
            }

            MenuItem {
                id: unFollowMenu
                text: qsTr("Un Follow")
                visible: item.user.pk != app.user.pk && !item.user.friendship_status.following
                onClicked: {
                    instagram.unFollow(item.user.pk)
                    unFollowMenu.visible = false
                    followMenu.visible = true
                }
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

    Component.onCompleted: {
        userLikedThis = item.has_liked;
        refreshCallback = null
        instagram.getMediaComments(item.id);
        if(app.user.pk !== item.user.pk)
        {
            instagram.userFriendship(item.user.pk);
        }
        else
        {
            followMenu.visible = false
            unFollowMenu.visible = false
        }
    }

    Connections{
        target: instagram
        onLikeDataReady:{
            var out = JSON.parse(answer)
            if(out.status === "ok")
            {
                item.has_liked= true;
                likeMenu.visible = false
                unLikeMenu.visible = true;
                likesCommentsCount.text = item.like_count+1 + " " +qsTr("likes") + " - " + item.comment_count + " " + qsTr("comments") + " - " + qsTr("You liked this.")
            }
        }
    }

    Connections{
        target: instagram
        onUnLikeDataReady:{
            var out = JSON.parse(answer)
            if(out.status === "ok")
            {
                item.has_liked= false;
                likeMenu.visible = true
                unLikeMenu.visible = false;
                likesCommentsCount.text = item.like_count-1 + " " +qsTr("likes") + " - " + item.comment_count + " " + qsTr("comments")
            }
        }
    }

    Connections{
        target: instagram
        onMediaCommentsDataReady:{
            var out = JSON.parse(answer)
            out.comments.forEach(function(comment){
                commentsModel.append(comment)
            })
        }
    }

    Connections{
        target: instagram
        onCommentPosted:{
            instagram.getMediaComments(item.id);
            commentBody.readOnly = false
            commentBody.text = "";
        }
    }

    Connections{
        target: instagram
        onSearchUsernameDataReady:{
            var data = JSON.parse(answer)
            if(data.status === "ok")
            {
                pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"),{user: data.user});
            }
        }
    }

    Connections{
        target: instagram
        onUserFriendshipDataReady:{
            relationStatus = JSON.parse(answer)

            followMenu.visible = !relationStatus.following
            unFollowMenu.visible = relationStatus.following
        }
    }
}
