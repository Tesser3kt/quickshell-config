import Quickshell.Io
import QtQuick
import qs.components
import qs.components.modules.popups
import qs.components.util

BarItem {
    id: root

    property color iconColor
    property color textColor

    padding: JsonObject {
        property int left: 12
        property int right: 12
        property int top: 2
        property int bottom: 2
    }

    property bool inhibited: false

    content: BarText {
        id: barText

        iconPixelSize: 24

        icon: root.inhibited ? "󰔡" : "󰨙"
        iconColor: root.iconColor
    }

    TapHandler {
        id: tapHandler
        onTapped: {
            if (root.inhibited) {
                idleUninhibit.running = true;
                root.inhibited = false;
            } else {
                idleInhibit.running = true;
                root.inhibited = true;
            }
        }
    }

    Process {
        id: idleInhibit
        command: ["systemctl", "--user", "stop", "hypridle.service"]
        running: false
    }

    Process {
        id: idleUninhibit
        command: ["systemctl", "--user", "start", "hypridle.service"]
        running: false
    }
    
    // Refresh uptime on hover. For some reason is needed...
    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                Uptime.refresh();
            }
        }
    }

    UptimePopup {
        id: uptimePopup

        anchorItem: root
        hoverAnchor: hoverHandler.hovered
    }
}
