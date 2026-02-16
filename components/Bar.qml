import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.components.modules.bar
import qs.components.modules.popups

Item {
    id: root

    required property ShellScreen screen
    anchors.fill: parent
    anchors.margins: {
        left: Appearance.barPadding.left;
        right: Appearance.barPadding.right;
    }

    RowLayout {
        id: leftModules
        spacing: Appearance.itemSpacing
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Workspaces {
            screen: root.screen
        }
    }

    RowLayout {
        id: rightModules
        spacing: Appearance.itemSpacing
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}
