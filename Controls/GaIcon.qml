import QtQuick

Text {
    property int iconSource
    property int iconSize: 20
    property color iconColor:Theme.textColor
    id:control
    font.family: Theme.fontLoader.name
    font.pixelSize: iconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: iconColor
    text: (String.fromCharCode(iconSource).toString(16))
}
