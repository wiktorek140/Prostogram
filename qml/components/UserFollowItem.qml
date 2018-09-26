import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0


BackgroundItem {
    id: userInfo

    property var item

    height: parent.width * 0.19
    width: parent.width

    Image {
        id: profilePicture
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingSmall
        anchors.bottomMargin: Theme.paddingSmall
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: height
        source: item.profile_pic_url
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: profilePicture.width
                height: profilePicture.height
                Rectangle {
                    anchors.centerIn: parent
                    width: profilePicture.width
                    height: profilePicture.height
                    radius: width
                }
            }
        }
    }

    Label {
        id:username
        text: item.username
        anchors.left: profilePicture.right
        anchors.leftMargin: Theme.paddingLarge
        anchors.verticalCenter: parent.verticalCenter
        truncationMode: TruncationMode.Fade
        color: settings.fontColor()
    }

    onClicked: {
        pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"),{user: item});
    }
}
