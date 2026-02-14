pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property var allWindows: []

    function refresh() {
        getAllWindows.running = true;
    }

    Process {
        id: getAllWindows
        command: ["hyprctl", "clients"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text || this.text === "")
                    return;

                const lines = this.text.split("\n");
                let currentWindow = {};
                let allWindows = [];

                for (const line of lines) {
                    const trimmedLine = line.trim();

                    // Read address
                    if (trimmedLine.includes("Window")) {
                        currentWindow = {};
                        const address = trimmedLine.split(" ")[1].trim();
                        currentWindow.address = address;
                    } else

                    // Read workspace
                    if (trimmedLine.includes("workspace")) {
                        const workspaceMatch = trimmedLine.match(/^workspace:\s+(\d+)(?:\s+\((\d+)\))?$/);
                        currentWindow.workspace = workspaceMatch ? parseInt(workspaceMatch[1]) : 0;
                    } else

                    // Read monitor
                    if (trimmedLine.includes("monitor")) {
                        const monitorMatch = trimmedLine.match(/^monitor:\s+(\d+)$/);
                        currentWindow.monitor = monitorMatch ? parseInt(monitorMatch[1]) : 0;
                    } else

                    // Read class
                    if (trimmedLine.includes("class")) {
                        const classMatch = trimmedLine.match(/^class:\s+(.+)$/);
                        currentWindow.class = classMatch ? classMatch[1] : null;
                    } else

                    // Read title
                    if (trimmedLine.includes("title")) {
                        const titleMatch = trimmedLine.match(/^title:\s+(.+)$/);
                        currentWindow.title = titleMatch ? titleMatch[1] : null;
                    } else

                    // Read PID
                    if (trimmedLine.includes("pid")) {
                        const pidMatch = trimmedLine.match(/^pid:\s+(\d+)$/);
                        currentWindow.pid = pidMatch ? parseInt(pidMatch[1]) : 0;

                        allWindows.push(currentWindow);
                    }
                }

                root.allWindows = allWindows;
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(ev) {
            if (ev.name !== "openwindow" && ev.name !== "closewindow" && ev.name !== "windowtitle")
                return;

            root.refresh();
        }
    }

    Component.onCompleted: refresh()
}
