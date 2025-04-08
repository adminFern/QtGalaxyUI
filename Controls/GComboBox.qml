import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Controls.Basic
import GalaxyUI

T.ComboBox {
    id: root

    // -------------------- 基础属性 --------------------
    implicitWidth: 180    // 默认宽度
    implicitHeight: 40    // 默认高度
    width: implicitWidth  // 实际宽度
    height: implicitHeight // 实际高度

    // 定义打开和关闭方法
    function open() {
        if( popup.visible===false) popup.visible = true
    }

    function close() {
         if( popup.visible===true) popup.visible = false
    }

    // -------------------- 样式属性 --------------------
    property int itemHeight: 32 // 每个选项的高度
    property int visibleItemCount: 6  // 可视区域内显示的选项数量
    // 颜色配置
    property color itemSelectedColor: "#004080"  // 选中项背景色
    property color itemHoverColor: "#ADD8E6"    // 悬停项背景色
    property color itemPressedColor:"#4682B4"    // 按下项背景色

    // -------------------- 私有属性 --------------------
    QtObject {
        id: d  // 私有数据对象
        property int radius: 4  // 圆角半径
        property int borderWidth: 1  // 边框宽度
        property int dropDownHeight: Math.min(visibleItemCount * itemHeight+11, root.count * itemHeight+8)  // 下拉框高度计算
        property int pressedIndex: -1  // 当前被按下的项索引
        // 指示器颜色
        property color indicatorHover: Theme.isDark? Qt.rgba(1, 1, 1, 0.06):Qt.rgba(0, 0, 0, 0.03)
        property color indicatorPressed: Theme.isDark?Qt.rgba(1, 1, 1, 0.1):Qt.rgba(0, 0, 0, 0.1)
        // 判断当前选中项是否有图标
        function hasIcon() {
            if (root.currentIndex < 0) return false
            var item = root.model.get(root.currentIndex)
            return item && item.icon
        }
        property bool hoveredIndicator: false  // 鼠标悬停在指示器上
        property bool pressedIndicator: false  // 鼠标按压在指示器上
    }

    // -------------------- 自定义样式 --------------------

    //背景
    background: Rectangle {
        id: comboBoxbgk
        implicitWidth: root.width
        implicitHeight: root.height
        radius: d.radius
        border.width: d.borderWidth
        color: {
            if (root.down && !d.pressedIndicator) {  // 按下但不在指示器上
                return Theme.itemPressColor
            } else if (root.hovered && !d.hoveredIndicator) {  // 悬停但不在指示器上
                return Theme.itemHoverColor
            } else {
                return "transparent"   // 默认或鼠标在指示器上
            }
        }



        border.color: root.down ? Theme.borderPresslColor :
                                  root.hovered ? Theme.borderHoverlColor :
                                                 Theme.borderNormalColor
    }

    indicator: Rectangle {
        id: comboBoindicator
        implicitWidth: root.height - 8
        implicitHeight: root.height - 8
        anchors.right: comboBoxbgk.right
        anchors.verticalCenter: comboBoxbgk.verticalCenter
        anchors.rightMargin: 5
        radius: d.radius
        color: {
            if (d.pressedIndicator) {
                return d.indicatorPressed  // 按压状态颜色
            } else if (d.hoveredIndicator) {
                return d.indicatorHover  // 悬停状态颜色
            } else {
                return "transparent"      // 默认状态
            }
        }

        // 鼠标交互区域
        MouseArea {
            id: indicatorMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: d.hoveredIndicator = true
            onExited: d.hoveredIndicator = false
            onPressed: d.pressedIndicator = true
            onReleased: d.pressedIndicator = false
            onClicked: popup.visible=true

        }
        GaIcon {
            anchors.centerIn: comboBoindicator
            id: icon
            iconColor: Theme.textColor
            iconSize: parent.height / 2
            iconSource: Icons.ChevronDown

            transform: Rotation {  // 添加旋转动画
                origin.x: icon.width / 2
                origin.y: icon.height / 2
                axis { x: 0; y: 0; z: 1 }
                angle: popup.opened ? 180 : 0  // 根据弹出状态旋转180度
                Behavior on angle {  // 平滑的旋转动画
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }


        }
    }

    contentItem: Text {
        text: root.displayText
        font: root.font
        color: Theme.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: comboBoindicator.width + 15
        elide: Text.ElideRight
    }

    popup: T.Popup {



        id: popup
        y: root.height + 1
        width: root.width
        height: d.dropDownHeight
        padding: 4

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
            highlightMoveDuration: 0

            ScrollBar.vertical: GaScrollBar {}
        }

        //背景样式
        background: Shadow {
            color: Theme.isDark ? Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.6)
            Rectangle {
                id: bg
                anchors.fill: parent
                radius: d.radius
                color: root.down ? Theme.itemPressColor :
                                   root.hovered ? Theme.itemHoverColor :
                                                  Theme.itemNormalColor
                border.color: root.down ? Theme.borderPresslColor :
                                          root.hovered ? Theme.borderHoverlColor :
                                                         Theme.borderNormalColor
                border.width: 1
            }
        }



    }

    delegate: ItemDelegate {

        width: popup.width
        height: itemHeight
        text: modelData ? modelData : ""
        highlighted: root.highlightedIndex === index
        hoverEnabled: true
        background: Rectangle {
            color: highlighted ? itemSelectedColor :
                                 pressed ? itemPressedColor :
                                           hovered ? itemHoverColor : "transparent"
            radius: 0
        }

        contentItem: Text {
            text: modelData ? modelData : ""
            font: root.font
            color: Theme.textColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
            elide: Text.ElideRight
        }
    }


}
// // 当前选中项的图标
// GaIcon {
//     id: comboIconLoader
//     anchors.leftMargin: 8
//     anchors.verticalCenter: parent.verticalCenter
//     anchors.left: parent.left
//     iconColor: Theme.textColor
//     iconSize: comboBox.height*0.5
//     iconSource: {
//         if (root.currentIndex < 0) return 0
//         var item = root.model.get(root.currentIndex)
//         return item.icon || 0
//     }
//     visible: root.model && root.currentIndex >= 0 && root.currentIndex < root.count ?
//                  (root.model.get(root.currentIndex).icon !== undefined && root.model.get(root.currentIndex).icon !== "") : false
// }

// // 当前选中项的文本
// Text {
//     id: displayText
//     color: Theme.textColor
//     anchors {
//         left: d.hasIcon() ? comboIconLoader.right : parent.left
//         leftMargin: 8
//         verticalCenter: parent.verticalCenter
//         right: indicatorRec.left
//         rightMargin: 8
//     }
//     text: root.displayText
//     elide: Text.ElideRight
// }


// // -------------------- 自定义下拉弹出框 --------------------
// popup: T.Popup {
//     y: root.height + 2
//     width: root.width
//     height: d.dropDownHeight
//     padding: 3
//     closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

//     // 背景样式
//     background: Shadow {
//         color: Theme.isDark ? Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.6)
//         Rectangle {
//             id: bg
//             anchors.fill: parent
//             radius: d.radius
//             color: root.down ? Theme.itemPressColor :
//                               root.hovered ? Theme.itemHoverColor :
//                                           Theme.itemNormalColor
//             border.color: root.down ? Theme.borderPresslColor :
//                                     root.hovered ? Theme.borderHoverlColor :
//                                                 Theme.borderNormalColor
//             border.width: 1
//         }
//     }

//     // 内容区域
//     contentItem: Item {
//         clip: true
//         width: popup.width - popup.padding * 2
//         height: popup.height - popup.padding * 2

//         // 选项列表视图
//         ListView {
//             id: listView
//             anchors.fill: parent
//             clip: true
//             model: root.model
//             currentIndex: root.highlightedIndex
//             boundsBehavior: Flickable.StopAtBounds
//             snapMode: ListView.SnapToItem
//             spacing: 1
//             cacheBuffer: Math.min(400, root.count * root.itemHeight / 2)
//             displayMarginBeginning: Math.min(200, root.count * root.itemHeight / 3)
//             displayMarginEnd: Math.min(200, root.count * root.itemHeight / 3)
//             ScrollBar.vertical: GaScrollBar {}

//             // 选项项代理
//             delegate: ItemDelegate {
//                 id: delegateItem
//                 width: ListView.view.width
//                 height: root.itemHeight
//                 highlighted: root.highlightedIndex === index
//                 hoverEnabled: true

//                 // 背景样式
//                 background: Rectangle {
//                     id: delegateBg
//                     radius: d.radius
//                     anchors.fill: parent
//                     color: {
//                         if (d.pressedIndex === index) return root.itemPressedColor
//                         else if (delegateItem.hovered && !delegateItem.highlighted) return root.itemHoverColor
//                         else if (delegateItem.highlighted) return root.itemSelectedColor
//                         else return "transparent"
//                     }
//                     Behavior on color {
//                         ColorAnimation {
//                             duration: 300
//                             easing.type: Easing.OutQuad
//                         }
//                     }
//                 }

//                 // 内容
//                 contentItem: Item {
//                     anchors.fill: parent

//                     // 动态加载图标
//                     Loader {
//                         id: iconLoader
//                         anchors {
//                             left: parent.left
//                             leftMargin: 8
//                             verticalCenter: parent.verticalCenter
//                         }
//                         width: root.itemHeight*0.6
//                         height: root.itemHeight*0.6
//                         active: model.icon !== undefined
//                         sourceComponent: GaIcon {
//                             iconSource: model.icon || 0
//                             iconSize: Math.min(iconLoader.width, iconLoader.height)
//                             iconColor: {
//                                 if((d.pressedIndex === index || delegateItem.highlighted) && Theme.isDark){
//                                     return "black"
//                                 }
//                                 if((d.pressedIndex === index || delegateItem.highlighted) && !Theme.isDark){
//                                     return "white"
//                                 }
//                                 return Theme.textColor
//                             }
//                         }
//                     }

//                     // 选项文本
//                     Text {
//                         anchors.leftMargin: 8
//                         anchors.verticalCenter: parent.verticalCenter
//                         anchors.left: model.icon ? iconLoader.right : parent.left
//                         width: parent.width - 16
//                         text: model.text || ""
//                         color: {
//                             if((d.pressedIndex === index || delegateItem.highlighted) && Theme.isDark){
//                                 return "black"
//                             }
//                             if((d.pressedIndex === index || delegateItem.highlighted) && !Theme.isDark){
//                                 return "white"
//                             }
//                             return Theme.textColor
//                         }
//                         elide: Text.ElideRight
//                     }
//                 }

//                 // 鼠标区域
//                 MouseArea {
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape: pressed ? Qt.PointingHandCursor : Qt.ArrowCursor

//                     onPressed: {
//                         if (!delegateItem.highlighted) {
//                             d.pressedIndex = index
//                         }
//                     }
//                     onReleased: {
//                         d.pressedIndex = -1
//                         root.currentIndex = index
//                         root.popup.close()
//                     }
//                     onCanceled: d.pressedIndex = -1
//                     onExited: d.pressedIndex = -1
//                 }
//             }
//         }
//     }

//     enter: Transition {
//         ParallelAnimation {
//             NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 300 }
//             NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 400; easing.type: Easing.OutBack }
//         }
//     }

//     exit: Transition {
//         ParallelAnimation {
//             NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 300 }
//             NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 400; easing.type: Easing.InQuad }
//         }
//     }
// }

// // 监听模型变化
// Connections {
//     target: root.model
//     function onDataChanged() { root.modelDataChanged() }
//     function onRowsInserted() { root.modelDataChanged() }
//     function onRowsRemoved() { root.modelDataChanged() }
// }

