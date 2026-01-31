import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.config

PopupWindow {
    id: popup

    // Basic properties
    required property Item anchorItem
    required property Item content
    color: "transparent"

    implicitHeight: Math.max(1, frame.implicitHeight)
    implicitWidth: Math.max(1, frame.implicitWidth)

    // Anchor logic
    anchor.window: anchorItem ? anchorItem.QsWindow.window : null
    anchor.adjustment: PopupAdjustment.SlideX | PopupAdjustment.ResizeY
    anchor.onAnchoring: {
        const pos = anchorItem.QsWindow.contentItem.mapFromItem(anchorItem, anchorItem.width / 2 - popup.width / 2, anchorItem.height + Appearance.popupGap);
        anchor.rect.x = pos.x;
        anchor.rect.y = pos.y;
        anchor.rect.width = Math.max(1, anchorItem.width);
        anchor.rect.height = 1;
    }
    onVisibleChanged: if (visible)
        anchor.updateAnchor()

    // Hover logic
    property bool hoverAnchor: false
    property bool hoverPopup: false
    readonly property bool hovered: hoverAnchor || hoverPopup
    property bool wantsVisible: false

    visible: wantsVisible

    property int animDuration: PopupSettings.animDuration
    property int slideDistance: PopupSettings.slideDistance

    property bool closing: false

    HoverHandler {
        onHoveredChanged: popup.hoverPopup = hovered
    }

    Timer {
        id: closeDelay
        interval: PopupSettings.hideDelay
        repeat: false
        onTriggered: {
            if (!popup.hovered) {
                frame.state = "closed";
                hideAfterAnim.restart();
            }
        }
    }

    Timer {
        id: hideAfterAnim
        interval: popup.animDuration
        repeat: false
        onTriggered: {
            if (!popup.hovered) {
                popup.visible = false;
            }
        }
    }

    function showPopup() {
        closeDelay.stop();
        hideAfterAnim.stop();

        if (!popup.visible) {
            popup.visible = true;
            popup.anchor.updateAnchor();
        }
        frame.state = "open";
    }

    function requestClose() {
        closeDelay.restart();
    }

    onHoveredChanged: {
        if (hovered) {
            showPopup();
        } else {
            requestClose();
        }
    }

    // Content
    Item {
        id: frame
        implicitWidth: wrapper.implicitWidth
        implicitHeight: wrapper.implicitHeight

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        state: "closed"
        opacity: 0

        states: [
            State {
                name: "open"
                PropertyChanges {
                    frame.opacity: 1
                    frame.y: 0
                }
            },
            State {
                name: "closed"
                PropertyChanges {
                    frame.opacity: 0
                    frame.y: -popup.slideDistance
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y,opacity"
                        duration: popup.animDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        ]

        WrapperRectangle {
            id: wrapper
            property var padding: Appearance.popupPadding

            leftMargin: padding.left
            rightMargin: padding.right
            topMargin: padding.top
            bottomMargin: padding.bottom

            radius: Appearance.popupRadius
            color: Appearance.popupBgColor

            implicitWidth: popup.content.implicitWidth + leftMargin + rightMargin
            implicitHeight: popup.content.implicitHeight + topMargin + bottomMargin

            children: [popup.content]
        }
    }
}
