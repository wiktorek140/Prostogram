import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: userInfo
    anchors{
        right: parent.right
        bottomMargin: userInfo.height*0.1
    }

    height: 100
    width: parent.width
    color: "transparent"

    Rectangle{
        id: profilpicture

        height: userInfo.height*0.9
        width: height

        radius: width

        color: "transparent"
        clip: true

        anchors{
            left: userInfo.left
            leftMargin: userInfo.height*0.1
            verticalCenter: userInfo.verticalCenter
        }

        Image {
            height: parent.width
            width: parent.height
            source: item.user.profile_pic_url
        }
    }

    Label {
        id:username
        text: item.user.username
        anchors{
            left: profilpicture.right
            leftMargin: Theme.paddingMedium
            verticalCenter: userInfo.verticalCenter
        }
        truncationMode: TruncationMode.Fade
        font.pixelSize: Theme.fontSizeSmall
        font.bold: true
        color: Theme.secondaryHighlightColor
    }

    Label {
        text: Qt.formatDateTime(
                  new Date(parseInt(item.created_time) * 1000),
                  "dd.MM.yy hh:mm")
        anchors.right: profilpicture.left
        anchors.rightMargin: Theme.paddingMedium
        anchors.top: username.bottom

        truncationMode: TruncationMode.Fade
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.secondaryHighlightColor
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: {
            //Need to be removed because cannot accec to  profile if it isn't video
            //if(playVideo && item.media_type === 2 ) {video.stop();}
            pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"),{user:item.user});
        }
    }
}
