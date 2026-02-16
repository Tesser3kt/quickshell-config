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

    property int highlightedIndex: -1
    property var highlightedItem: null

    onHighlightedIndexChanged: {
        layoutList.currentIndex = highlightedIndex;
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
        id: layoutList

        implicitWidth: 180
        implicitHeight: contentHeight

        spacing: 4
        interactive: false

        model: AllKeyboardLayouts.getDisplayNames()
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
            height: 40

            required property string modelData
            required property int index
            property bool active: index === KeyboardLayout.activeIndex

            Rectangle {
                id: activeBg
                anchors.fill: parent
                radius: Appearance.popupRadius

                color: Theme.nord8
                opacity: row.active ? PopupSettings.activeHighlightOpacity : 0.0
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
                onHoveredChanged: {
                    if (hovered) {
                        layoutList.currentIndex = row.index;
                        popup.highlightedItem = row;
                        popup.highlightedIndex = row.index;
                    }
                }
            }

            TapHandler {
                onTapped: {
                    KeyboardLayout.switchLayout(row.index);
                }
            }
        }
    }
}
