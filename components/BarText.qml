import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.config

RowLayout {
    id: root

    spacing: Appearance.iconSpacing

    implicitWidth: iconItem.implicitWidth + textItem.implicitWidth + (iconItem.visible && textItem.visible ? spacing : 0)
    implicitHeight: Math.max(iconItem.implicitHeight, textItem.implicitHeight)

    property string icon
    property string text
    property color iconColor
    property color textColor

    Text {
        id: iconItem
        text: root.icon
        visible: root.icon !== "" && root.icon !== undefined
        font {
            pixelSize: Appearance.font.iconPixelSize
            family: Appearance.font.iconFamily
        }
        color: root.iconColor
    }

    Text {
        id: textItem
        text: root.text
        visible: root.text !== "" && root.text !== undefined
        font {
            pixelSize: Appearance.font.textPixelSize
            family: Appearance.font.textFamily
        }
        transform: Translate {
            y: Appearance.textVerticalOffset
        }
        color: root.textColor
    }
}
