pragma ComponentBehavior: Bound


import QtQuick
//import QtQuick.Controls
//import Qex.Controls



Item {
    id: control

    property string icosource: ""      // 图标对应的Unicode字符或文本（如"\uE001"）
    property color icocolor: "black"   // 图标的颜色，默认黑色
    property int iconSize: 24          // 图标的默认大小（像素）
    property string imageSource: ""    // 图片资源路径
    implicitWidth: control.iconSize
    implicitHeight: control.iconSize




    Loader {
        id: iconLoader
        anchors.fill: parent
        sourceComponent: {
            if (control.imageSource !== "") {
                return imageIconComponent
            } else {
                return fontIconComponent
            }
        }
       Component.onDestruction: sourceComponent = undefined
    }

    // 字体图标组件
    Component {
        id: fontIconComponent
        Text {
            font.family: FluentIcons.fontLoader.name
            font.pixelSize: control.iconSize
            color: control.icocolor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: control.icosource
        }
    }

    // 图片图标组件
    Component {
        id: imageIconComponent
        Image {
            source: control.imageSource
            sourceSize.width: control.iconSize+2
            sourceSize.height: control.iconSize+2
            fillMode: Image.PreserveAspectFit
        }
    }
}
