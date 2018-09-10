import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

BackgroundItem {
    id: userInfo

    property var item
    property bool tag: false
    height: parent.width * 0.1852
    width: parent.width
    anchors {
        left: parent.left
        right: parent.right
    }
    Component.onCompleted: {
        if( (typeof item.profile_pic_url) === undefined || (typeof item.profile_pic_url) === "undefined" || tag) {
            profilePicture.source = "../images/tagIcon.png";
            username.text = item.name;
        } else {
            profilePicture.source = item.profile_pic_url;
            username.text = item.username;
        }
    }

    Image {
        id: profilePicture
        anchors.left: parent.left
        anchors.top: parent.top
        height: parent.height
        width: height
        //source: item.profile_pic_url
        layer.enabled: true
        layer.effect: OpacityMask {
            anchors.fill: profilePicture
            maskSource: Rectangle {
                width: profilePicture.height
                height: profilePicture.height
                radius: width
            }
        }
    }

    Label {
        id: username
        anchors.left: profilePicture.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        truncationMode: TruncationMode.Fade
        color: "black"
    }

    onClicked: {
        pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"), {user: item});
    }
}
