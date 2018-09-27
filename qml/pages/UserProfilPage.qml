import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0


import "../components"
import "../Helper.js" as Helper
import "../Storage.js" as Storage
import "../MediaStreamMode.js" as MediaStreamMode

Page {

    allowedOrientations:  Orientation.All

    property var user
    //property var recentMediaData

    property bool relationStatusLoaded : false
    property var relationStatus;

    property bool privateProfile : false;
    property bool recentMediaLoaded: false;
    property string next_max_id: "";

    property bool errorAtUserMediaRequestOccurred : false

    property string rel_outgoing_status : "";
    property string rel_incoming_status : "";

    property bool isSelf: false;

    onStatusChanged: {
        if (status === PageStatus.Active) {
            if(app.user.pk === user.pk) {
                isSelf = true;
                followingMenuItem.visible = true
                followersMenuItem.visible = true
                followMenuItem.visible = false
                unFollowMenuItem.visible = false
            }
            else {
                isSelf = false;
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: settings.backgroundColor()
    }

    SilicaFlickable {
        id: allView
        anchors.fill: parent
        contentHeight: column.height + header.height + 10
        contentWidth: parent.width

        onContentYChanged: {
            if(contentHeight - height - contentY < 10 && next_max_id != "" && recentMediaLoaded ) {
                instagram.getUserFeed(user.pk, next_max_id);
                recentMediaLoaded = false;
            }
        }

        PageHeader {
            id: header
            title: user.username
            _titleItem.color: settings.fontColor()

            Image {
                id: privateLabel
                source: "../images/padlock.svg"
                width: parent.height / 4
                height: width
                visible: false
                layer.enabled: true
                layer.effect: ColorOverlay {
                    color: settings.iconColor();
                }
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: header._titleItem.left
                    rightMargin: 10
                }
            }
        }

        Column {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            id: column
            //spacing: Theme.paddingSmall

            UserDetailBlock {}

            Rectangle {
                height: Theme.paddingMedium
                width: parent.width
                anchors.left: parent.left
                color: "transparent"
            }

            Label {
                text: user.full_name
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                color: settings.fontColor()
                truncationMode: TruncationMode.Fade
                font.bold: true
                font.pixelSize: settings.profileFontSize();
                visible: user.full_name !== "" ? true : false
            }

            Label {
                text: user.biography !== undefined ? user.biography : ""
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                font.pixelSize: settings.profileFontSize();
                color: settings.fontColor()
                visible: text!==""
                wrapMode: Text.Wrap
            }

            Label {
                text: getUrl()
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium

                font.pixelSize: settings.profileFontSize();
                color: settings.fontColor()
                visible: text != ""
                truncationMode: TruncationMode.Fade

                function getUrl() {
                    if(!user.external_url || user.external_url == "" || user.external_url == undefined)
                        return "";
                    else return '<a href="'+user.external_url+'">'+user.external_url+'</a>';
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(user.external_url);
                }
            }

            Label {
                id: incomingRelLabel
                text: getOutgoingText()
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                color: settings.fontColor()
                truncationMode: TruncationMode.Fade
                visible: text!==""
                font.pixelSize: settings.profileFollowSize()
                function getOutgoingText() {
                    if(!relationStatus) {
                        return "";
                    }
                    if(relationStatus.following)
                        return qsTr("You follow %1").arg(user.username);
                    if(relationStatus.outgoing_request)
                        return qsTr("You requested to follow %1").arg(user.username);
                    return ""
                }
            }

            Label {
                text: getIncomingText()
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                color: settings.fontColor()
                truncationMode: TruncationMode.Fade
                visible: text != ""
                font.pixelSize: settings.profileFollowSize()

                function getIncomingText() {
                    if(!relationStatus) {
                        return "";
                    }

                    if(relationStatus.followed_by)
                        return qsTr("%1 follows you").arg(user.username);
                    if(relationStatus.incoming_request)
                        return qsTr("%1 requested to follow you").arg(user.username);
                    if(relationStatus.blocking)
                        return qsTr("You blocked %1").arg(user.username)
                    return ""
                }
            }

            BusyIndicator {
                running: visible
                visible: !recentMediaLoaded
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                height: Theme.paddingLarge - 4
                width: parent.width
                anchors.left: parent.left
                color: "transparent"
            }

            Row {
                id: gridHeader
                height: Theme.itemSizeSmall
                width: parent.width
                Rectangle {
                    color: settings.fontColor()
                    opacity: 0.1
                    anchors.fill: gridHeader
                }
                //visible: !privateProfile && !relationStatus.following


                spacing: 1
                Rectangle {
                    width: Screen.width/3
                    height: parent.height
                    color: settings.transparent()
                    ClickIcon {
                        source: "../images/heart.svg"
                        height: gridHeader.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter:  parent.verticalCenter
                        layer.enabled: true
                        layer.effect: ColorOverlay {
                            color: settings.iconColor();
                        }
                        onClicked: {
                            //print("Click MediaStreamPage")
                            pageStack.push(Qt.resolvedUrl("MediaStreamPage.qml"),{mode : MediaStreamMode.USER_MODE,
                                               tag: user.pk, streamTitle: user.username})
                        }
                    }
                }
                Rectangle {
                    width: Screen.width/3
                    height: parent.height
                    color: settings.transparent()
                    ClickIcon {
                        source: "../images/usertagged.svg"
                        height: gridHeader.height * 0.8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter:  parent.verticalCenter
                        layer.enabled: true
                        layer.effect: ColorOverlay {
                            color: settings.iconColor();
                        }
                        onClicked: {
                            //print("Click b")
                            pageStack.push(Qt.resolvedUrl("MediaStreamPage.qml"),{mode : MediaStreamMode.USER_TAGGED_MODE,
                                               tag: user.pk, streamTitle: user.username})
                        }
                    }
                }

                Rectangle {
                    width: Screen.width/3
                    height: parent.height
                    color: settings.transparent()
                    ClickIcon {
                        source: "image://theme/icon-m-mail?" + (pressed? Theme.highlightColor : settings.iconColor())
                        height: gridHeader.height
                        width: height
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            //print("Click c")
                            pageStack.push(Qt.resolvedUrl("../pages/InboxPage.qml"))
                        }
                    }
                }

            }

            GridView {
                id: picGrid
                width: parent.width - 2
                height: cellHeight * (recentMediaModel.count / 3).toFixed(0)
                //contentHeight: allView.height
                cellWidth: width/3
                cellHeight: cellWidth
                clip: true
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 1
                    rightMargin: 1
                }
                model: recentMediaModel
                delegate: Item {
                    property var item: model
                    width: parent.width / 3 - 2
                    height: width

                    MainItemLoader {
                        id: mainLoader
                        anchors.fill: parent
                        //width: parent.width
                        clip: true
                        preview: true
                        autoVideoPlay: false
                        isSquared: true
                    }

                    MouseArea {
                        id: mousearea
                        anchors.fill: parent
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("../pages/SingleMediaPage.qml"), {singleItem: item});
                        }
                    }
                }
            }
        }

        PullDownMenu {
            MenuItem {
                id: logoutItem
                text: qsTr("Logout")
                visible: isSelf
                color: settings.fontColor()
                onClicked: {
                    Storage.set("username", "");
                    Storage.set("password", "");
                    app.need_login = true;
                    instagram.logout();
                }
            }

            MenuItem {
                id: settingItem
                text: qsTr("Setting")
                visible: isSelf
                color: settings.fontColor()
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
            }

            MenuItem {
                id: followersMenuItem
                visible: isSelf
                color: settings.fontColor()
                text:  qsTr("Followers")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("UserListPage.qml"),{pageTitle:qsTr("Followers"), userId: user.pk});
                }
            }

            MenuItem {
                id: followingMenuItem
                visible: isSelf
                color: settings.fontColor()
                text:  qsTr("Following")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("UserListPage.qml"),{pageTitle:qsTr("Following"), userId: user.pk});
                }
            }

            MenuItem {
                id: unFollowMenuItem
                color: settings.fontColor()
                visible: !isSelf && !relationStatus.following
                text:  qsTr("Unfollow %1").arg(user.username)
                onClicked: {
                    instagram.unFollow(user.pk);
                }
            }

            MenuItem {
                id: followMenuItem
                color: settings.fontColor()
                visible: !isSelf &&  relationStatus.following
                text: qsTr("Follow %1").arg(user.username)
                onClicked: {
                    instagram.follow(user.pk);
                }
            }
        }
    }

    ListModel {
        id: recentMediaModel
    }


    Component.onCompleted: {
        instagram.getUserFeed(user.pk)
        instagram.getInfoById(user.pk)

        refreshCallback = null
        if(app.user.pk === user.pk) {
            isSelf = true;
            relationStatus = JSON.parse('{"following": "", "status": "ok"}')
        } else {
            isSelf = false;
            instagram.getFriendship(user.pk);
        }
    }

    function reloadFinished(data) {
        if(data.meta.code === 200) {
            user = data.data;
        } else {
            privateProfile = true;
            privateLabel.visible = true
        }
    }

    Connections {
        target: instagram
        onUserFeedDataReady: {
            recentMediaLoaded = false;
            var data = JSON.parse(answer);
            if(data === undefined || data.items === undefined) {
                recentMediaLoaded=true;
                return;
            }
            for(var i=0; i < data.items.length - 1; i++) {
                recentMediaModel.append(data.items[i]);
            }
            recentMediaModel.append(data.items[data.items.length - 1]);
            if (data.more_available) next_max_id = data.next_max_id;
            else next_max_id = "";
            recentMediaLoaded=true;
        }
        onInfoByIdDataReady: {
            var out = JSON.parse(answer);
            user = out.user
        }
        onFollowDataReady: {
            relationStatusLoaded = false;
            instagram.getFriendship(user.pk);
        }
        onUnfollowDataReady: {
            relationStatusLoaded = false;
            instagram.getFriendship(user.pk);
        }
        onFriendshipDataReady: {
            relationStatus = JSON.parse(answer)
            if(!isSelf) {
                followMenuItem.visible = !relationStatus.following
                unFollowMenuItem.visible = relationStatus.following
            } else {
                followMenuItem.visible = false
                unFollowMenuItem.visible = false
            }

            if(relationStatus.is_private) {
                privateLabel.visible = true
                privateProfile = true;
            } else privateLabel.visible = false

            relationStatusLoaded = true;
        }
    }
}
