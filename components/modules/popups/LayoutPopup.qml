pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
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

    content: ColumnLayout {
        spacing: 4

        Repeater {
            model: AllKeyboardLayouts.getDisplayNames()

            Item {
                id: row

                implicitWidth: 180
                implicitHeight: 40

                required property string modelData
                required property int index
                property bool active: index === KeyboardLayout.activeIndex

                WrapperRectangle {
                    id: bg
                    anchors.fill: parent
                    margin: 10
                    radius: Appearance.popupRadius

                    color: row.active ? Theme.nord8 : Theme.nord0
                    opacity: (row.active || hover.hovered) ? 0.5 : 0.0
                    z: 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                BarText {
                    id: layoutText
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    z: 1

                    icon: "󰌌"
                    text: row.modelData
                    iconColor: Theme.nord4
                    textColor: Theme.nord4

                    iconPixelSize: 18
                }

                HoverHandler {
                    id: hover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: {
                        KeyboardLayout.switchLayout(row.index);
                    }
                }
            }
        }
    }
}
