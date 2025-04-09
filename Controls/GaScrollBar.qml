import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import GalaxyUI


T.ScrollBar{
    id: control
    property color color : Theme.isDark ? Qt.rgba(159/255,159/255,159/255,0.5) : Qt.rgba(138/255,138/255,138/255,0.5)
    property color pressedColor: Theme.isDark ? Qt.darker(color,1.1) : Qt.lighter(color,1.1)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: Math.max(orientation === Qt.Horizontal ? height / width : width / height,0.3)
    QtObject{
        id:d
        property int  minLine : 2
        property int  maxLine : 6
    }
    z: horizontal? 10 : 20
    verticalPadding : vertical ? 13 : 3
    horizontalPadding : horizontal ? 13 : 3
    GaIconButton{
      // cursorShape: Qt.PointingHandCursor // 添加手指指针
        id:button1
        width: 12
        height: 12
        iconSize: 8
        verticalPadding: 0
        horizontalPadding: 0
        iconColor: control.color
        anchors.right:parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter:parent.verticalCenter
        visible: control.horizontal && (control.hovered || control.pressed) // 修改这里
         iconSource:Icons.CaretRightSolid8
         onClicked: {
             control.increase()
         }


    }
    GaIconButton{
        id:button2
        width: 12
        height: 12
        iconSize: 8
        verticalPadding: 0
        horizontalPadding: 0
        iconColor: control.color
        anchors{
            top: parent.top
            topMargin: 0
            horizontalCenter: parent.horizontalCenter
        }
       visible: control.vertical && (control.hovered || control.pressed) // 修改这里
        iconSource: Icons.CaretUpSolid8
        onClicked: {
            control.decrease()
        }


    }
    GaIconButton{
        id:button3
        width: 12
        height: 12
        iconSize: 8
        verticalPadding: 0
        horizontalPadding: 0
        iconColor: control.color
        anchors{
            bottom: parent.bottom
            bottomMargin: 0
            horizontalCenter: parent.horizontalCenter
        }
          visible: control.vertical && (control.hovered || control.pressed) // 修改这里
        iconSource: Icons.CaretDownSolid8
        onClicked: {
            control.increase()
        }


    }

    contentItem: Item {
        property bool collapsed: (control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0))
        implicitWidth: control.interactive ? d.maxLine : d.minLine
        implicitHeight: control.interactive ? d.maxLine : d.minLine
        Rectangle{
            id:rect_bar
            width:  vertical ? d.minLine : parent.width
            height: horizontal  ? d.minLine : parent.height
            color:{
                if(control.pressed){
                    return control.pressedColor
                }
                return control .color
            }
            anchors{
                right: vertical ? parent.right : undefined
                bottom: horizontal ? parent.bottom : undefined
            }
            radius: width / 2
            visible: control.size < 1.0



        }
        states: [
            State{
                name:"show"
                when: contentItem.collapsed
                PropertyChanges {
                    target: rect_bar
                    width:  vertical ? d.maxLine : parent.width
                    height: horizontal  ? d.maxLine : parent.height
                }
            }
            ,State{
                name:"hide"
                when: !contentItem.collapsed
                PropertyChanges {
                    target: rect_bar
                    width:  vertical ? d.minLine : parent.width
                    height: horizontal  ? d.minLine : parent.height
                }
            }
        ]
        transitions:[
            Transition {
                to: "hide"
                SequentialAnimation {
                    PauseAnimation { duration: 450 }
                    NumberAnimation {
                        target: rect_bar
                        properties: vertical ? "width"  : "height"
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
            ,Transition {
                to: "show"
                SequentialAnimation {
                    PauseAnimation { duration: 150 }
                    NumberAnimation {
                        target: rect_bar
                        properties: vertical ? "width"  : "height"
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        ]
    }
}
