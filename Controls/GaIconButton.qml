import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
Button{
    id:control
    display: Button.IconOnly
    property int iconSize: 20
    property string iconSource
    property bool disabled: false
    property int radius:4
    property string contentDescription: ""
    property Component iconDelegate: com_icon
    property color iconColor:Theme.textColor
    property color textColor:Theme.textColor


    QtObject{
        id:d

        property color hoverColor: Theme.isDark?Qt.rgba(1,1,1,0.08):Qt.rgba(0,0,0,0.08)
        property color pressColor: Theme.isDark?Qt.rgba(1,1,1,0.1):Qt.rgba(0,0,0,0.1)

    }


    property color color: {




        if(!enabled){
            return Theme.itemDisabledColor //禁止
        }
        if(pressed){
            return d.pressColor
        }
        return hovered ?d.hoverColor : "transparent"
    }


    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    focusPolicy:Qt.TabFocus
    padding: 0
    verticalPadding: 1
    horizontalPadding: 1
    enabled: !disabled
    font:TextFont.body

    background: Rectangle{
        implicitWidth: 30
        implicitHeight: 30
        radius: control.radius
        color:control.color

    }

    contentItem:AutoLoader{
        sourceComponent: {
            if(display === Button.TextUnderIcon){
                return com_column
            }
            return com_row
        }
    }



    //图标
    Component{
        id:com_icon
        GaIcon {
            id:text_icon
            iconSize: control.iconSize
            iconColor:  control.iconColor
            iconSource: control.iconSource
        }
    }
    //文本
    Component{
        id:com_row
        RowLayout{
            //加载图片资源对象
            AutoLoader{
                sourceComponent: iconDelegate
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            Text{
                text:control.text
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.IconOnly
                color: control.textColor
                font: control.font
            }
        }
    }

    //文本
    Component{
        id:com_column
        ColumnLayout{
            AutoLoader{
                sourceComponent: iconDelegate
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            Text{
                text:control.text
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.IconOnly
                color: control.textColor
                font: control.font
            }
        }
    }

}
