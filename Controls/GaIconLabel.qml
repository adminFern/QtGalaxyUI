import QtQuick
import QtQuick.Controls
import GalaxyUI
Item {
    id: control
    property int spacing: 2
    property bool mirrored: false
    property int display: Button.TextBesideIcon
    property string text
    property font font:TextFont.body
    property real topPadding : 0
    property real leftPadding : 0
    property real rightPadding : 0
    property real bottomPadding : 0
    property color color:Theme.textColor
    property var iconSource
    property int iconSize:height
    implicitWidth: loader.width
    implicitHeight: loader.height
    AutoLoader{
        id: loader
        anchors{
            verticalCenter: (control.alignment & Qt.AlignVCenter) ? control.verticalCenter : undefined
            horizontalCenter: (control.alignment & Qt.AlignHCenter) ? control.horizontalCenter : undefined
        }
        sourceComponent: {
            if(display === Button.TextUnderIcon){
                return comp_column
            }
            return comp_row
        }
    }




    Component{
        id: comp_icon
        GaIcon{
            iconColor: control.color
            iconSource: control.iconSource
            iconSize: control.iconSize
        }
    }
    Component{
        id: comp_row
        Item{
            width: childrenRect.width + control.leftPadding + control.rightPadding
            height: childrenRect.height + control.topPadding + control.bottomPadding
            x: control.leftPadding
            y: control.topPadding
            Row{
                layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight
                spacing: label_text.text === ""  ? 0 : control.spacing
                AutoLoader{
                    sourceComponent: comp_icon
                    visible: control.display !== Button.TextOnly
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text{
                    id: label_text
                    text: control.text
                    font: control.font
                    color: control.color
                    visible: control.display !== Button.IconOnly
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
    Component{
        id: comp_column
        Item{
            width: childrenRect.width + control.leftPadding + control.rightPadding
            height: childrenRect.height + control.topPadding + control.bottomPadding
            x: control.leftPadding
            y: control.topPadding
            Column{
                spacing: label_text.text === ""  ? 0 : control.spacing
                AutoLoader{
                    sourceComponent: comp_icon
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                Text{
                    id: label_text
                    text: control.text
                    font: control.font
                    color: control.color
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

}
