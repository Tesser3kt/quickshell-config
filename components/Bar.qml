import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.components.modules.bar
import qs.components.modules.popups

RowLayout {
    id: root

    anchors.verticalCenter: parent.verticalCenter

    RowLayout {
        id: leftModules
        spacing: Appearance.itemSpacing

        Clock {
            id: clockModule

            backgroundColor: Theme.nord7
            iconColor: Theme.nord0
            textColor: Theme.nord0
            hoverEnabled: true
        }

        Keyboard {
            id: keyboardModule

            backgroundColor: Theme.nord8
            iconColor: Theme.nord0
            textColor: Theme.nord0
            hoverEnabled: true
        }
    }
}
