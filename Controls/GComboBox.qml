import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Controls.Basic
import GalaxyUI

T.ComboBox {
    id: root

    // -------------------- 基础属性 --------------------
    implicitWidth: 180
    implicitHeight: 40

    // -------------------- 样式属性 --------------------
    property int itemHeight: 36
    property int visibleItemCount: 6
    property color itemSelectedColor: "#004080"
    property color itemHoverColor: "#ADD8E6"
    property color itemPressedColor: "#4682B4"
    // -------------------- 修正只读属性问题 --------------------
    // 移除对hoverEnabled和pressed的修改，改用自定义属性
    // 自定义状态属性


    property bool bgHovered: false
    property bool bgPressed: false
    property bool indicatorActive: false

    // -------------------- 私有属性 --------------------
    QtObject {
        id: d
        property int radius: 4
        property int borderWidth: 1
        property int dropDownHeight: Math.min(visibleItemCount * itemHeight, root.count * itemHeight)

        // 使用系统主题颜色
        property color indicatorHover: Theme.isDark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.03)
        property color indicatorPressed: Theme.isDark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.1)

        property int animationDuration: 300  // 动画持续时间(毫秒)

    }






    // -------------------- 背景样式 --------------------
    background: Rectangle {
        implicitWidth: root.width
        implicitHeight: root.height
        radius: d.radius
        border.width: d.borderWidth

        color:root.indicatorActive ? "transparent" :
                                     root.bgPressed ? Theme.itemPressColor :
                                                      root.bgHovered ? Theme.itemHoverColor : "transparent"





        border.color: root.down ? Theme.borderPresslColor :
                                  root.hovered ? Theme.borderHoverlColor :
                                                 Theme.borderNormalColor



    }






    // -------------------- 下拉指示器 --------------------
    indicator: Rectangle {
        implicitWidth: root.height - 8
        implicitHeight: root.height - 8
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 5
        }
        radius: d.radius
        // color: root.down ? d.indicatorPressed :
        //                    root.hovered ? d.indicatorHover : "transparent"

        color: {
            if (indicatorMouseArea.pressed) return d.indicatorPressed
            if (indicatorMouseArea.containsMouse) return d.indicatorHover
            return "transparent"
        }
        Behavior on color { ColorAnimation { duration: 300 } }

        GaIcon {
            id: icon
            anchors.centerIn: parent
            iconColor: Theme.textColor
            iconSize: parent.height / 2
            iconSource: Icons.ChevronDown
            transform: Rotation{
                origin.x: icon.width / 2
                origin.y: icon.height / 2
                axis { x: 0; y: 0; z: 1 }
                angle: popup.visible ? 180 : 0  // 根据弹出状态旋转180度
                Behavior on angle {  // 平滑的旋转动画
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }
        }

    }


    // -------------------- 优化后的事件处理 --------------------
    // 主背景区域
    MouseArea {
        id: bgMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: root.bgHovered = true
        onExited: {
            root.bgHovered = false
            root.bgPressed = false
        }

        function handlePress(mouse) {
            root.bgPressed = true
            mouse.accepted = !indicatorMouseArea.containsMouse
        }

        function handlePositionChange(mouse) {
            root.indicatorActive = indicatorMouseArea.containsMouse
            return false
        }

        onPressed:(mouse)=> {
                      handlePress(mouse)
                  }


        onPositionChanged :(mouse)=>{
                               handlePositionChange(mouse)}
        onReleased: root.bgPressed = false
    }

    // 指示器区域
    MouseArea {
        id: indicatorMouseArea
        width: indicator.width
        height: indicator.height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 5
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onPressed: root.indicatorActive = true
        onReleased: if (containsMouse) popup.visible ? popup.close() : popup.open()
        onExited: root.indicatorActive = false
    }






    // -------------------- 内容项 --------------------
    contentItem: Row {
        leftPadding: 5
        spacing: 4
        GaIcon {
            visible: currentIndex >= 0 ? (model.get(currentIndex).icon ? true : false) : false
            iconSize: root.height*0.5
            iconSource: currentIndex < 0 ? 0 : (model.get(currentIndex).icon || 0)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: currentIndex>= 0?root.model.get(currentIndex).text: ""
            font: root.font
            color: Theme.textColor
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // -------------------- 下拉菜单 --------------------
    popup: T.Popup {

        id: popup
        y: root.height + 2
        width: root.width
        height: d.dropDownHeight
        padding: 4


        // 弹出动画
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: d.animationDuration
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                property: "scale"
                from: 0.9
                to: 1.0
                duration: d.animationDuration
                easing.type: Easing.OutBack
            }
        }

        // 关闭动画
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: d.animationDuration
                easing.type: Easing.InQuad
            }
            NumberAnimation {
                property: "scale"
                from: 1.0
                to: 0.9
                duration: d.animationDuration
                easing.type: Easing.InBack
            }
        }

        contentItem: ListView {
            clip: true
            spacing: 1
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
            ScrollBar.vertical: GaScrollBar {
                visible: root.count > root.visibleItemCount
                anchors.right: parent.right
            }

        }

        background: Shadow {
            color: Theme.isDark ? Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.6)
            Rectangle {
                anchors.fill: parent
                radius: d.radius
                color: Theme.itemNormalColor
                border.color: Theme.textColor
                border.width: 1
            }
        }
    }

    // -------------------- 选项代理 --------------------
    delegate: ItemDelegate {
        width: popup.width - popup.leftPadding - popup.rightPadding
        height: itemHeight
        highlighted: root.highlightedIndex === index
        hoverEnabled: true
        //cursorShape: pressed ? Qt.PointingHandCursor : Qt.ArrowCursor
        background: Rectangle {
            radius: d.radius
            color: {
                if (currentIndex === index) return "cornflowerblue"
                if (pressed) return "darkorange"
                if(hovered) return "blueviolet"
                return "transparent"
            }
            // 背景色变化动画
            Behavior on color {
                ColorAnimation {
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

        }



        contentItem: Row {
            spacing: 4
            GaIcon {
                visible: model.icon !== undefined
                iconSize: root.itemHeight*0.5
                iconSource: model.icon || 0
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: model.text || modelData || ""
                font: root.font
                color: Theme.textColor
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
