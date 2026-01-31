pragma Singleton

import Quickshell

Singleton {
    readonly property int hideDelay: Config.popup.modules.hideDelay
    readonly property int animDuration: Config.popup.modules.animDuration
    readonly property int slideDistance: Config.popup.modules.slideDistance
    readonly property var dateFormat: Config.popup.modules.date.dateFormat
}
