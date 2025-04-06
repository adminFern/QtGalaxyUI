import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"

Window {
    id: root
    width: 650
    height: 480
    visible: true
    title: qsTr("流畅水波纹主题切换演示")

    // 颜色定义
    property color lightColor: "white"
    property color darkColor: "#1E1E1E"

    // 动画状态
    property color currentBgColor: Theme.isDark ? darkColor : lightColor
    property color targetBgColor: currentBgColor
    property real rippleProgress: 0
    property point rippleCenter: Qt.point(width/2, height/2)
    property bool animating: false

    // 背景层（双缓冲避免闪烁）
    Rectangle {
        id: bg
        anchors.fill: parent
        color: currentBgColor
    }

    // 波纹效果层（使用径向渐变）
    Canvas {
        id: rippleCanvas
        anchors.fill: parent
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // 创建径向渐变实现平滑边缘
            var gradient = ctx.createRadialGradient(
                rippleCenter.x, rippleCenter.y, 0,
                rippleCenter.x, rippleCenter.y,
                rippleProgress * Math.max(width, height) * 0.8
            )

            gradient.addColorStop(0, targetBgColor)
            gradient.addColorStop(0.95, targetBgColor)
            gradient.addColorStop(1, Qt.rgba(
                targetBgColor.r,
                targetBgColor.g,
                targetBgColor.b,
                0
            ))

            ctx.fillStyle = gradient
            ctx.beginPath()
            ctx.arc(rippleCenter.x, rippleCenter.y,
                   rippleProgress * Math.max(width, height) * 0.8,
                   0, Math.PI * 2)
            ctx.fill()
        }
    }

    // 流畅的动画序列
    SequentialAnimation {
        id: rippleAnimation

        // 准备阶段
        ScriptAction { script: {
            animating = true
            rippleProgress = 0
            rippleCanvas.opacity = 1
            rippleCanvas.requestPaint()
        }}

        // 主动画阶段
        ParallelAnimation {
            // 波纹扩散
            NumberAnimation {
                target: root
                property: "rippleProgress"
                from: 0
                to: 1.2  // 稍微超过1确保完全覆盖
                duration: 1000
                easing.type: Easing.OutCubic
            }

            // 背景色渐变过渡
            ColorAnimation {
                target: bg
                property: "color"
                to: targetBgColor
                duration: 1200
                easing.type: Easing.InOutQuad
            }
        }

        // 收尾阶段
        ScriptAction { script: {
            completeTransition()
        }}

        // 波纹淡出
        NumberAnimation {
            target: rippleCanvas
            property: "opacity"
            to: 0
            duration: 300
            easing.type: Easing.InCubic
        }

        // 最终清理
        ScriptAction { script: {
            animating = false
            rippleProgress = 0
        }}
    }

    // 完成主题切换
    function completeTransition() {
        currentBgColor = targetBgColor
        Theme.themeType = targetBgColor === darkColor ? Theme.ModeType.Dark : Theme.ModeType.Light
    }

    // 开始流畅的波纹过渡
    function startRippleTransition(isDark) {
        if(animating) return;

        targetBgColor = isDark ? darkColor : lightColor

        // 随机位置（避开边缘）
        rippleCenter = Qt.point(
            Math.random() * (width - 200) + 100,
            Math.random() * (height - 200) + 100
        )

        rippleAnimation.restart()
    }

    // 确保Canvas及时重绘
    Connections {
        target: root
        function onRippleProgressChanged() {
            if(animating) rippleCanvas.requestPaint()
        }
    }

    ListModel {
        id: list
        ListElement { text: "选项1"; icon:"\ue700" }
        ListElement { text: "选项2"; icon:"\ue700" }
        ListElement { text: "选项3"; icon: "\ue700" }
        ListElement { text: "选项4"; icon: "\ue700" }
        ListElement { text: "选项5"; icon: "\ue700" }
        ListElement { text: "选项6"; icon: "\ue700" }
        ListElement { text: "选项7"; icon: "\ue700" }
        ListElement { text: "选项3"; icon: "\ue700" }
    }

    QComboBox {
        x: 5
        y: 5
        id: a
        height: 35
        width: 180
        model: list
    }

    // 主题切换按钮
    Row {
        anchors.centerIn: parent
        spacing: 20

        QButton {
            id: lightButton
            text: "浅色模式"
            width: 120
            height: 40
            onClicked: startRippleTransition(false)
        }

        QButton {
            id: darkButton
            text: "深色模式"
            width: 120
            height: 40
            onClicked: startRippleTransition(true)
        }

        QButton {
            id: systemButton
            text: "系统模式"
            width: 120
            height: 40
            onClicked: {
                const isDark = Theme.ModeType.System === Theme.ModeType.Dark
                startRippleTransition(isDark)
            }
        }
    }

    Connections {
        target: Theme
        function onThemeTypeChanged() {
            console.log("主题类型已改变，新值:", Theme.themeType)
        }
    }
}
