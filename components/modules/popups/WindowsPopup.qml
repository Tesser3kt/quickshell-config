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

    function focusWindow(address) {
        Hyprland.dispatch(`focuswindow address:0x${address}`);
        hoverPopup = false;
    }

    function closeWindow(address) {
        Hyprland.dispatch(`closewindow address:0x${address}`);
        AllWindows.refresh();
    }

    Process {
        id: killWindow

        property int pid

        command: ["kill", `${pid}`]
        running: false
    }

    content: ColumnLayout {
        spacing: 4
        Repeater {
            model: popup.allWindows

            Item {
                id: row

                implicitWidth: 340
                implicitHeight: 40

                required property var modelData
                required property int index

                WrapperRectangle {
                    id: bg
                    anchors.fill: parent
                    margin: 10
                    radius: Appearance.popupRadius

                    color: row.modelData.active ? Theme.nord10 : Theme.nord0
                    opacity: (row.modelData.active || hover.hovered) ? 1.0 : 0.0
                    z: 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                WrapperRectangle {
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
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent

                    BarText {
                        id: windowTitle
                        z: 2

                        Layout.alignment: Qt.AlignLeft

                        icon: row.modelData.icon
                        text: row.modelData.title
                        iconColor: Theme.nord4
                        textColor: Theme.nord4

                        iconPixelSize: 18
                    }

                    BarText {
                        id: closeIcon
                        Layout.alignment: Qt.AlignRight
                        z: 2

                        icon: ""
                        iconColor: Theme.nord12

                        TapHandler {
                            id: closeTapHandler
                            onTapped: {
                                popup.closeWindow(row.modelData.address);
                            }
                        }
                    }
                }

                HoverHandler {
                    id: hover
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
