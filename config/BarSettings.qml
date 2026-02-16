pragma Singleton

import Quickshell

Singleton {
    readonly property var clock: Config.bar.modules.clock
    readonly property var workspaces: Config.bar.modules.workspaces
}
