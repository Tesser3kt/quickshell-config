import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.config
import qs.components
import qs.components.util
import qs.components.modules.popups

BarItem {
    id: root

    property color iconColor
    property color textColor

    property string app: ""
    property string desc: ""

    readonly property var possibleRegexs: [/[\(\d*\)]*\s*(.+)\s+[-—]\s+(.+)/,]

    readonly property var appsToIcons: {
        "zsh": ""
    }

    function parseWindowTitle() {
        const title = Hyprland.activeToplevel.title;
        console.log(title);
        if (!title)
            return "";

        const titleMatch = title.match(/[\(\d*\)]*\s*(.+)\s+[-—]\s+(.+)/);
        if (!titleMatch)
            return "";

        root.app = titleMatch[2];
        root.desc = titleMatch[1];
    }

    content: BarText {
        id: barText

        text: {
            if (root.app === "" || root.desc === "")
                return Hyprland.activeToplevel.title;

            return `[${root.app}] ${root.desc}`;
        }
        textColor: root.textColor
    }

    HoverHandler {
        id: hoverHandler
    }

    // Watch for active window changes
    Connections {
        target: Hyprland

        function onRawEvent(ev) {
            if (ev.name !== "activewindowv2")
                return;

            root.parseWindowTitle();
        }
    }

    Component.onCompleted: parseWindowTitle()
}
