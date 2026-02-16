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

    ListView {
        id: workspaceList
        z: 1

        implicitWidth: contentWidth
        orientation: ListView.Horizontal

        spacing: BarSettings.workspaces.spacing

        property ShellScreen screen: workspacesWrapper.screen
        property var monitor: {
            const monitors = Hyprland.monitors;
            return monitors.values.filter(mon => mon.name === screen.name)[0] || null;
        }
        property var workspaces: {
            const allWorkspaces = Hyprland.workspaces;
            return monitor ? allWorkspaces.values.filter(ws => ws.monitor.name === monitor.name) : null;
        }
        property var focusedWorkspace: Hyprland.focusedWorkspace

        onFocusedWorkspaceChanged: updateCurrentIndex()

        function updateCurrentIndex() {
            let activeIndex = -1;
            for (let i = 0; i < workspaces.length; i++) {
                if (workspaces[i].name === Hyprland.focusedWorkspace.name) {
                    activeIndex = i;
                    break;
                }
            }

            currentIndex = activeIndex;
            console.log(currentIndex);
        }

        model: workspaces

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
            }
        }
    }

    ListView {
        id: workspaceBgList
        z: 0

        implicitWidth: contentWidth
        orientation: ListView.Horizontal

        spacing: BarSettings.workspaces.spacing

        model: workspaceList.workspaces

        currentIndex: workspaceList.currentIndex
        highlight: highlightActive
        highlightFollowsCurrentItem: false

        delegate: Rectangle {
            radius: Appearance.itemRadius

            implicitWidth: Appearance.barHeight
            implicitHeight: Appearance.barHeight

            color: Theme.nord2
        }
    }

    Component {
        id: highlightActive

        Rectangle {
            z: 1
            radius: Appearance.itemRadius
            x: workspaceBgList.currentItem ? workspaceBgList.currentItem.x : 0

            implicitWidth: Appearance.barHeight
            implicitHeight: Appearance.barHeight

            color: Theme.nord10

            Behavior on x {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                }
            }
        }
    }
}
