import QtQuick 2.0

import org.nemomobile.notifications 1.0

import "../Storage.js" as Storage

Item {
    id: notificationStream

    property int length: 4;

    Notification{
        id: likeNotify
        category: "x-nemo.example"
        summary: ""
        body: ""
        onClicked: {}
        itemCount: 4
    }

    Notification{
        id: commentNotify
        category: "x-nemo.example"
        summary: ""
        body: ""
        onClicked: {}
        itemCount: 4
    }

    Connections{
        target: instagram
        onRecentActivityDataReady:{
            var out = JSON.parse(answer)
            if(out.new_stories.length > 0)
            {
                for(var i=out.new_stories.length; i === 0; i--)
                {
                    var notify = out.new_stories[i];
                    if(notify.count.likes > 0)
                    {
                        likeNotify.summary = notify.args.text
                        likeNotify.body = '<img src="'+notify.args.media.image+'">"';
                        likeNotify.publish();
                    }
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

