import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic

Button {
    id: control
    // 基本属性
    property int spacing_: 1
    property int radius: 4
    property int iconSize: 20
    property int iconSource
    property color iconColor: Theme.textColor
    property color highlightedcolor: "indianred"

    // 辅助功能
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.onPressAction: control.clicked()
    focusPolicy: Qt.TabFocus
    property string contentDescription: ""

    // 私有属性
    QtObject {
        id: d
        // 颜色配置
        property color pressedColor: Theme.isDark ? Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.2)
        property color hoveredColor: Theme.isDark ? Qt.rgba(1,1,1,0.15) : Qt.rgba(0,0,0,0.15)
        property color normalColor: Theme.isDark ? Qt.rgba(1,1,1,0.1) : Qt.rgba(0,0,0,0.1)
        property color borderPresslColor: Theme.isDark ? Qt.rgba(1,1,1,0.35) : Qt.rgba(0,0,0,0.35)
        property color borderHoverlColor: Theme.isDark ? Qt.rgba(1,1,1,0.25) : Qt.rgba(0,0,0,0.25)
        property color borderNormalColor: Theme.isDark ? Qt.rgba(1,1,1,0.18) : Qt.rgba(0,0,0,0.18)
        property color textColor: Theme.isDark ? "white" : "black"

        // 动画配置
        property real scaleFactor: 0.95
        property int animationDuration: 200
    }

    // 颜色计算
    property color color: {
        if(!enabled) return Theme.itemDisabledColor

        if(highlighted) {
            if(Theme.isDark) {
                return pressed ? Qt.lighter(highlightedcolor, 0.75) :
                       hovered ? Qt.lighter(highlightedcolor, 0.9) :
                       highlightedcolor
            }
            return pressed ? Qt.darker(highlightedcolor, 0.75) :
                   hovered ? Qt.darker(highlightedcolor, 0.9) :
                   highlightedcolor
        }

        return pressed ? d.pressedColor :
               hovered ? d.hoveredColor :
               d.normalColor
    }

    // 背景
    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: control.radius
        color: control.color
        border.width: !flat && !highlighted ? 1 : 0
        border.color: {
            if(!flat && !highlighted) {
                return pressed ? d.borderPresslColor :
                       hovered ? d.borderHoverlColor :
                       d.borderNormalColor
            }
            return "transparent"
        }
    }

    // 内容布局
    contentItem: AutoLoader {
        sourceComponent: display === Button.TextUnderIcon ? com_column : com_row
    }

    // 动画系统
    transform: Scale {
        id: scaleTransform
        origin.x: control.width / 2
        origin.y: control.height / 2
    }

    states: [
        State {
            name: "pressed"
            when: control.pressed
            PropertyChanges {
                target: scaleTransform
                xScale: d.scaleFactor
                yScale: d.scaleFactor
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "xScale,yScale"
                duration: d.animationDuration
                easing.type: Easing.OutQuad
            }
        }
    ]

    // 鼠标交互
    MouseArea {
        anchors.fill: parent
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
    }

    // 子组件
    Component {
        id: com_icon
        GaIcon {
            iconSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            iconColor: control.iconColor
            iconSource: control.iconSource
        }
    }

    Component {
        id: com_row
        RowLayout {
            spacing: control.spacing_
            AutoLoader {
                sourceComponent: com_icon
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            Text {
                text: control.text
                visible: control.text !== ""
                color: d.textColor
                font: control.font
                elide: Text.ElideRight
            }
        }
    }

    Component {
        id: com_column
        ColumnLayout {
            spacing: control.spacing_
            AutoLoader {
                sourceComponent: com_icon
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            Text {
                text: control.text
                visible: control.text !== ""
                color: d.textColor
                font: control.font
                elide: Text.ElideRight
            }
        }
    }
}
