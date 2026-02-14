import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs.config
import qs.components
import qs.components.util
import qs.components.modules.popups

BarItem {
    id: root

    property color iconColor
    property color textColor

    property string activeTitle: ""
    property string activeClass: ""
    property int activePid: 0
    property var allWindows: []

    readonly property var regexByClass: {
        "zen": /(.+)\s+—\s+.+/,
        "firefox-beta": /(.+)\s+—\s+.+/,
        "Alacritty": /^(.*?)(?:\s+-\s+.*)?$/,
        "vesktop": /^(?:Discord\s*\|\s*(.*)|(.*))$/,
        "org.pwmt.zathura": /(.*)/,
        "sioyek": /(.*)/,
        "org.qbittorrent.qBittorrent": /(.*)/,
        "gimp": /(.*)/,
        "code": /^(.*?(?:\s+-\s+.*)?)\s+-\s+Visual Studio Code$/,
        "Spotify": /(.*)/,
        "brave-browser": /^(.*?)(?:\s+-\s+.*)?$/,
        "thunar": /^(.*?)(?:\s+-\s+.*)?$/,
        "fr.handbrake.ghb": /(.*)/,
        "org.inkscape.Inkscape": /^(.*?)(?:\s+-\s+.*)?$/,
        "org.kde.gwenview": /(.+)\s+—\s+.+/,
        "ONLYOFFICE": /(.*)/,
        "vlc": /(.*)/,
        "whatsapp-electron": /^(?:.*?)\s+::\s+(.*)?$/
    }

    readonly property var classToIcon: {
        "zen": "󰈹",
        "firefox-beta": "󰈹",
        "Alacritty": "",
        "vesktop": "󰙯",
        "org.pwmt.zathura": "󰈙",
        "sioyek": "󰈙",
        "org.qbittorrent.qBittorrent": "",
        "gimp": "󰋩",
        "code": "󰅨",
        "Spotify": "󰓇",
        "brave-browser": "",
        "thunar": "",
        "fr.handbrake.ghb": "",
        "org.inkscape.Inkscape": "󰋩",
        "org.kde.gwenview": "󰋩",
        "ONLYOFFICE": "󰏆",
        "vlc": "󰕼",
        "whatsapp-electron": "󰖣"
    }

    function parseWindowTitle(windowClass, windowTitle) {
        const regex = regexByClass[windowClass] || /(.*)/;

        const windowTitleMatch = windowTitle.match(regex);
        if (!windowTitleMatch)
            return "";

        if (!windowTitleMatch[1]) {
            if (!windowTitleMatch[2]) {
                return "";
            }

            return windowTitleMatch[2];
        }

        return windowTitleMatch[1];
    }

    function getExcerpt(text) {
        if (text.length > 30)
            return text.slice(0, 28) + "...";

        return text;
    }

    function getAllWindows() {
        AllWindows.refresh();
    }

    function updateWindowsList() {
        let allWindows = AllWindows.allWindows;

        let newWindowsList = [];
        for (let i = 0; i < allWindows.length; i++) {
            let windowData = allWindows[i];
            if (!windowData.address || !windowData.class || !windowData.title || !windowData.pid)
                continue;

            let newWindowData = {
                address: windowData.address,
                workspace: windowData.workspace,
                monitor: windowData.monitor,
                class: windowData.class,
                title: root.getExcerpt(root.parseWindowTitle(windowData.class, windowData.title)),
                icon: root.classToIcon[windowData.class] || "󰣆",
                pid: windowData.pid,
                active: windowData.pid === root.activePid
            };
            newWindowsList.push(newWindowData);
        }

        root.allWindows = newWindowsList;
    }

    content: BarText {
        id: barText

        icon: root.classToIcon[root.activeClass] || "󰣆"
        text: {
            const fullText = root.parseWindowTitle(root.activeClass, root.activeTitle);
            return root.getExcerpt(fullText);
        }

        iconColor: root.iconColor
        textColor: root.textColor

        iconPixelSize: 18
    }

    HoverHandler {
        id: hoverHandler
    }

    WindowsPopup {
        id: windowsPopup

        allWindows: root.allWindows

        anchorItem: root
        hoverAnchor: hoverHandler.hovered
    }

    // Watch for active window changes
    Connections {
        target: Hyprland

        function onRawEvent(ev) {
            if (ev.name !== "activewindowv2")
                return;

            activeWindow.running = true;
        }
    }

    Connections {
        target: AllWindows

        function onAllWindowsChanged() {
            root.updateWindowsList();
        }
    }

    onActivePidChanged: {
        root.updateWindowsList();
    }

    // Get active window class and title
    Process {
        id: activeWindow
        command: ["hyprctl", "activewindow"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (!this.text || this.text === "")
                    return;

                const lines = this.text.split("\n");

                for (const line of lines) {
                    if (line.includes("class")) {
                        root.activeClass = line.split(":")[1].trim() || "";
                    } else if (line.includes("title")) {
                        const titleRegex = /^[^:]*:\s*(.*)$/;
                        const titleMatch = line.match(titleRegex);

                        if (!titleMatch) {
                            root.activeTitle = "";
                            return;
                        }

                        root.activeTitle = titleMatch[1];
                    } else if (line.includes("pid")) {
                        root.activePid = parseInt(line.split(":")[1].trim()) || 0;
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        activeWindow.running = true;
        getAllWindows();
    }
}
