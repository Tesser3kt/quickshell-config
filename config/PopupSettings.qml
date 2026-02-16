pragma Singleton

import Quickshell

Singleton {
    readonly property int hideDelay: Config.popup.modules.hideDelay
    readonly property int animDuration: Config.popup.modules.animDuration
    readonly property int slideDistance: Config.popup.modules.slideDistance
    readonly property var dateFormat: Config.popup.modules.date.dateFormat
    readonly property real highlightMoveVelocity: Config.popup.listView.highlightMoveVelocity
    readonly property int highlightMoveDuration: Config.popup.listView.highlightMoveDuration
    readonly property real activeHighlightOpacity: Config.popup.listView.activeHighlightOpacity
}
