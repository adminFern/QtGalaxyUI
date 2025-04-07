pragma Singleton
import QtQuick
QtObject {
    property string fontname:"微软雅黑"
    readonly property font body: Qt.font({family:fontname, pixelSize : 13, weight: Font.Normal})
    readonly property font title: Qt.font({family:fontname, pixelSize : 14, weight: Font.DemiBold})

}
