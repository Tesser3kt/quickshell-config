pragma Singleton

import Quickshell

Singleton {
    readonly property int itemSpacing: Config.appearance.bar.layout.itemSpacing
    readonly property int barHeight: Config.appearance.bar.layout.height
    readonly property var barPadding: Config.appearance.bar.layout.padding
    readonly property var font: Config.appearance.bar.text.font
    readonly property int iconSpacing: Config.appearance.bar.text.iconSpacing
    readonly property int textVerticalOffset: Config.appearance.bar.text.textVerticalOffset
    readonly property var itemPadding: Config.appearance.bar.item.padding
    readonly property int itemRadius: Config.appearance.bar.item.radius
    readonly property var popupPadding: Config.appearance.popup.padding
    readonly property int popupRadius: Config.appearance.popup.radius
    readonly property int popupGap: Config.appearance.popup.gap
    readonly property string popupBgColor: Config.appearance.popup.backgroundColor
}
