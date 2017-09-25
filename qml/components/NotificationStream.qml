import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.notifications 1.0

import "../Storage.js" as Storage

Item {
    id: notificationStream

    property int notifyCount: 0

    Notification{
        id: likeNotify

        category: "x-nemo.example"
        summary: ""
        body: ""
        itemCount: 1
        remoteActions: [ {
            "name": "default",
                "displayName": "Click to notify",
                "icon": "icon-s-do-it",
                "service": "org.prostogram.notify",
                "path": "/org/prostogram/notify",
                "iface": "org.prostogram.notify",
                "method": "showNotifyPage"
        }]

        onClicked: {
            notifyCount = 0;
        }

    }

    Connections{
        target: instagram
        onRecentActivityInboxDataReady:{
            var out = JSON.parse(answer)

            if(out.new_stories.length > 0)
            {
                var date = new Date();
                notifyCount += out.new_stories.length;

                likeNotify.itemCount = notifyCount;
                likeNotify.summary = "You have "+notifyCount+" notifys"
                likeNotify.timestamp = date
                likeNotify.publish();
            }

            if(!refreshTimer.running)
            {
                refreshTimer.start();
            }
        }
    }

    Timer{
        id: refreshTimer
        running: false
        repeat: true
        interval: 30000
        onTriggered: {
            instagram.getRecentActivityInbox();
        }
    }
}

