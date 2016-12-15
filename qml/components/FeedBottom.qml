import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: feedBottom
    width: parent.width
    height: childrenRect.height

    color: "transparent"

    IconButton{
        id: mail
        anchors{
            right: search.left
            rightMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-mail?" + (pressed
                     ? Theme.highlightColor
                     : Theme.primaryColor)
    }

    IconButton{
        id: search
        anchors{
            right: sendPhoto.left
            rightMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-search?" + (pressed
                     ? Theme.highlightColor
                     : Theme.primaryColor)

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
                     : Theme.primaryColor)
        onClicked: {
            var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage")
            imagePicker.selectedContentChanged.connect(function () {
                pageStack.push(Qt.resolvedUrl("SendPhotoPage.qml"),{image_url: imagePicker.selectedContent})
            })
        }
    }

    IconButton{
        id: likes
        anchors{
            left: sendPhoto.right
            leftMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-like?" + (pressed
                     ? Theme.highlightColor
                     : Theme.primaryColor)

        onClicked: pageStack.push(Qt.resolvedUrl("../pages/NotificationPage.qml"));

        Rectangle{
            id: likesCount
            color: "red"
            width: childrenRect.width
            height: parent.width/2

            radius: parent.width/2

            anchors{
                top: parent.top
                left: parent.left
            }

            visible: (notifyStream.notifyCount) ? true:  false

            Label{
                text: notifyStream.notifyCount
                color: "white"
                font.pixelSize: parent.width/2
                anchors.centerIn: parent
            }
        }
    }

    IconButton{
        id: profile
        anchors{
            left: likes.right
            leftMargin: (parent.width/5-likes.width)
        }

        icon.source: "image://theme/icon-m-people?" + (pressed
                     ? Theme.highlightColor
                     : Theme.primaryColor)

        onClicked: pageStack.push(Qt.resolvedUrl(
                                      "../pages/UserProfilPage.qml"), {
                                      user: user
                                  })
    }
}
