pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config
import qs.components

WrapperRectangle {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Hours
    }

    function resetToCurrentMonth() {
        let now = new Date();
        root.currentDate = new Date(now.getFullYear(), now.getMonth(), 1);
        root.nextDate = root.currentDate;
        root.slideDirection = 0;
        monthYearContainer.offset = 0;
    }

    implicitWidth: 320
    margin: 10

    property bool open: false
    property int expandedHeight: contentLayout.implicitHeight + 40

    property date currentDate: clock.date
    property date nextDate: currentDate
    property int slideDirection: 0
    property string animationState: ""

    Layout.preferredHeight: open ? expandedHeight : 0
    Layout.minimumHeight: 0
    clip: true
    color: "transparent"

    Behavior on Layout.preferredHeight {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    ColumnLayout {
        id: contentLayout

        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 20
        anchors.bottomMargin: 20

        spacing: 5

        RowLayout {
            id: arrowsMonthYear
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: false
            spacing: 20

            Button {
                id: arrowLeftButton

                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                transformOrigin: Item.Center
                rotation: 90

                background: Rectangle {
                    color: "transparent"
                    implicitHeight: 24
                    implicitWidth: 24
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                onClicked: {
                    // Go to previous month
                    let d = root.currentDate;
                    root.nextDate = new Date(d.getFullYear(), d.getMonth() - 1, 1);
                    root.slideDirection = -1;
                    monthYearContainer.startSlide();
                }

                BarText {
                    anchors.centerIn: parent
                    icon: ""
                    iconColor: Theme.nord4
                }
            }

            Item {
                id: monthYearContainer
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillWidth: false
                Layout.fillHeight: false
                implicitWidth: 180
                implicitHeight: currentRow.implicitHeight
                clip: true

                property real offset: 0

                readonly property real slideWidth: width

                Item {
                    id: stage
                    anchors.fill: parent
                }

                // Main current month row
                RowLayout {
                    id: currentRow
                    anchors.centerIn: stage
                    spacing: 8

                    transform: Translate {
                        x: monthYearContainer.offset
                    }

                    Text {
                        text: Qt.formatDateTime(root.currentDate, "MMMM")
                        font {
                            family: Appearance.font.textFamily
                            pixelSize: Appearance.font.textPixelSize + 4
                            bold: true
                        }
                        color: Theme.nord7
                    }

                    Text {
                        text: Qt.formatDateTime(root.currentDate, "yyyy")
                        font {
                            family: Appearance.font.textFamily
                            pixelSize: Appearance.font.textPixelSize + 4
                        }
                        color: Theme.nord4
                    }
                }

                // Incoming month row
                RowLayout {
                    id: nextRow
                    anchors.centerIn: stage
                    spacing: 8

                    transform: Translate {
                        x: monthYearContainer.offset + root.slideDirection * monthYearContainer.slideWidth
                    }

                    Text {
                        text: Qt.formatDateTime(root.nextDate, "MMMM")
                        font {
                            family: Appearance.font.textFamily
                            pixelSize: Appearance.font.textPixelSize + 4
                            bold: true
                        }
                        color: Theme.nord7
                    }

                    Text {
                        text: Qt.formatDateTime(root.nextDate, "yyyy")
                        font {
                            family: Appearance.font.textFamily
                            pixelSize: Appearance.font.textPixelSize + 4
                        }
                        color: Theme.nord4
                    }
                }

                NumberAnimation on offset {
                    id: slideAnim
                    running: false
                    duration: 250
                    easing.type: Easing.OutCubic
                    from: 0
                    // slide left for nextMonth, right for prevMonth
                    to: -root.slideDirection * monthYearContainer.slideWidth

                    onStopped: {
                        // new month becomes current, reset offset & direction
                        root.currentDate = root.nextDate;
                        monthYearContainer.offset = 0;
                        root.slideDirection = 0;
                    }
                }

                function startSlide() {
                    if (slideAnim.running || root.slideDirection === 0)
                        return;
                    // reset offset then start
                    offset = 0;
                    slideAnim.restart();
                }
            }

            Button {
                id: arrowRightButton

                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                transformOrigin: Item.Center
                rotation: 270

                background: Rectangle {
                    color: "transparent"
                    implicitHeight: 24
                    implicitWidth: 24
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                onClicked: {
                    // Go to next month
                    let d = root.currentDate;
                    root.nextDate = new Date(d.getFullYear(), d.getMonth() + 1, 1);
                    root.slideDirection = 1;
                    monthYearContainer.startSlide();
                }

                BarText {
                    anchors.centerIn: parent

                    icon: ""
                    iconColor: Theme.nord4
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: false
            implicitHeight: 10

            // A horizontal separator line
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: 2
                color: Theme.nord6
                opacity: 0.3
            }
        }

        GridLayout {
            id: weekdaysRow
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: false
            columns: 7
            columnSpacing: 10

            Repeater {
                model: 7

                WrapperRectangle {
                    required property int index
                    Layout.fillWidth: true   // ok here, grid enforces equal columns
                    implicitHeight: 28
                    color: "transparent"

                    Text {
                        text: Qt.formatDateTime(new Date(2024, 0, index + 1), "ddd")
                        font {
                            family: Appearance.font.textFamily
                            pixelSize: Appearance.font.textPixelSize
                        }
                        color: Theme.nord13
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        Item {
            id: calendarSlideContainer
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            implicitHeight: gridCurrent.implicitHeight

            readonly property real slideWidth: width

            property real offset: {
                if (monthYearContainer.slideWidth <= 0)
                    return 0;
                // normalize header offset to [-slideDirection, 0] and scale
                return monthYearContainer.offset / monthYearContainer.slideWidth * calendarSlideContainer.slideWidth;
            }

            // --- current month grid ---
            GridLayout {
                id: gridCurrent
                anchors.fill: parent
                columns: 7
                rowSpacing: 4
                columnSpacing: 10

                transform: Translate {
                    x: calendarSlideContainer.offset
                }

                property int daysInMonth: {
                    var year = root.currentDate.getFullYear();
                    var month = root.currentDate.getMonth();
                    return new Date(year, month + 1, 0).getDate();
                }

                property int firstDayOffset: {
                    var year = root.currentDate.getFullYear();
                    var month = root.currentDate.getMonth();
                    var jsDay = new Date(year, month, 1).getDay();
                    return (jsDay + 6) % 7;
                }

                property int todayIndex: {
                    var year = root.currentDate.getFullYear();
                    var month = root.currentDate.getMonth();
                    var today = new Date();
                    if (year === today.getFullYear() && month === today.getMonth()) {
                        return today.getDate() - 1 + firstDayOffset;
                    }
                    return -1;
                }

                Repeater {
                    model: gridCurrent.daysInMonth + gridCurrent.firstDayOffset

                    WrapperRectangle {
                        required property int index

                        implicitWidth: 28
                        implicitHeight: 28
                        color: index === gridCurrent.todayIndex ? Theme.nord13 : "transparent"
                        radius: Appearance.itemRadius

                        Text {
                            text: {
                                var dayNumber = parent.index - gridCurrent.firstDayOffset + 1;
                                return (dayNumber > 0) ? dayNumber : "";
                            }
                            font {
                                family: Appearance.font.textFamily
                                pixelSize: Appearance.font.textPixelSize
                                bold: (parent.index === gridCurrent.todayIndex)
                            }
                            color: (parent.index === gridCurrent.todayIndex) ? Theme.nord3 : Theme.nord4
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            // --- next / previous month grid ---
            GridLayout {
                id: gridNext
                anchors.fill: parent
                columns: 7
                rowSpacing: 4
                columnSpacing: 10

                transform: Translate {
                    x: calendarSlideContainer.offset + root.slideDirection * calendarSlideContainer.slideWidth
                }

                visible: root.slideDirection !== 0

                property int daysInMonth: {
                    var year = root.nextDate.getFullYear();
                    var month = root.nextDate.getMonth();
                    return new Date(year, month + 1, 0).getDate();
                }

                property int firstDayOffset: {
                    var year = root.nextDate.getFullYear();
                    var month = root.nextDate.getMonth();
                    var jsDay = new Date(year, month, 1).getDay();
                    return (jsDay + 6) % 7;
                }

                property int todayIndex: {
                    var year = root.nextDate.getFullYear();
                    var month = root.nextDate.getMonth();
                    var today = new Date();
                    if (year === today.getFullYear() && month === today.getMonth()) {
                        return today.getDate() - 1 + firstDayOffset;
                    }
                    return -1;
                }

                Repeater {
                    model: gridNext.daysInMonth + gridNext.firstDayOffset

                    WrapperRectangle {
                        required property int index

                        implicitWidth: 28
                        implicitHeight: 28
                        color: index === gridNext.todayIndex ? Theme.nord13 : "transparent"
                        radius: Appearance.itemRadius

                        Text {
                            text: {
                                var dayNumber = parent.index - gridNext.firstDayOffset + 1;
                                return (dayNumber > 0) ? dayNumber : "";
                            }
                            font {
                                family: Appearance.font.textFamily
                                pixelSize: Appearance.font.textPixelSize
                                bold: (parent.index === gridNext.todayIndex)
                            }
                            color: (parent.index === gridNext.todayIndex) ? Theme.nord3 : Theme.nord4
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: resetStateTimer
        interval: 250   // same as animation duration
        repeat: false
        onTriggered: root.animationState = ""
    }

    onAnimationStateChanged: {
        if (animationState === "prevMonth" || animationState === "nextMonth") {
            resetStateTimer.restart();
        }
    }
}
