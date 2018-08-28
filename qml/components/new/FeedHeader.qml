import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {

    id: feedHeader
    width: parent.width
    height: childrenRect.height
    color: "#ffffff"

    IconButton {
        id: photoIcon
        anchors {
            left: parent.left
            top: parent.top
        }
        icon.source: "image://theme/icon-m-camera?" + (pressed
                                                       ? Theme.secondaryHighlightColor
                                                       : Theme.rgba(0,255))
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/CameraPage.qml"))
    }

    Image {
        id: logo

        source: "../images/prostogram.svg"
        width: parent.width-photoIcon.width*4
        height: parent.height*0.6

        anchors.centerIn: feedHeader
        fillMode: Image.PreserveAspectFit

        MouseArea{
            anchors.fill: parent
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
        }
    }

    Image {
        id: profilePicture
        width: parent.height
        height:parent.height

        source: {
            instagram.setProfilePic(app.user.profile_pic_url);
            return app.user.profile_pic_url;}

        anchors{
            right: parent.right
            top: parent.top
        }

        MouseArea {
            anchors.fill: parent
            id: mouseAreaMyProfile
            onClicked: pageStack.push(Qt.resolvedUrl(
                                          "../pages/UserProfilPage.qml"), {
                                          user: app.user
                                      })
        }
    }
}
