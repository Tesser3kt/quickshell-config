pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property var layoutCodes: []
    property var variantCodes: []
    property var available: []
    property var _layoutDesc: ({})
    property var _variantDesc: ({})

    function refresh() {
        getKeyboardLayout.running = true;
        getKeyboardVariant.running = true;
        xkbcliList.running = true;
    }

    function rebuild() {
        const out = [];
        for (let i = 0; i < layoutCodes.length; i++) {
            const l = (layoutCodes[i] || "").trim();
            if (!l)
                continue;

            const v = (variantCodes[i] || "").trim();
            const key = `${l}:${v}`;

            let display = "";
            if (!v)
                display = _layoutDesc[l] || l;
            else
                display = _variantDesc[key] || ((_layoutDesc[l] || l) + ` (${v})`);

            out.push({
                layout: l,
                variant: v,
                display
            });
        }
        available = out;
    }

    function getDisplayNames() {
        return available.map(x => x.display);
    }

    // Processes
    Process {
        id: getKeyboardLayout
        command: ["hyprctl", "-j", "getoption", "input:kb_layout"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    const layouts = data?.str?.split(",") || [];
                    root.layoutCodes = layouts.map(l => l.trim());
                    root.rebuild();
                } catch (e) {
                    // do nothing
                }
            }
        }
    }

    Process {
        id: getKeyboardVariant
        command: ["hyprctl", "-j", "getoption", "input:kb_variant"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    const variants = data?.str?.split(",") || [];
                    root.variantCodes = variants.map(v => v.trim());
                    root.rebuild();
                } catch (e) {
                    // do nothing
                }
            }
        }
    }

    // Parse xkbcli output
    Process {
        id: xkbcliList
        command: ["xkbcli", "list"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = (this.text || "").split("\n");
                const layoutDesc = {};
                const variantDesc = {};

                let inLayouts = false;
                let curLayout = "";
                let curVariant = "";

                for (const line of lines) {
                    if (line.trim() === "layouts:") {
                        inLayouts = true;
                        continue;
                    }
                    if (!inLayouts) {
                        continue;
                    }

                    const mLayout = line.match(/^\s*-\s*layout:\s*'+([^\s#]+)'+/);
                    if (mLayout) {
                        curLayout = mLayout[1];
                        curVariant = "";
                        continue;
                    }

                    const mVariant = line.match(/^\s*variant:\s*'+([^\s#]+)'+/);
                    if (mVariant) {
                        curVariant = mVariant[1];
                        continue;
                    }

                    const mDesc = line.match(/^\s*description:\s*(.+)\s*$/);
                    if (mDesc && curLayout) {
                        const desc = mDesc[1].trim();
                        if (!curVariant) {
                            layoutDesc[curLayout] = desc;
                        } else {
                            variantDesc[`${curLayout}:${curVariant}`] = desc;
                        }
                    }
                }

                root._layoutDesc = layoutDesc;
                root._variantDesc = variantDesc;
                root.rebuild();
            }
        }
    }

    Component.onCompleted: refresh()
}
