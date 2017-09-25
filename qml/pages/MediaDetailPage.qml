import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../components"
import "../CoverMode.js" as CoverMode
import "../MediaStreamMode.js" as  MediaStreamMode
import "../Helper.js" as Helper

Page {

    allowedOrientations:  Orientation.All
    property bool isStory: false
    property var item

    property var relationStatus
    property bool playVideo : true
    property bool userLikedThis : false
    property bool likeStatusLoaded : false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + header.height + 10
        contentWidth: parent.width

        PageHeader {
            id: header
            visible: !isStory
            title: isStory? qsTr("Story") : qsTr("Details")
        }

        Column {

            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            id: column
            spacing: Theme.paddingSmall

            Label {
                id: likesCommentsCount
                visible: !isStory
                text: item.like_count + " " +qsTr("likes") + " - " + item.comment_count + " " + qsTr("comments")  + (item.has_liked? " - " + qsTr("You liked this.") : "")
                anchors{
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
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



            MainItemLoader{
                id: mainLoader
                isSquared: false
                width: parent.width
            }


            Label {
                id: description
                visible: text!=="" && !isStory
                text: item.caption ? Helper.formatString(item.caption.text) : ""
                anchors{
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }

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
                visible: !isStory
            }

            Rectangle{
                id: doComment
                visible: !isStory
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
                width: parent.width
                delegate: CommentItem{item: modelData}
            }
        }


        PullDownMenu {
            visible: !isStory
            MenuItem {
                id: followMenu
                text: qsTr("Follow")
                visible: isStory? false : item.user.pk != app.user.pk && item.user.friendship_status.following
                onClicked: {
                    instagram.follow(item.user.pk)
                    followMenu.visible = false
                    unFollowMenu.visible = true
                }
            }

            MenuItem {
                id: unFollowMenu
                text: qsTr("UnFollow")
                visible: isStory ? false: item.user.pk != app.user.pk && !item.user.friendship_status.following
                onClicked: {
                    instagram.unFollow(item.user.pk)
                    unFollowMenu.visible = false
                    followMenu.visible = true
                }
            }
            MenuItem{
                id: likeMenu
                visible: !isStory
                text: item.has_liked ? qsTr("Unlike") : qsTr("Like")
                onClicked: {
                    if(!item.has_liked)
                    {
                        instagram.like(item.id)
                    }
                    else
                    {
                        instagram.unLike(item.id)
                    }
                }
            }
            MenuItem {
                id: deleteMenu
                text: qsTr("Remove")
                visible: item.user.pk == app.user.pk
                onClicked: {
                    instagram.deleteMedia(item.id)
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
        if(isStory){
            refreshCallback = null
            followMenu.visible = false
            unFollowMenu.visible = false
        }

        else {
            userLikedThis = item.has_liked;
            refreshCallback = null
            instagram.getComments(item.id);
            if(app.user.pk !== item.user.pk)
            {
                instagram.getFriendship(item.user.pk);
            }
            else
            {
                followMenu.visible = false
                unFollowMenu.visible = false
            }
        }
    }

    Connections{
        target: instagram
        onLikeDataReady:{
            //print(answer)
            var out = JSON.parse(answer)
            if(out.status === "ok")
            {
                item.has_liked = true;
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
                likesCommentsCount.text = item.like_count-1 + " " +qsTr("likes") + " - " + item.comment_count + " " + qsTr("comments")
            }
        }
        onMediaDeleted:{
            pageStack.pop();
        }
    }

    Connections{
        target: instagram
        onMediaCommentsDataReady:{
            var out = JSON.parse(answer)
            commentsRepeater.model = out.comments
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
        onFriendshipDataReady:{
            //print(answer)
            relationStatus = JSON.parse(answer)

            followMenu.visible = !relationStatus.following
            unFollowMenu.visible = relationStatus.following
        }
    }
}
