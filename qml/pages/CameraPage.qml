import QtQuick 2.0
import QtMultimedia 5.5
import Sailfish.Silica 1.0

import "../components"

Page {
    id: cameraPage

    property int cameraId: 0

    PageHeader {
        id: header
        title: qsTr("Set photo")
    }

    Camera {
        id: camera
        deviceId: QtMultimedia.availableCameras[cameraId].deviceId;

        captureMode: Camera.CaptureViewfinder

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        imageCapture {
            onImageSaved: {
                instagram.cropImg(path,videoCrop.width == videoCrop.height)
                pageStack.replace(Qt.resolvedUrl("SendPhotoPage.qml"),{image_url: path})
            }
        }

        onLockStatusChanged: {
            if(lockStatus == Camera.Locked)
            {
                camera.imageCapture.captureToLocation(StandardPaths.pictures+"/"+"prostogram_"+Qt.formatDateTime(new Date(),"yyMMdd_hhmmss")+".jpg")
            }
        }
    }

    VideoOutput {
        id: viewFinder
        source: camera
        width: parent.width
        height: parent.height
        fillMode: VideoOutput.PreserveAspectFit
        clip: true
        focus : visible // to receive focus and capture key events when visible

        Rectangle{
            width: parent.width
            height: (parent.height-videoCrop.height)/2
            color: "#000000"
            opacity: 0.6
            anchors.bottom: videoCrop.top
        }

        Rectangle{
            width: parent.width
            height: (parent.height-videoCrop.height)/2
            color: "#000000"
            opacity: 0.6
            anchors.top: videoCrop.bottom
        }

        Rectangle{
            id: videoCrop
            width: Math.min(cameraPage.width,cameraPage.height)
            height: width
            color: "transparent"
            border.color: "white"
            border.width: 4

            anchors.centerIn: parent
        }

        ClickIcon{
            id: cameraChange

            width: getShot.width/3*2
            height: width
            source: "../images/refresh.svg"
            anchors{
                right: getShot.left
                rightMargin: width
                verticalCenter: getShot.verticalCenter
            }

            visible: QtMultimedia.availableCameras.length > 1;

            onClicked: {
                camera.stop();
                if(cameraId+1 == QtMultimedia.availableCameras.length)
                {
                    cameraId = 0;

                }
                else
                {
                    cameraId++;
                }
                camera.start();
            }
        }

        ClickIcon{
            id: getShot
            width: cameraPage.height/10
            height: width
            source: "../images/camera.svg"
            anchors{
                bottom: parent.bottom
                bottomMargin: width/2
                horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                camera.searchAndLock();
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
                if(videoCrop.width == videoCrop.height)
                {
                    videoCrop.height = videoCrop.width/5*4
                }
                else
                {
                    videoCrop.height = videoCrop.width
                }
            }
        }
    }
}
