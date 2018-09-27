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

    Rectangle {
        id: loginArea

        width: parent.width
        height: parent.height

        color: settings.backgroundColor();

        Rectangle {
            id: logoAction
            visible: !app.need_login

            anchors.fill: parent
            color: "transparent"

            Image {
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
                font.pixelSize: settings.extra_large
                color: settings.fontColor()
                anchors {
                    top: logoImage.bottom
                    topMargin: Theme.paddingMedium
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                id: versionLabel
                text: qsTr("Version: %1").arg(Qt.application.version)
                font.pixelSize: settings.medium
                color: settings.fontColor()

                anchors{
                    top: nameLabel.bottom
                    topMargin: Theme.paddingMedium
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Column {
            id: enterAction

            clip: true
            spacing: Theme.itemSizeSmall / 4 + 1.4
            visible: app.need_login
            width: parent.width * 0.6722
            //height: Theme.itemSizeSmall * 5

            anchors {
                //bottom: parent.bottom
                //bottomMargin: parent.height * 0.0703
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter

            }


            Row {
                id: topBaner
                spacing: 10
                visible: app.need_login
                height: parent.width * 0.1488
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                Image {
                    id: logoProg
                    source: "../images/logo.svg"
                    width: parent.height
                    height: width
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    sourceSize.width: width
                    sourceSize.height: height
                }

                Image {
                    id: logo

                    source: "../images/prostogram.svg"

                    width: parent.width * 0.8
                    height: parent.height
                    anchors{
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.paddingMedium
                    }
                    sourceSize.width: width
                    sourceSize.height: height
                }
            }

            Rectangle {
                id: spacing
                height: 1
                width: parent.width
                anchors.left: parent.left
            }

            Rectangle {

                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                radius: 5

                width: parent.width
                height: Theme.itemSizeSmall * 1.05
                anchors {
                    left: parent.left
                }

                TextInput {
                    id: loginField
                    width: parent.width
                    height: settings.loginFontSize()

                    opacity: 1;
                    color: settings.fontColor()
                    font.pixelSize: settings.loginFontSize();

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 16
                    }

                    Text {
                        text: qsTr("Login");
                        color: "#707070"
                        visible: !loginField.text
                        y: y - 10
                    }
                }
            }

            Rectangle {

                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                radius: 5

                width: parent.width
                height: Theme.itemSizeSmall * 1.05
                anchors {
                    left: parent.left
                }

                TextInput {
                    id: passwordField
                    width: parent.width
                    height: settings.loginFontSize()

                    opacity: 1
                    color: settings.fontColor()
                    font.pixelSize: settings.loginFontSize();
                    echoMode: TextInput.Password

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 16
                    }

                    Text {
                        text: qsTr("Password");
                        color: "#707070"
                        visible: !passwordField.text
                        y: y - 10
                    }
                }
            }

            Rectangle {
                id: loginButton
                width: parent.width
                height: Theme.itemSizeSmall * 1.05
                radius: 5
                color: Theme.highlightBackgroundColor
                anchors {
                    left: enterAction.left
                }

                Text {
                    id: sitext
                    text: qsTr("Sign in")
                    color: Theme.primaryColor
                    width: parent.width
                    height: parent.height / 3 * 2

                    fontSizeMode: Text.Fit
                    minimumPixelSize: 10
                    font.pixelSize: 72

                    anchors {
                        verticalCenter: parent.verticalCenter
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(loginField.text && passwordField.text) {
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

    Connections {
        target: instagram
        onProfileConnected: {
            if(app.need_login) {
                Storage.set("password", passwordField.text);
                Storage.set("username", loginField.text)
            }
            app.try_login = false
            instagram.getInfoById(instagram.getUsernameId());
            instagram.getRecentActivityInbox();
            instagram.getInbox();


        }

        onProfileConnectedFail: {
            banner.notify(qsTr("Login fail!"))
            instagram.logout();
            app.need_login=true;
        }

        onInfoByIdDataReady: {
            var obj = JSON.parse(answer)

            if(obj.user.pk == instagram.getUsernameId()) {
                app.user = obj.user
                pageStack.replace(Qt.resolvedUrl("StartPage.qml"));
            }
        }
    }

    Connections {
        target: app
        onCoverRefreshButtonPress: {
            updateAllFeeds()
        }
    }

    Component.onCompleted: {
        if(!app.need_login) {
            banner.notify(qsTr("Entering..."))
        }
        //print(Theme.itemSizeSmall / 3)
    }
}
