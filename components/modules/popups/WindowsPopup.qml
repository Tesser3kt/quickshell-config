pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import qs.components.modules.popups
import qs.components.modules
import qs.components.util
import qs.components
import qs.config

PopupWrapper {
    id: popup

    required property var allWindows
    property int highlightedIndex: -1
    property var highlightedItem: null

    ListModel {
        id: windowsModel
    }

    function syncModel() {
        const newAddresses = allWindows.map(w => w.address);

        // Remove items no longer in allWindows
        for (let i = windowsModel.count - 1; i >= 0; i--) {
            const addr = windowsModel.get(i).address;
            if (!newAddresses.includes(addr))
                windowsModel.remove(i);
        }

        // Build current address list
        const existingAddresses = [];
        for (let i = 0; i < windowsModel.count; i++)
            existingAddresses.push(windowsModel.get(i).address);

        // Insert / update items
        for (let i = 0; i < allWindows.length; i++) {
            const w = allWindows[i];
            const existingIdx = existingAddresses.indexOf(w.address);

            if (existingIdx === -1) {
                const insertAt = Math.min(i, windowsModel.count);
                windowsModel.insert(insertAt, w);
                existingAddresses.splice(insertAt, 0, w.address);
                continue;
            }

            const modelItem = windowsModel.get(existingIdx);
            if (modelItem.active !== w.active)
                windowsModel.setProperty(existingIdx, "active", w.active);
            if (modelItem.title !== w.title)
                windowsModel.setProperty(existingIdx, "title", w.title);
            if (modelItem.icon !== w.icon)
                windowsModel.setProperty(existingIdx, "icon", w.icon);
        }
    }

    function focusWindow(address) {
        Hyprland.dispatch(`hl.dsp.focus({ window = "address:0x${address}" })`);
        hoverPopup = false;
    }

    function closeWindow(address, index) {
        Hyprland.dispatch(`hl.dsp.window.close({ window = "address:0x${address}" })`);
        for (let i = 0; i < windowsModel.count; i++) {
            if (windowsModel.get(i).address === address) {
                windowsModel.remove(i);
                break;
            }
        }
    }

    onAllWindowsChanged: syncModel()
    Component.onCompleted: syncModel()

    onHighlightedIndexChanged: {
        windowsList.currentIndex = highlightedIndex;
    }

    onVisibleChanged: {
        if (!visible) {
            highlightedIndex = -1;
            highlightedItem = null;
        }
    }

    Component {
        id: highlight

        Rectangle {
            id: highlightRect
            radius: Appearance.popupRadius

            color: Theme.nord0
            z: 0
        }
    }

    content: ListView {
        id: windowsList

        readonly property int rowHeight: 40
        readonly property int rowSpacing: 4

        implicitWidth: 340
        implicitHeight: count > 0 ? count * rowHeight + (count - 1) * rowSpacing : 0

        spacing: rowSpacing
        interactive: false

        model: windowsModel
        highlight: highlight
        highlightFollowsCurrentItem: true
        focus: true

        highlightMoveDuration: PopupSettings.highlightMoveDuration
        highlightMoveVelocity: PopupSettings.highlightMoveVelocity

        remove: Transition {
            ParallelAnimation {
                PropertyAction {
                    property: "z"
                    value: 10
                }
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: PopupSettings.animDuration
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "scale"
                    to: 0.85
                    duration: PopupSettings.animDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        addDisplaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: PopupSettings.animDuration
                easing.type: Easing.OutCubic
            }
        }

        delegate: Item {
            id: row

            width: ListView.view.width
            height: 40

            required property int index
            required property string address
            required property string title
            required property string icon
            required property bool active

            Rectangle {
                id: activeBg
                anchors.fill: parent
                radius: Appearance.popupRadius

                color: Theme.nord10
                opacity: row.active ? PopupSettings.activeHighlightOpacity : 0.0
                z: 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Rectangle {
                id: tapArea
                anchors.fill: parent
                anchors.rightMargin: 40
                color: "transparent"
                z: 1

                TapHandler {
                    id: tapHandler
                    onTapped: {
                        popup.focusWindow(row.address);
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                BarText {
                    id: windowTitle
                    z: 2

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                    icon: row.icon
                    text: row.title
                    iconColor: Theme.nord4
                    textColor: Theme.nord4

                    iconPixelSize: 18
                }

                BarText {
                    id: closeIcon
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    z: 2

                    icon: "󰅗"
                    iconColor: Theme.nord12

                    TapHandler {
                        id: closeTapHandler
                        onTapped: {
                            popup.closeWindow(row.address, row.index);
                        }
                    }
                }
            }

            HoverHandler {
                id: hover
                cursorShape: Qt.PointingHandCursor
                onHoveredChanged: {
                    if (hovered) {
                        windowsList.currentIndex = row.index;
                        popup.highlightedItem = row;
                        popup.highlightedIndex = row.index;
                    }
                }
            }
        }
    }
}
