import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: editPhotoPage

    property string image_url
    property bool squared

    PageHeader {
        id: header
        title: qsTr("Edit photo")
    }

    Item{
        width: parent.width
        height: childrenRect.height

        anchors.top: header.bottom

        Image {
            id: mainImage
            source: editPhotoPage.image_url
            width: parent.width

            fillMode: Image.PreserveAspectFit
            clip: true
            focus : visible // to receive focus and capture key events when visible

            Rectangle{
                id: topSpace
                width: parent.width
                height: imageCrop.y
                color: "#000000"
                opacity: 0.6
                anchors.bottom: imageCrop.top
            }

            Rectangle{
                width: parent.width
                height: mainImage.height-topSpace.height-imageCrop.height
                color: "#000000"
                opacity: 0.6
                anchors.top: imageCrop.bottom
            }

            Rectangle{
                id: imageCrop
                width: Math.min(editPhotoPage.width,editPhotoPage.height)
                height: width
                color: "transparent"
                border.color: "white"
                border.width: 4
                smooth: true

                y: (mainImage.height-imageCrop.height)/2

                MouseArea {
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: mainImage.height-imageCrop.height
/*                    onPositionChanged: {

                        console.log("s:",(mainImage.sourceSize.height/mainImage.height)*imageCrop.y);

                    }*/
                }
            }
        }
    }

    ClickIcon{
        id: getShot
        width: editPhotoPage.height/10
        height: width
        source: "../images/camera.svg"
        anchors{
            bottom: editPhotoPage.bottom
            bottomMargin: width/2
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            var out_img = StandardPaths.pictures+"/"+"prostogram_"+Qt.formatDateTime(new Date(),"yyMMdd_hhmmss")+".jpg"
            instagram.cropImg(image_url,
                              out_img,
                              (mainImage.sourceSize.height/mainImage.height)*imageCrop.y,
                              imageCrop.width===imageCrop.height);

            pageStack.replace(Qt.resolvedUrl("SendPhotoPage.qml"),{image_url: out_img})
        }
    }

    ClickIcon{
        id: changeCrop
        width: getShot.width/3*2
        height: width
        source: "../images/crop.svg"
        anchors{
            left: getShot.right
            leftMargin: width
            verticalCenter: getShot.verticalCenter
        }

        onClicked: {
            if(imageCrop.width == imageCrop.height)
            {
                imageCrop.height = imageCrop.width/5*4
            }
            else
            {
                imageCrop.height = imageCrop.width
            }
        }
    }
}
