import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: feedBottom
    width: parent.width
    height: childrenRect.height

    color: "white"
    IconButton{
        id: mail
        anchors{
            right: search.left
            rightMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-mail?" + (pressed
                     ? Theme.highlightColor
                     : "black")
        onClicked: {
            onClicked: pageStack.push(Qt.resolvedUrl(
                                          "../pages/InboxPage.qml"))
        }
    }

    IconButton{
        id: search
        anchors{
            right: sendPhoto.left
            rightMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-search?" + (pressed
                     ? Theme.highlightColor
                     : "black")

        onClicked: pageStack.push(Qt.resolvedUrl(
                                      "../pages/TagSearchPage.qml"), {
                                      user: user
                                  })
    }

    IconButton {
        id: sendPhoto
        anchors{
            horizontalCenter: parent.horizontalCenter
        }

        icon.source: "image://theme/icon-m-add?" + (pressed
                     ? Theme.highlightColor
                     : "black")
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
        anchors{
            left: sendPhoto.right
            leftMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-like?" + (pressed
                     ? Theme.highlightColor
                     : "black")

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
                color: "white"
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
                     : "black")

        onClicked: pageStack.push(Qt.resolvedUrl(
                                      "../pages/UserProfilPage.qml"), {
                                      user: app.user
                                  })
    }
}
