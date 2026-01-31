import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.config

Variants {
    id: root
    model: Quickshell.screens

    function panelFor(screen) {
        for (let i = 0; i < root.count; i++) {
            let panel = root.itemAt(i).barPanel;
            if (panel && panel.screen === screen) {
                return panel;
            }
        }
        return null;
    }

    PanelWindow {
        id: barPanel

        required property ShellScreen modelData
        screen: modelData
        visible: true
        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Appearance.barHeight

        WrapperRectangle {
            anchors.fill: parent
            color: "transparent"

            leftMargin: Appearance.barPadding.left
            rightMargin: Appearance.barPadding.right
            topMargin: Appearance.barPadding.topMargin
            bottomMargin: Appearance.barPadding.bottomMargin

            Bar {}
        }
    }
}
