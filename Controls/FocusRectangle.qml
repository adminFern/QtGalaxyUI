import QtQuick
import QtQuick.Controls
Item {
    property color color: Theme.isDark ? Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
    property int radius: 4
    id:control
    anchors.fill: parent

    Rectangle{
        width: control.width
        height: control.height
        anchors.centerIn: parent
        color: "#00000000"
        border.width: 2
        radius: control.radius
        border.color: control.color
        z: 65535
    }
}
