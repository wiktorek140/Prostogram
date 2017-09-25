import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

import "../Storage.js" as Storage

import "../components/"

Page {
    id: coverPage

    Banner{
        id: banner
        z: 1000
    }

    Rectangle{
        id: loginArea

        width: parent.width
        height: parent.height

        Image{
            id: backImage
            width: parent.width
            height: parent.height

            source: "../images/cover.jpg"

            fillMode: Image.PreserveAspectCrop

            clip: true
        }

        Rectangle{
            id: logoAction
            visible: !app.need_login

            anchors.fill: parent
            color: "transparent"

            Image{
                id: logoImage
                source: "../images/logo.svg"
                width: (coverPage.width > coverPage.height) ? coverPage.height/3 : coverPage.width/3
                height: width

                anchors{
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                sourceSize.width: width
                sourceSize.height: height
            }

            Label{
                id: nameLabel
                text: "Prostogram"
                font.pixelSize: Theme.fontSizeExtraLarge

                anchors{
                    top: logoImage.bottom
                    topMargin: Theme.paddingMedium
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label{
                id: versionLabel
                text: qsTr("Version: %1").arg(Qt.application.version)
                font.pixelSize: Theme.fontSizeMedium

                anchors{
                    top: nameLabel.bottom
                    topMargin: Theme.paddingMedium
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle{
            id: entherAction
            color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
            clip: true
            radius: 5

            visible: app.need_login

            width: parent.width-0.25*parent.width
            height: Theme.itemSizeMedium*3

            anchors{
                bottom: parent.bottom
                bottomMargin: 0.125*parent.width
                left: parent.left
                leftMargin: 0.125*parent.width
            }

            TextField{
                id: loginField
                width: parent.width-10
                height: Theme.itemSizeMedium

                placeholderText: qsTr("Login")
                placeholderColor: Theme.primaryColor
                color: Theme.primaryColor

                anchors{
                    top: parent.top
                    left: parent.left
                    leftMargin: 5
                }
            }

            TextField{
                id: passwordField
                width: parent.width-10
                height: Theme.itemSizeMedium

                placeholderText: qsTr("Password")
                placeholderColor: Theme.primaryColor
                color: Theme.primaryColor

                echoMode: TextInput.Password

                anchors{
                    top: loginField.bottom
                    left: parent.left
                    leftMargin: 5
                }
            }

            Rectangle{
                id: loginButton
                width: parent.width
                height: Theme.itemSizeMedium
                radius: 5

                color: Theme.highlightBackgroundColor

                anchors{
                    bottom: parent.bottom
                    left: parent.left
                }

                Text{
                    text: qsTr("Sign in")
                    color: Theme.primaryColor
                    width: parent.width
                    height: parent.height/3*2

                    fontSizeMode: Text.Fit
                    minimumPixelSize: 10
                    font.pixelSize: 72

                    anchors{
                        verticalCenter: parent.verticalCenter
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle{
                    color: parent.color
                    width: parent.radius
                    height: parent.radius
                    anchors{
                        top: parent.top
                        left: parent.left
                    }
                }

                Rectangle{
                    color: parent.color
                    width: parent.radius
                    height: parent.radius
                    anchors{
                        top: parent.top
                        right: parent.right
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(loginField.text && passwordField.text)
                        {
                            instagram.setUsername(loginField.text);
                            instagram.setPassword(passwordField.text);
                            instagram.login(true);
                            banner.notify(qsTr("Login..."))
                        }
                    }
                }
            }
        }
    }

    Connections{
        target: instagram
        onProfileConnected:{
            if(app.need_login)
            {
                Storage.set("password", passwordField.text);
                Storage.set("username",loginField.text)
            }
            instagram.getInfoById(instagram.getUsernameId());
            instagram.getRecentActivityInbox();
            instagram.getInbox();
        }

        onProfileConnectedFail:{
            banner.notify(qsTr("Login fail!"))
            instagram.logout();
        }

        onInfoByIdDataReady: {
            //print(answer)
            var obj = JSON.parse(answer)

            if(obj.user.pk == instagram.getUsernameId())
            {
                app.user = obj.user
                pageStack.replace(Qt.resolvedUrl("StartPage.qml"));
            }
        }
    }

    Connections{
        target: app
        onCoverRefreshButtonPress:{
            updateAllFeeds()
        }
    }

    Component.onCompleted: {
        if(!app.need_login)
        {
            banner.notify(qsTr("Entering..."))
        }

    }
}
