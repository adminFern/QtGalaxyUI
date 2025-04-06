pragma Singleton
import QtQuick
QtObject {
    property string fontname:"微软雅黑"
    readonly property font body: Qt.font({family:fontname, pixelSize : 13, weight: Font.Normal})

}
