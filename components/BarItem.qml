import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.config

Rectangle {
    id: root

    required property Item content
    required property color backgroundColor
    required property bool hoverEnabled
    property var padding: Appearance.itemPadding

    color: backgroundColor
    radius: Appearance.itemRadius

    implicitWidth: content.implicitWidth + padding.left + padding.right
    implicitHeight: content.implicitHeight + padding.top + padding.bottom

    children: [content]

    Binding {
        target: root.content
        property: "anchors.centerIn"
        value: root
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.hoverEnabled
        cursorShape: Qt.PointingHandCursor
    }
}
