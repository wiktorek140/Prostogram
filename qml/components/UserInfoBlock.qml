import QtQuick 2.0
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0


Rectangle {
    id: userInfo
    anchors {
        right: parent.right
        left: parent.left
    }
    height: parent.width * 0.1852
    width: parent.width
    color: settings.backgroundColor()

    Rectangle {
        id: profilePicture

        height: userInfo.height * 0.7
        width: height
        color: "transparent"
        clip: false

        anchors {
            left: userInfo.left
            leftMargin: profilePicture.height * 0.1
            verticalCenter: userInfo.verticalCenter
        }

        Image {
            height: parent.width
            width: parent.height
            source: item.user.profile_pic_url
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
    }

    Label {
        id: username
        text: item.user.username
        anchors{
            left: profilePicture.right
            leftMargin: Theme.paddingMedium
            top: parent.top
            topMargin: userInfo.height * 0.15
        }
        truncationMode: TruncationMode.Fade
        font.pixelSize: settings.feedFontSize()
        font.bold: true
        color: settings.fontColor()
    }

    Label {
        id: createDate
        text: { Qt.formatDateTime(new Date(parseInt(item.taken_at) * 1000),
                  "dd.MM.yy hh:mm"); }

        anchors {
            left: profilePicture.right
            leftMargin: Theme.paddingMedium
            top: username.bottom
        }
        font.pixelSize: settings.feedLikeFontSize()
        color: settings.fontColor()
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"), {user: item.user});
        }
    }
}
