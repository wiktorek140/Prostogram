import QtQuick 2.2
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../components"
import "../Helper.js" as Helper
import "../MediaStreamMode.js" as MediaStreamMode

Page {
    id: explorePage
    allowedOrientations:  Orientation.All

    //property var user
    property string next_id: ""
    property bool dataLoaded: false
    property int recentMediaSize: (width - 2 * Theme.paddingMedium) / 3
    property bool isSearchResult: false
    property bool isTags: false

    Rectangle {
        anchors.fill: parent
        color: "white"
        z:-1
    }

    SilicaFlickable {
        id: allView
        anchors.fill: parent
        contentHeight: column.height + searchField.height + 10
        contentWidth: parent.width

        SearchField {
            id: searchField
            anchors.top: parent.top
            width: parent.width
            color: "black"
            _labelItem.color: "black"
            placeholderColor: "black"
            onTextChanged: {
                timerSearchTags.restart();
            }
        }

        Column {
            id: column
            anchors {
                top: searchField.bottom
                left: parent.left
                right: parent.right
            }
            spacing: Theme.paddingSmall

            BusyIndicator {
                visible: !dataLoaded
                running: visible
                anchors.horizontalCenter: parent.horizontalCenter
            }

            GridView {
                id: exploreGrid
                width: parent.width
                height: allView.height
                cellWidth: width/3
                cellHeight: cellWidth
                clip: true

                //visible: !isSearchResult
                //enabled: !isSearchResult

                anchors {
                    left: parent.left
                    right: parent.right
                }
                model: recentMediaModel

                delegate: Item {
                    width: parent.width / 3
                    height: width

                    MainItemLoader {
                        id: mainLoader
                        anchors.fill: parent
                        width: parent.width
                        preview: true
                        clip: true
                        autoVideoPlay: false
                        isSquared: true
                        property var item: model
                    }

                    MouseArea {
                        id: mousearea
                        anchors.fill: parent
                        onClicked: {
                            if(model.special === 1) {
                                recentMediaModel.remove(model.index);
                                dataLoaded = false;
                                instagram.getExploreFeed(next_id);
                            }
                            else pageStack.push(Qt.resolvedUrl("SingleMediaPage.qml"), {singleItem: model});
                        }
                    }
                }
            }

            Repeater {
                id: searchList
                model: mediaModel
                //anchors.top: searchField.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.topMargin: 75
                visible: isSearchResult
                //enabled: isSearchResult
                delegate: SearchListItem {
                    item: model
                    tag: isTags
                }
            }
        }
    }

    ListModel {
        id: recentMediaModel
    }

    ListModel {
        id: mediaModel
    }

    Component.onCompleted: {
        instagram.getExploreFeed(next_id);
    }

    function searchData() {
        if(searchField.text === "") {
            mediaModel.clear();
            updateAll(false);
            instagram.getExploreFeed(next_id);
            isTags = false;
        }else {
            updateAll(true);
            next_id = "";
            var znacznik = searchField.text.charAt(0);
            if(znacznik == '#'){
                var tag = searchField.text.substring(1,searchField.text.length);
                instagram.searchTags(tag);
                isTags = true;
            }
            else {
                instagram.searchUser(searchField.text);
                isTags = false;
            }
        }
    }

    function updateAll(state){
        isSearchResult = state;
        searchList.visible = state;
        exploreGrid.visible = !state;
        searchList.enabled = state;
        exploreGrid.enabled = !state;

    }

    Timer {
        id: timerSearchTags
        interval: 600
        running: false
        repeat: false
        onTriggered: searchData()
    }

    Connections {
        target: instagram
        onExploreFeedDataReady: {
            var data = JSON.parse(answer);

            for(var i=1; i<data.items.length; i++) {
                recentMediaModel.append(data.items[i].media);
            }
            next_id = data.next_max_id
            dataLoaded=true;

            data.items[0].media_type=1
            data.items[0].special=1
            recentMediaModel.append(data.items[0])
        }

        onSearchTagsDataReady: {
            //print(answer)
            mediaModel.clear();
            recentMediaModel.clear();
            var data  = JSON.parse(answer)

            print("Number of elements: "+ data.results.length)
            for(var i=0; i < data.results.length; i++) {
                mediaModel.append(data.results[i]);
            }

            dataLoaded = true;
            updateAll(true);
        }

        onSearchUserDataReady: {
            //print(answer)
            mediaModel.clear();
            recentMediaModel.clear();
            var user = JSON.parse(answer)

            print("Number of elements: "+ user.users.length)
            for(var i=0; i < user.users.length; i++) {

                mediaModel.append(user.users[i]);
            }

            dataLoaded = true;
            updateAll(true);
        }
    }

}
