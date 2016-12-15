import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: feedHeader
    width: parent.width
    height: childrenRect.height
    color: "transparent"

    IconButton {
        id: setPhotoIcon
        anchors{
            left: parent.left
            top: parent.top
        }

        icon.source: "image://theme/icon-m-camera?" + (pressed
                     ? Theme.highlightColor
                     : Theme.primaryColor)
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/CameraPage.qml"))
    }


    Image {
       id: profilpic
       width: parent.height
       height:parent.height
       anchors.right: parent.right
       source: user.profile_pic_url

       anchors{
           right: parent.right
           top: parent.top
       }

       MouseArea {
           anchors.fill: parent
           id: mouseAreaMyProfile
           onClicked: pageStack.push(Qt.resolvedUrl(
                                         "../pages/UserProfilPage.qml"), {
                                         user: user
                                     })
       }
    }

}
