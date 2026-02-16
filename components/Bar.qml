import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.components.modules.bar
import qs.components.modules.popups

RowLayout {
    id: root

    required property ShellScreen screen
    anchors.verticalCenter: parent.verticalCenter

    RowLayout {
        id: leftModules
        spacing: Appearance.itemSpacing
        Layout.alignment: Qt.AlignLeft

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

        IdleInhibitor {
            id: idleInhibitorModule

            backgroundColor: Theme.nord9
            iconColor: Theme.nord0
            textColor: Theme.nord0
            hoverEnabled: true
        }

        ActiveWindow {
            id: activeWindowModule

            backgroundColor: Theme.nord10
            iconColor: Theme.nord6
            textColor: Theme.nord6
            hoverEnabled: true
        }
    }

    RowLayout {
        id: centerModules
        spacing: Appearance.itemSpacing
        Layout.alignment: Qt.AlignHCenter
    }
}
