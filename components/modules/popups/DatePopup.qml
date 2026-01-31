import Quickshell
import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import qs.components.modules.popups
import qs.components.modules
import qs.components
import qs.config

PopupWrapper {
    id: popup

    onHoveredChanged: {
        if (!hovered && calendar.open) {
            arrowButton.rotate();
            calendar.open = false;
            calendar.resetToCurrentMonth();
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Hours
    }

    content: ColumnLayout {
        spacing: 4

        BarText {
            id: dateText
            Layout.alignment: Qt.AlignHCenter

            icon: ""
            text: Qt.formatDateTime(clock.date, PopupSettings.dateFormat)
            iconColor: Theme.nord4
            textColor: Theme.nord4
        }

        Calendar {
            id: calendar
        }

        Button {
            id: arrowButton

            Layout.alignment: Qt.AlignHCenter
            transformOrigin: Item.Center
            property bool flipped: false

            function rotate() {
                flipped = !flipped;
                rotation = flipped ? 180 : 0;
            }

            function toggleCalendar() {
                calendar.open = !calendar.open;
            }

            background: Rectangle {
                color: "transparent"
                implicitHeight: 24
                implicitWidth: 24
            }

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }

            Behavior on rotation {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }

            onClicked: {
                rotate();
                toggleCalendar();
            }

            BarText {
                id: arrowIcon
                anchors.centerIn: parent

                icon: ""
                iconColor: Theme.nord4
            }
        }
    }
}
