import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

import "../components"

Page {
    id: page
    allowedOrientations:  Orientation.All

    property var nextMediaUrl: null
    property bool dataLoaded: false
    property string pageTitle : ""
    property bool errorOccurred: false
    property var streamData: null

    property string userId;


    SilicaListView {
        id: listView
        model: mediaModel
        anchors.fill: parent
        header: PageHeader {
            title: pageTitle
        }
        delegate: UserListItem {
            visible: dataLoaded
            item: model
        }

        VerticalScrollDecorator {
        }

        PushUpMenu {
            visible: nextMediaUrl !== null
            MenuItem {
                text: qsTr("Load more")
                onClicked: timerLoadmore.restart()
            }
        }
    }

    Timer {
        id: timerLoadmore
        interval: 500
        running: false
        repeat: false
        onTriggered: getNextMediaData()
    }

    ListModel {
        id: mediaModel
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: dataLoaded == false
        size: BusyIndicatorSize.Large
    }

    ErrorMessageLabel {
        visible: errorOccurred
    }

    Component.onCompleted: {
        if(page.pageTitle === qsTr("Followers"))
        {
            instagram.getFollowers(userId)
        }
        else
        {
            instagram.getFollowing(userId)
        }
    }

    Connections{
        target: instagram
        onFollowingDataReady:{
            mediaDataFinished(answer)
        }

        onFollowersDataReady:{
            mediaDataFinished(answer)
        }
    }

    function mediaDataFinished(answer) {
        var data = JSON.parse(answer)
        for(var i=0; i<data.users.length; i++) {
            mediaModel.append(data.users[i]);
        }
        dataLoaded = true;
    }

    //function getNextMediaData() {
    //}
}
