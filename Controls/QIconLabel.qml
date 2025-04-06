import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
Item {
    id: control
    property int spacing: 2
    property bool mirrored: false
    property int alignment: Qt.AlignVCenter | Qt.AlignHCenter
    property string text
    property font font: QTextFont.body
    property var icosource
    property color color: "black"//enabled ? control.R.theme.res.itemNormalColor : control.R.theme.res.itemDisabledColor

    property real topPadding : 0
    property real leftPadding : 0
    property real rightPadding : 0
    property real bottomPadding : 0

    implicitWidth: loader.width
    implicitHeight: loader.height
    AutoLoader{

        id: loader
        anchors{
            verticalCenter: (control.alignment & Qt.AlignVCenter) ? control.verticalCenter : undefined
            horizontalCenter: (control.alignment & Qt.AlignHCenter) ? control.horizontalCenter : undefined
        }
        sourceComponent:{
            if(control.mirrored)return comp_column
            return comp_row
        }
    }




    Component{
        id: icon
        QIcon{
            iconSize: control.font.pixelSize+4
            icocolor: control.color
            icosource: control.icosource
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
                    sourceComponent: icon
                    visible: control.display !== Button.TextOnly
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label{
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
                    sourceComponent: icon
                    anchors.horizontalCenter:parent.horizontalCenter
                }
                Label{
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
