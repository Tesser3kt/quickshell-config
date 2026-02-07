pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int days: -1
    property int hours: -1
    property int minutes: -1

    function refresh() {
        parseUptime.running = true;
    }

    Process {
        id: parseUptime
        command: ["uptime"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const uptimeWithDays = this.text.match(/up\s+(\d+)\s+days,\s+(\d+):(\d+)/);
                if (uptimeWithDays) {
                    root.days = parseInt(uptimeWithDays[1]);
                    root.hours = parseInt(uptimeWithDays[2]);
                    root.minutes = parseInt(uptimeWithDays[3]);
                    return;
                }

                // 0 days of uptime.
                const uptimeWithoutDays = this.text.match(/up\s+(\d+):(\d+)/);
                if (uptimeWithoutDays) {
                    root.days = 0;
                    root.hours = parseInt(uptimeWithoutDays[1]);
                    root.minutes = parseInt(uptimeWithoutDays[2]);
                    return;
                }
            }
        }
    }

    Component.onCompleted: refresh()
}
