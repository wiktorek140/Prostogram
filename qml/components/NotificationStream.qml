import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.notifications 1.0

import "../Storage.js" as Storage

Item {
    id: notificationStream

    property int length: 4;

    Notification{
        id: likeNotify

        property string mediaId

        category: "x-nemo.example"
        summary: ""
        body: ""
        itemCount: 4
        remoteActions: [ {
            "name": "default",
                "displayName": "Click to notify",
                "icon": "icon-s-do-it",
                "service": "org.prostogram.notify",
                "path": "/org/prostogram/notify",
                "iface": "org.prostogram.notify",
                "method": "showPhoto",
                "arguments": [ mediaId ]
        }]
    }

    Notification{
        id: commentNotify
        category: "x-nemo.example"
        summary: ""
        body: ""
        remoteActions: [ {
            "name": "default",
                "displayName": "Click to notify",
                "icon": "icon-s-do-it",
                "service": "org.prostogram.notify",
                "path": "/org/prostogram/notify",
                "iface": "org.prostogram.notify",
                "method": "showPhoto",
                "arguments": [ "123" ]
        }]
    }

    Connections{
        target: instagram
        onRecentActivityDataReady:{
            var out = JSON.parse(answer)

            if(out.new_stories.length > 0)
            {
                likeNotify.itemCount = out.new_stories.length;

                for(var i=out.new_stories.length-1; i>=0; i--)
                {
                    var notify = out.new_stories[i];
                    var date = new Date(notify.args.timestamp*1000);

                    var iid = toString(notify.args.timestamp);

                    likeNotify.summary = notify.args.text
                    likeNotify.replacesId = parseInt(iid.replace(".",""));
                    likeNotify.timestamp = date
                    likeNotify.mediaId = notify.args.media && notify.args.media[0].id ? notify.args.media[0].id : ""
                    likeNotify.publish();
                }
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
            instagram.getRecentActivity();
        }
    }
}

