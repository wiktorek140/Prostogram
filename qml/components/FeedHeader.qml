import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

//reworked

Rectangle {

    id: feedHeader
    width: parent.width
    height: childrenRect.height
    color: settings.backgroundColor()

    Component.onCompleted: {
        if(!settings.getProfilePic() || settings.getProfilePic() != app.user.profile_pic_url){
            instagram.setProfilePic(app.user.profile_pic_url);
            settings.profile_pic_url = app.user.profile_pic_url;
        }
    }

    IconButton {
        id: photoIcon
        anchors {
            left: parent.left
            top: parent.top
        }
        icon.source: "image://theme/icon-m-camera?" + (pressed
                                                       ? Theme.secondaryHighlightColor
                                                       : settings.iconColor())
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/CameraPage.qml"))
    }

    Image {
        id: logo

        source: "../images/prostogram.svg"
        width: parent.width - photoIcon.width * 4
        height: parent.height * 0.6

        anchors.centerIn: feedHeader
        fillMode: Image.PreserveAspectFit
        layer.enabled: true
        layer.effect: ColorOverlay {
            color: settings.iconColor();
        }


        MouseArea {
            anchors.fill: parent
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
        }
    }

    Image {
        id: profilePicture
        width: parent.height * 0.8
        height: parent.height * 0.8

        source:  "../images/next.svg"

        layer.enabled: true
        layer.effect: ColorOverlay {
            color: settings.iconColor();
        }
        //{instagram.setProfilePic(app.user.profile_pic_url);
        //return app.user.profile_pic_url;}
        anchors {
            right: parent.right
            top: parent.top
            topMargin: parent.height * 0.1
        }

        /*layer.enabled: true
        layer.effect: OpacityMask {
            anchors.fill: profilePicture
            maskSource: Rectangle {
                width: profilePicture.height
                height: profilePicture.height
                radius: width
            }
        }*/

        MouseArea {
            anchors.fill: parent
            id: mouseAreaMyProfile
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/InboxPage.qml"))
            //pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"), {user: app.user})
        }
    }
}
