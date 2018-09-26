import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {

    onAccepted: {
        settings.tiny = parseInt(size_base.text);
        settings.styleColorFont = color_font.text;
        settings.styleColorBackground = color_bg.text;
        settings.styleColorLink = color_link.text;
        settings.styleColorButton = color_button.text;
    }



    SilicaFlickable {
        anchors.fill: parent
        contentHeight: settingsColumn.height

        VerticalScrollDecorator {}

        Column {
            id: settingsColumn
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader {
                title: qsTr("Settings")
                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }

            SectionHeader{ text: qsTr("Predefined themes") }

            ComboBox {
                id: predefinedTheme
                label: qsTr("Theme. NOT IMPLEMENTED")
                currentIndex: 0
                menu: ContextMenu {
                    MenuItem { text: "NOT IMPLEMENTED" }
                }
            }

            /*TextSwitch {
                id: notifyRequests
                text: qsTr("SomeSetting")
                checked: settings.notifyRequests
                description: qsTr("%1 will send you notifications when getting a friend request.").arg("Sailbook")
            }*/

            SectionHeader{ text: qsTr("Colors (text/#rgb)") }

            TextField {
                id: color_font
                width: parent.width
                placeholderText: qsTr("Font Color")
                label: qsTr("Font Color")
                text: settings.styleColorFont
            }

            TextField {
                id: color_bg
                width: parent.width
                placeholderText: qsTr("Backgorund Color")
                label: qsTr("Backgorund Color")
                text: settings.styleColorBackground
            }

            TextField {
                id: color_link
                width: parent.width
                placeholderText: qsTr("Links Color")
                label: qsTr("Links Color")
                text: settings.styleColorLink
            }

            TextField {
                id: color_button
                width: parent.width
                placeholderText: qsTr("Color")
                label: qsTr("Buttons/messages Color")
                text: settings.styleColorButton
            }

            SectionHeader{ text: qsTr("Font Size") }

            TextField {
                id: size_base
                width: parent.width
                placeholderText: qsTr("Size")
                label: qsTr("Base Font Size. Will Increase All Font!")
                text: settings.tiny
            }
        }
    }
}
