import Quickshell
import QtQuick
import qs.config
import qs.components
import qs.components.util
import qs.components.modules.popups

BarItem {
    id: root

    property color iconColor
    property color textColor

    content: BarText {
        id: barText

        icon: "󰌌"
        text: KeyboardLayout.layoutShort
        iconColor: root.iconColor
        textColor: root.textColor
    }

    HoverHandler {
        id: hoverHandler
    }

    LayoutPopup {
        id: layoutPopup

        anchorItem: root
        hoverAnchor: hoverHandler.hovered
    }
}
