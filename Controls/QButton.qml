import QtQuick 2.15
import GalaxyUI 1.0

Rectangle {
    id: root
    property string text: ""
    property alias font: label.font
    property bool isFlat: false
    property int isRadius: 4

    // 自动计算宽度
    implicitWidth: Math.max(d.minimumWidth, label.implicitWidth + 20)
    implicitHeight: d.fixedHeight

    // 颜色和动画配置
    QtObject {
        id: d
        // 颜色配置
        property color normalColor: Theme.dark ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(1, 1, 1, 0.15)
        property color hoverColor: Theme.dark ?Qt.rgba(0, 0, 0, 0.15) : Qt.rgba(0, 0, 0, 0.08)  // 天蓝色悬停色
        property color pressedColor: Theme.dark ?Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(0, 0, 0, 0.2)    // 按压绿色

        // 尺寸配置
        property int minimumWidth: 40
        property int fixedHeight: 30

        // 动画配置
        property int colorAnimationDuration: 300
        property int scaleAnimationDuration: 100
        property real normalScale: 1.0
        property real pressedScale: 0.95
    }

    // 基础样式
    radius: isRadius
    border.width: 1
    border.color: Theme.ItemBordercolor

    // 颜色状态管理（使用Behavior实现平滑过渡）
    color: d.normalColor
    Behavior on color {
        ColorAnimation {
            duration: d.colorAnimationDuration
            easing.type: Easing.OutCubic
        }
    }

    // 缩放状态管理
    scale: d.normalScale
    Behavior on scale {
        NumberAnimation {
            duration: d.scaleAnimationDuration
            easing.type: Easing.OutBack
        }
    }

    // 文本标签
    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        font.pixelSize: 14
        color: Theme.ItemTextColor
    }

    // 鼠标交互区域
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        // 悬停状态变化
        onContainsMouseChanged: {
            if (containsMouse && !pressed) {
                root.color = d.hoverColor;
            } else if (!pressed) {
                root.color = d.normalColor;
            }
        }

        // 按压状态变化
        onPressedChanged: {
            if (pressed) {
                root.color = d.pressedColor;
                root.scale = d.pressedScale;
                root.pressed()
            } else {
                root.scale = d.normalScale;
                // 释放后根据是否悬停决定颜色
                root.color = containsMouse ? d.hoverColor : d.normalColor;

                 root.clicked(); // 触发点击信号
            }
        }
    }



    // 组件信号
    signal clicked()
    signal pressed()// 按压开始信号
}
