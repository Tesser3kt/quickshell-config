import Quickshell.Io

JsonObject {
    property JsonObject bar: JsonObject {
        property JsonObject layout: JsonObject {
            property int height: 35
            property int itemSpacing: 8
            property JsonObject padding: JsonObject {
                property int left: 15
                property int right: 15
                property int top: 5
                property int bottom: 5
            }
        }
        property JsonObject text: JsonObject {
            property JsonObject font: JsonObject {
                property string textFamily: "Hurmit Nerd Font"
                property string iconFamily: "Symbols Nerd Font"
                property int textPixelSize: 14
                property int iconPixelSize: 16
            }
            property int iconSpacing: 5
            property int textVerticalOffset: 1
        }
        property JsonObject item: JsonObject {
            property JsonObject padding: JsonObject {
                property int left: 12
                property int right: 12
                property int top: 6
                property int bottom: 6
            }
            property int radius: 8
        }
    }
    property JsonObject popup: JsonObject {
        property JsonObject padding: JsonObject {
            property int left: 10
            property int right: 10
            property int top: 10
            property int bottom: 10
        }
        property int radius: 8
        property int gap: 6
        property string backgroundColor: Theme.nord2
    }
}
