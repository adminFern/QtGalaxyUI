import QtQuick
import QtQuick.Controls.impl
Item {
    id: control
    property var iconSource
    property int iconSize: 20
     property color iconColor:Theme.textColor
    implicitWidth: iconSize
    implicitHeight: iconSize

    AutoLoader{

        anchors.fill: parent
        sourceComponent:{
            if(Number.isInteger(iconSource)) return comp_text
            if(typeof iconSource === "string") return comp_image
            return undefined
        }
    }




    Component{
        id: comp_text
        Text{
            font.family: Theme.fontLoader.name
            font.pixelSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:control.iconColor
            text: (String.fromCharCode(iconSource).toString(16))
        }
    }
    Component{
        id: comp_image

        Image {

            source: iconSource
        }
    }
}






