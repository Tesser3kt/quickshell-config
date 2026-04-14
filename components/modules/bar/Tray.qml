pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import qs.config

Rectangle {
    id: trayWrapper
    implicitWidth: trayList.width
    implicitHeight: Appearance.barHeight
    color: "transparent"

    property var hiddenApps: BarSettings.trayHiddenApps

    ListView {
        id: trayList

        implicitWidth: childrenRect.width
        implicitHeight: Appearance.barHeight
        orientation: ListView.Horizontal
        spacing: Appearance.trayIconPadding

        model: SystemTray.items
        delegate: Rectangle {
            id: trayItem
            visible: trayItemIcon.status === Image.Ready && !trayWrapper.hiddenApps.includes(modelData.id)
            implicitWidth: visible ? Appearance.trayIconSize : 0
            implicitHeight: Appearance.barHeight
            color: "transparent"

            required property SystemTrayItem modelData
            Image {
                id: trayItemIcon
                anchors.centerIn: parent
                source: trayItem.modelData.icon

                width: Appearance.trayIconSize
                height: Appearance.trayIconSize
                sourceSize.width: Appearance.trayIconSize
                sourceSize.height: Appearance.trayIconSize
            }

            TapHandler {
                onTapped: {
                    trayItem.modelData.activate();
                }
            }
        }
    }

    Component.onCompleted: {
        SystemTray.items.values.forEach(item => {
            console.log("id:", item.id, "title:", item.title, "icon:", item.icon);
        });
    }
}
