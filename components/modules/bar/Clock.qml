import Quickshell
import QtQuick
import qs.components
import qs.config
import qs.components.modules.popups

BarItem {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    property color iconColor
    property color textColor

    content: BarText {
        id: barText

        icon: "󰥔"
        text: Qt.formatDateTime(clock.date, BarSettings.clock.timeFormat)
        iconColor: root.iconColor
        textColor: root.textColor
    }

    DatePopup {
        id: datePopup

        anchorItem: root
        tapAnchor: root.tapped
    }
}
