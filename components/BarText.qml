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

    property int iconPixelSize: Appearance.font.iconPixelSize
    property string iconFamily: Appearance.font.iconFamily
    property int textPixelSize: Appearance.font.textPixelSize
    property string textFamily: Appearance.font.textFamily

    Text {
        id: iconItem
        text: root.icon
        visible: root.icon !== "" && root.icon !== undefined
        font {
            pixelSize: root.iconPixelSize
            family: root.iconFamily
        }
        color: root.iconColor
    }

    Text {
        id: textItem
        text: root.text
        visible: root.text !== "" && root.text !== undefined
        font {
            pixelSize: root.textPixelSize
            family: root.textFamily
        }
        transform: Translate {
            y: Appearance.textVerticalOffset
        }
        color: root.textColor
    }
}
