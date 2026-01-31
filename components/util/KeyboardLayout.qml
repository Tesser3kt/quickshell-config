pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string keyboardName: ""
    property string layoutName: ""
    property int activeIndex: 0

    // Short layout name for bar display
    property string layoutShort: {
        const s = layoutName;
        if (!s)
            return "";
        if (s.includes("US"))
            return "US";
        if (s.includes("Czech"))
            return "CZ";

        return s;
    }

    // Listen for layout changes
    Connections {
        target: Hyprland

        function onRawEvent(ev) {
            if (ev.name !== "activelayout")
                return;

            root.refresh();
        }
    }

    // Switch layout
    function switchLayout(cmd, device = "current") {
        hyprctl.command = ["hyprctl", "switchxkblayout", device, String(cmd)];
        hyprctl.running = true;
    }

    // Helper functions
    function next(device = "current") {
        switchLayout("next", device);
    }
    function prev(device = "current") {
        switchLayout("prev", device);
    }
    function setIndex(i, device = "current") {
        switchLayout(String(i), device);
    }

    // Refresh current layout
    function refresh() {
        hyprctlDevices.running = true;
    }

    // Processes
    Process {
        id: hyprctl
        running: false
    }

    Process {
        id: hyprctlDevices
        command: ["hyprctl", "devices", "-j"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const obj = JSON.parse(this.text);
                    const kb = (obj.keyboards || []).find(k => k.main) || (obj.keyboards || [])[0];
                    if (kb) {
                        root.keyboardName = kb.name || "";
                        root.layoutName = kb.active_keymap || "";
                        root.activeIndex = parseInt(kb.active_layout_index) || 0;
                    }
                } catch (e) {
                    // do nothing
                }
            }
        }
    }

    Component.onCompleted: {
        refresh();
    }
}
