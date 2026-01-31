pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias bar: adapter.bar
    property alias popup: adapter.popup

    FileView {
        path: `${Quickshell.env("HOME")}/.config/quickshell/config.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter

            property AppearanceConfig appearance: AppearanceConfig {}
            property BarConfig bar: BarConfig {}
            property PopupConfig popup: PopupConfig {}
        }
    }
}
