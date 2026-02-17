pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import qs.config
import qs.components
import qs.components.util
import qs.components.modules.popups

Rectangle {
    id: workspacesWrapper

    required property ShellScreen screen

    color: "transparent"
    implicitHeight: Appearance.barHeight
    implicitWidth: workspaceList.width

    property var monitor: {
        const monitors = Hyprland.monitors;
        return monitors.values.filter(mon => mon.name === screen.name)[0] || null;
    }

    property var allWorkspaces: Hyprland.workspaces
    property var workspaces: []
    property int activeWorkspaceIndex: -1
    property real highlightTargetX: 0

    Timer {
        id: refreshTimer
        interval: 10
        repeat: false
        onTriggered: workspacesWrapper.refresh()
    }

    function refresh() {
        // Get this monitor workspaces
        const allWorkspaces = Hyprland.workspaces;
        const thisMonitorWorkspaces = monitor ? allWorkspaces.values.filter(ws => ws.monitor.name === monitor.name) : [];
        workspaces = thisMonitorWorkspaces;

        // Get the active workspace for this monitor
        const monitorActiveWorkspace = monitor ? monitor.activeWorkspace : null;

        let newActiveIndex = -1;

        if (monitorActiveWorkspace && thisMonitorWorkspaces && thisMonitorWorkspaces.length > 0) {
            for (let i = 0; i < thisMonitorWorkspaces.length; i++) {
                if (thisMonitorWorkspaces[i].name === monitorActiveWorkspace.name) {
                    newActiveIndex = i;
                    break;
                }
            }
        }

        activeWorkspaceIndex = newActiveIndex;
        workspaceList.currentIndex = activeWorkspaceIndex;
    }

    // Update highlight target position when currentIndex changes and items are ready
    onActiveWorkspaceIndexChanged: {
        Qt.callLater(updateHighlightPosition);
    }

    function updateHighlightPosition() {
        if (workspaceBgList.currentItem) {
            highlightTargetX = workspaceBgList.currentItem.x;
        }
    }

    ListView {
        id: workspaceList
        z: 1

        implicitWidth: contentWidth
        orientation: ListView.Horizontal

        spacing: BarSettings.workspaces.spacing

        model: workspacesWrapper.workspaces

        delegate: Item {
            id: workspace

            implicitWidth: workspaceItem.width
            implicitHeight: workspaceItem.height

            required property var modelData
            required property int index

            BarItem {
                id: workspaceItem

                implicitWidth: Appearance.barHeight
                implicitHeight: Appearance.barHeight

                backgroundColor: "transparent"
                hoverEnabled: true
                content: workspaceText
            }

            BarText {
                id: workspaceText
                anchors.centerIn: parent

                text: workspace.modelData.name
                textColor: Theme.nord4
                textPixelSize: 16
                bold: true
            }

            TapHandler {
                onTapped: Hyprland.dispatch(`workspace ${workspace.modelData.name}`)
            }
        }
    }

    ListView {
        id: workspaceBgList
        z: 0

        implicitWidth: contentWidth
        orientation: ListView.Horizontal

        spacing: BarSettings.workspaces.spacing

        model: workspacesWrapper.workspaces

        currentIndex: workspaceList.currentIndex
        highlight: highlightActive
        highlightFollowsCurrentItem: false

        delegate: Rectangle {
            z: 0
            radius: Appearance.itemRadius

            implicitWidth: Appearance.barHeight
            implicitHeight: Appearance.barHeight

            color: Theme.nord2
        }
    }

    Component {
        id: highlightActive

        Rectangle {
            z: 999
            radius: Appearance.itemRadius
            x: workspacesWrapper.highlightTargetX
            visible: workspaceBgList.currentIndex >= 0

            implicitWidth: Appearance.barHeight
            implicitHeight: Appearance.barHeight

            color: Theme.nord10

            Behavior on x {
                SpringAnimation {
                    spring: 2
                    damping: 0.3
                    velocity: 400
                }
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(ev) {
            // Refresh on workspace switch, monitor focus change, or workspace creation/deletion/movement
            if (ev.name === "workspace" || ev.name === "focusedMon" || ev.name === "createWorkspace" || ev.name === "destroyWorkspace" || ev.name === "moveWorkspace") {
                refreshTimer.restart();
            }
        }
    }

    Component.onCompleted: refresh()
}
