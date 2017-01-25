import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {

    id: aboutPage
    allowedOrientations:  Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        VerticalScrollDecorator {}

        contentHeight: contentColumn.y + contentColumn.height

        PageHeader {
            id: header
            title: qsTr("About")
        }

        Column {
            id: contentColumn
            spacing: 4

            anchors {
                top: header.bottom;
                topMargin: Theme.paddingMedium;
                left: parent.left;
                right: parent.right;
            }

            Label {
                text : qsTr("An unofficial client for Instagram.")
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                wrapMode: Text.WordWrap
            }

            Label {
                text : qsTr("Version: %1").arg(Qt.application.version)
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                wrapMode: Text.WordWrap
            }

            SectionHeader {
                text: qsTr("developer")
            }

            Label {
                text : "Chupligin Sergey"
                wrapMode: Text.WordWrap
                color: Theme.primaryColor
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
            }

            Row
            {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                height:  buttonTwitter.height

                Image {
                    id: imageTwitter
                    width:  buttonTwitter.height
                    height: buttonTwitter.height
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    source: "twitter.png"

                }

                Button {
                    id: buttonTwitter
                    text: "@neochapay"
                    onClicked: Qt.openUrlExternally("https://twitter.com/neochapay")
                }

            }


            Row
            {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                height:  buttonMail.height

                Image {
                    id: imageMail
                    width:  buttonMail.height
                    height: buttonMail.height
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    source: "mail.png"

                }

                Button {
                    id: buttonMail

                    text: qsTr("Write a mail")
                    onClicked: Qt.openUrlExternally("mailto:neochapay@gmail.com")
                }

            }

            SectionHeader {
                text: qsTr("License")
            }

            Label {
                text : qsTr("Source code is licensed under the MIT License (MIT).")
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium
                wrapMode: Text.WordWrap
            }

            SectionHeader {
                text: qsTr("Contribute")
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                height: button1.height

                Button {
                    anchors.bottom: parent.bottom
                    text: qsTr("Report bugs")
                    onClicked: Qt.openUrlExternally("https://github.com/neochapay/Prostogram/issues")
                }
            }

            Row
            {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                height:  button1.height
                Button {
                    id: button1
                    anchors.bottom: parent.bottom
                    width: parent.width
                    text: qsTr("Paypal USD")
                    onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CD7MEFDNKNM9E")
                }
            }
        }
    }
    Component.onCompleted: {
        refreshCallback = null
    }
}


