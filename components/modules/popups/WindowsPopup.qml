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
    property var closingAddresses: []

    function focusWindow(address) {
        Hyprland.dispatch(`focuswindow address:0x${address}`);
        hoverPopup = false;
    }

    function closeWindow(address, index) {
        closingAddresses.push(address);
        closingAddressesChanged();
    }

    function actuallyCloseWindow(address) {
        Hyprland.dispatch(`closewindow address:0x${address}`);
        closingAddresses = closingAddresses.filter(addr => addr !== address);
    }

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

        implicitWidth: 340
        implicitHeight: contentHeight

        spacing: 4
        interactive: false

        model: popup.allWindows
        highlight: highlight
        highlightFollowsCurrentItem: true
        focus: true

        highlightMoveDuration: PopupSettings.highlightMoveDuration
        highlightMoveVelocity: PopupSettings.highlightMoveVelocity

        onModelChanged: {
            currentIndex = popup.highlightedIndex;
        }

        delegate: Item {
            id: row

            width: ListView.view.width
            height: closing ? 0 : 40
            opacity: closing ? 0 : 1
            clip: true

            required property var modelData
            required property int index

            property bool closing: popup.closingAddresses.includes(modelData.address)

            Behavior on height {
                NumberAnimation {
                    duration: PopupSettings.animDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: PopupSettings.animDuration
                    easing.type: Easing.OutCubic
                }
            }

            onClosingChanged: {
                if (closing) {
                    closeTimer.start();
                }
            }

            Timer {
                id: closeTimer
                interval: PopupSettings.animDuration
                repeat: false
                onTriggered: popup.actuallyCloseWindow(row.modelData.address)
            }

            Rectangle {
                id: activeBg
                anchors.fill: parent
                radius: Appearance.popupRadius

                color: Theme.nord10
                opacity: row.modelData.active ? PopupSettings.activeHighlightOpacity : 0.0
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
                        popup.focusWindow(row.modelData.address);
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

                    icon: row.modelData.icon
                    text: row.modelData.title
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
                            popup.closeWindow(row.modelData.address, row.index);
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
