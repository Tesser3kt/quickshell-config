pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import qs.components.modules.popups
import qs.components.modules
import qs.components.util
import qs.components
import qs.config

PopupWrapper {
    id: popup

    property string uptime: {
        const days = Uptime.days;
        const hours = Uptime.hours;
        const minutes = Uptime.minutes;

        if (days === -1 || hours === -1 || minutes === -1)
            return "Unknown uptime.";

        if (days > 0)
            return `Up for ${days} days, ${hours} hours and ${minutes} minutes.`;
        else if (hours > 0)
            return `Up for ${hours} hours and ${minutes} minutes.`;
        else
            return `Up for ${minutes} minutes.`;
    }

    content: BarText {
        id: barText

        icon: "󰈈"
        iconColor: Theme.nord4
        text: popup.uptime
        textColor: Theme.nord4
    }
}
