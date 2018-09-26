import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import harbour.prostogram 1.0
import harbour.prostogram.cache 1.0

import "pages"
import "components"
import "Cover.js" as CoverCtl
import "Storage.js" as Storage
import "FavManager.js" as FavManager
import "MediaStreamMode.js" as MediaStreamMode

ApplicationWindow {
    id: app
    property var cachedFeeds
    property var cachedFeedsTime

    property var refreshCallback
    property bool refreshCallbackPending: false

    property var user
    property bool need_login: true
    property bool try_login: true
    property bool connected

    signal coverRefreshButtonPress();

    allowedOrientations: Orientation.Portrait

    initialPage: getInitialPage()
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    DBusInterface {
        id: networkDBusListener
        bus: DBus.SystemBus
        service: "net.connman"
        path: "/"
        iface: "net.connman.Manager"
        signalsEnabled: true
        Component.onCompleted: getStatus() // Init

        // Methods
        function getStatus() {
            typedCall("GetProperties", [], function(properties) {
                if(properties["State"] == "online") {
                    console.debug("Network connected, loading...");
                    connected = true;
                }
                else {
                    console.debug("Offline!");
                    connected = false;
                }
            },
            function(trace) {
                console.error("Network state couldn't be retrieved: " + trace);
            })
        }

        // Signals
        function propertyChanged(name, value) {
            if(name == "State") {
                if(value == "online") {
                    console.debug("Network connected, reloading...");
                    //webview.reload();
                    connected = true;
                    //instagram.login(true);
                }
                else {
                    console.debug("Offline!");
                    connected = false;
                }
            }
        }
    }

    DBusAdaptor {
        id: dbus

        service: 'org.prostogram.notify'
        iface: 'org.prostogram.notify'
        path: '/org/prostogram/notify'

        xml: '  <interface name="com.prostogram.notify">\n' +
             '    <method name="showPhoto">\n' +
             '      <arg name="mediaId" type="s" direction="in"/>\n' +
             '    </method>\n' +
             '  </interface>\n'

        function showNotifyPage() {
            var page = pageStack.find(function(page){
                return page.objectName === "notificationPage";
            })
            if(page)
            {
                pageStack.pop(page);
                pageStack.replace(Qt.resolvedUrl("pages/NotificationPage.qml"));
            }
            else
            {
                pageStack.push(Qt.resolvedUrl("pages/NotificationPage.qml"));
            }
            app.activate()
        }
    }

    Instagram {
        id: instagram
    }

    CacheImage {
        id: imageCache
    }

    NotificationStream {
        id: notifyStream
    }

    onConnectedChanged: {
        if(connected && try_login) {
            instagram.login(true);
            app.need_login = false;
        }
    }

    function getInitialPage() {
        loadFavTags()
        var username = Storage.get("username");
        var password = Storage.get("password")
        if (username === "" ||  password === "" || username === undefined || password === undefined || username === null || password === null ) {
            app.need_login = true;
        } else {
            instagram.setUsername(username);
            instagram.setPassword(password);
            instagram.login(true);
            app.need_login = false;

        }

        imageCache.init();
        imageCache.clean();

        return Qt.resolvedUrl(Qt.resolvedUrl("pages/LoginPage.qml"))
    }

    function refresh(){
        coverRefreshButtonPress();
    }

    property int streamPreviewColumnCount: 3;
    property int  streamPreviewRowCount : 2;

    property bool  startPageShowPopularFeed : true;
    property bool  feedsShowCaptions : false;
    property bool feedsShowUserDate : true;
    property bool feedsShowUserDateInline : true;


    Component.onCompleted: {
        init();
    }

    Connections {
        target: instagram
        onMediaInfoReady: {
            var out = JSON.parse(answer);
            pageStack.push(Qt.resolvedUrl("pages/MediaDetailPage.qml"),{item: out.items[0]})
        }
        onError: {
            print("Error: " + message)
        }
        onDoLogout: {
            app.need_login = true;
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl(Qt.resolvedUrl("pages/LoginPage.qml")))
        }

    }

    function init() {
        streamPreviewColumnCount = Storage.get("streamPreviewColumnCount", 3);
        streamPreviewRowCount = Storage.get("streamPreviewRowCount", 4);
        startPageShowPopularFeed = parseInt(Storage.get("startPageShowPopularFeed", 1)) === 1;
        feedsShowCaptions = parseInt(Storage.get("feedsShowCaptions", 0)) === 1;
        feedsShowUserDate = parseInt(Storage.get("feedsShowUserDate", 1)) === 1;
        feedsShowUserDateInline = parseInt(Storage.get("feedsShowUserDateInline", 1)) === 1;
    }

    function setCover(coverMode, coverData) {
        CoverCtl.nextMode = coverMode
        CoverCtl.nextCoverData = coverData
        CoverCtl.nextChanged = true
    }

    function setCoverRefresh(coverMode, coverData,refreshMode, refreshTag) {
        CoverCtl.refrMode = refreshMode
        CoverCtl.refrTag = refreshTag
        CoverCtl.nextMode = coverMode
        CoverCtl.nextCoverData = coverData
        CoverCtl.nextChanged = true
    }

    function saveFavTags() {
        var favTagsList = FavManager.favTags.join(';')
        Storage.set("favtags", favTagsList)
    }

    function loadFavTags() {
        var favTagsList = Storage.get("favtags", "")
        FavManager.favTags = favTagsList===""|| favTagsList===null  ? [] : favTagsList.split(";")
        FavManager.favTag = Storage.get("favtag", "")
    }


    onApplicationActiveChanged: {
        if (applicationActive === true) {
            if(refreshCallback !== null && refreshCallbackPending) {
                refreshCallbackPending = false
                refreshCallback()
            }
        }
    }


    ConfigurationGroup {
            id: settings
            path: "/apps/harbour-prostogram/settings"

            property string login: ""
            property string password: ""

            property string styleColorBackground: "white"
            property string styleColorFont: "black"
            property string styleColorLink: "navy";
            property string styleColorButton: "gray";
            property string styleColorInboxGray: styleColorButton;

            function backgroundColor() {
                return styleColorBackground;
            }
            function fontColor() {
                return styleColorFont;
            }
            function linkColor(){
                return styleColorLink;
            }
            function buttonBackgroundColor() {
                return styleColorButton;
            }
            function transparent() {
                return "transparent";
            }
            function inboxFontColor() {
                return styleColorButton;
            }
            function iconColor() {
                return styleColorFont;
            }

            property int tiny: 20;
            property int extra_small: tiny + 4;
            property int small: extra_small + 4;
            property int medium: small + 4;
            property int large: medium + 8;
            property int extra_large: large + 10;
            property int huge: extra_large + 14;

            /*property int tiny: 20;
            property int extra_small: 24;
            property int small: 28;
            property int medium: 32;
            property int large: 40;
            property int extra_large: 50;
            property int huge: 64;*/


            function profileFontSize() {
                return small;
            }
            function profileFollowSize() {
                return extra_small;
            }
            function loginFontSize() {
                return medium;
            }
            function feedFontSize() {
                return small;
            }
            function feedLikeFontSize() {
                return extra_small;
            }
            function inboxFontSize() {
                return small;
            }
            function storyTitleSize() {
                return tiny;
            }

            function notificationFontSize() {
                return tiny + 2;
            }

            property string profile_pic_url
            function getProfilePic() {
                return profile_pic_url;

            }
    }
}
