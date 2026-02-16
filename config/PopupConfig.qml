import Quickshell.Io

JsonObject {
    property JsonObject modules: JsonObject {
        property int hideDelay: 200
        property int animDuration: 200
        property int slideDistance: 20
        property JsonObject date: JsonObject {
            property string dateFormat: "dddd, MMMM d, yyyy"
        }
    }

    property JsonObject listView: JsonObject {
        property int highlightMoveDuration: 100
        property real highlightMoveVelocity: -1
        property real activeHighlightOpacity: 0.7
    }
}
