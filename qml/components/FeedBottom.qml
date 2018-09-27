import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

//reworked

Rectangle {
    id: feedBottom
    width: parent.width
    height: childrenRect.height
    color: settings.backgroundColor()

    signal homeClick(var isDouble);

    IconButton {
        property var lClick2
        id: mail
        anchors{
            right: search.left
            rightMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-home?" + (pressed
                     ? Theme.highlightColor
                     : settings.iconColor())
        onClicked: {
            var ncc = Date.now()
            if ((ncc - lClick2) < 500) {
                homeClick(false);
                return;
            }
            lClick2 = ncc

            homeClick(true);
            //pageStack.push(Qt.resolvedUrl("../pages/InboxPage.qml"))

        }
    }
    IconButton {
        id: search
        anchors{
            right: sendPhoto.left
            rightMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-search?" + (pressed
                     ? Theme.highlightColor
                     : settings.iconColor())

        onClicked: pageStack.push(Qt.resolvedUrl("../pages/SearchPage.qml"))
    }

    IconButton {
        id: sendPhoto
        anchors{
            horizontalCenter: parent.horizontalCenter
        }

        icon.source: "image://theme/icon-m-add?" + (pressed
                     ? Theme.highlightColor
                     : settings.iconColor())
        onClicked: {
            var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage")
            imagePicker.selectedContentChanged.connect(function () {
                console.log("IMAGE SELECT:",imagePicker.selectedContent);
                pageStack.push(Qt.resolvedUrl("../pages/EditPhotoPage.qml"),{image_url: imagePicker.selectedContent})
            })
        }
    }

    IconButton {
        id: likes
        anchors {
            left: sendPhoto.right
            leftMargin: (parent.width/5-likes.width)
        }

        icon.source: "../images/notifications.svg"
        icon.width: width * 0.8
        icon.height: height * 0.8
        layer.enabled: true
        layer.effect: ColorOverlay {
            color: settings.iconColor();
        }

        onClicked: pageStack.push(Qt.resolvedUrl("../pages/NotificationPage.qml"));

        Rectangle {
            id: likesCount
            color: "red"
            width: parent.width/2
            height: parent.width/2

            radius: parent.width/2

            anchors{
                top: parent.top
                left: parent.left
            }

            visible: (notifyStream.notifyCount > 0) ? true:  false

            Label{
                id: likeCount
                text: (notifyStream.notifyCount > 99) ? "99+" : notifyStream.notifyCount
                color: settings.backgroundColor()
                font.pixelSize: parent.height/2
                anchors.centerIn: parent
            }
        }
    }

    IconButton {
        id: profile
        anchors{
            left: likes.right
            leftMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-people?" + (pressed
                     ? Theme.highlightColor
                     : settings.iconColor())

        onClicked: pageStack.push(Qt.resolvedUrl(
                                      "../pages/UserProfilPage.qml"), {
                                      user: app.user
                                  })
    }
}
