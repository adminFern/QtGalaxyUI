import QtQuick

import QtQuick.Templates as T
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import GalaxyUI

T.ComboBox {
   id: root
   implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                           implicitContentWidth + leftPadding + rightPadding)
   implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

   // -------------------- 样式属性 --------------------
   property int itemHeight: 32
   property int visibleItemCount:6
   property bool isEditing: false
   //颜色
   property color itemSelectedColor: "#004080"
   property color itemHoverColor: "#ADD8E6"
   property color itemPressedColor: "#4682B4"


   // 在根组件添加 currentIndex 变化监听
   onCurrentIndexChanged: {
      if (!d.isEditingMode && currentIndex >= 0 && count > 0) {
         displayText.text = model.get(currentIndex).text
      }
   }
   // 将函数定义移到组件根作用域（放在最后）：
   // -------------------- 编辑模式控制函数 --------------------
   function enterEditMode() {
      if (!root.isEditing || currentIndex < 0) return

      d.isEditingMode = true
      textInput.text = displayText.text
      textInput.visible = true
      textInput.forceActiveFocus()
      // textInput.selectAll()
      displayText.visible = false
   }

   function exitEditMode(saveChanges) {
      if (!d.isEditingMode) return

      if (saveChanges && currentIndex >= 0 && root.count > 0) {
         if (model.get(currentIndex).text !== undefined) {
            model.setProperty(currentIndex, "text", textInput.text)
         }
         displayText.text = textInput.text
      } else {
         // 取消编辑时恢复原文本
         displayText.text = model.get(currentIndex).text
      }

      textInput.visible = false
      displayText.visible = true
      d.isEditingMode = false
   }

   // -------------------- 私有属性 --------------------
   QtObject {
      id: d
      property int radius: 4
      property int dropDownHeight: Math.min(visibleItemCount * itemHeight, root.count * itemHeight)
      // 使用系统主题颜色
      property color indicatorHover: Theme.isDark ? Qt.rgba(1, 1, 1, 0.03) : Qt.rgba(0, 0, 0, 0.03)
      property color indicatorPressed: Theme.isDark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.1)
      // 鼠标位置状态
      property bool isInBackground: false//是否处于后面
      property bool isInIndicator: false //是否在指示器中
      property bool isEditingMode: false   // 当前是否处于编辑模式（内部状态）
   }

   // -------------------- 背景样式 --------------------
   background: Rectangle {
      implicitWidth: root.width
      implicitHeight: root.height
      radius: d.radius
      border.width: 1

      color: {
         if (d.isInIndicator) {
            return "transparent" // 鼠标在指示器时背景透明
         } else if (mouseArea.pressed && d.isInBackground) {
            return Theme.itemPressColor // 背景按下状态
         } else if (d.isInBackground) {
            return Theme.itemHoverColor // 背景悬停状态
         } else {
            return "transparent" // 默认透明
         }
      }

      border.color: {
         // if (!root.enabled) return Theme.itemDisabledColor
         if (mouseArea.containsPress) return Theme.borderPresslColor
         if (d.isInBackground || d.isInIndicator) return Theme.borderHoverlColor
         return Theme.borderNormalColor
      }
      layer.enabled: true
      layer.effect: DropShadow {
         radius: 8
         samples: 12
         color:{
            if (d.isInBackground || d.isInIndicator) return  Theme.itemfocuscolor
            return  Theme.isDark?Qt.rgba(1,1,1,0.6) : Qt.rgba(0,0,0,0.6)
         }
      }
      Behavior on color { ColorAnimation { duration: 300 } }
   }
   // -------------------- 下拉指示器 --------------------
   indicator: Rectangle {
      id:indicatorRec
      implicitWidth: root.height - 8
      implicitHeight: root.height - 8
      anchors {
         right: parent.right
         verticalCenter: parent.verticalCenter
         rightMargin: 5
      }
      radius: d.radius
      color: {
         if (mouseArea.pressed && d.isInIndicator) {
            return d.indicatorPressed // 指示器按下状态
         } else if (d.isInIndicator) {
            return d.indicatorHover // 指示器悬停状态
         } else {
            return "transparent" // 默认透明
         }
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
            angle: popup.visible && count >0? 180 : 0  // 根据弹出状态旋转180度
            Behavior on angle {  // 平滑的旋转动画
               NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }
         }
      }

   }
   // -------------------- 统一鼠标区域 --------------------
   MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true

      onPositionChanged: {
         // 检测鼠标是否在指示器区域
         var indicatorPos = mapToItem(indicator, mouseX, mouseY)
         d.isInIndicator = indicator.contains(Qt.point(indicatorPos.x, indicatorPos.y))
         // 检测鼠标是否在背景区域（且不在指示器区域）
         d.isInBackground = containsMouse && !d.isInIndicator
         cursorShape = d.isInIndicator ? Qt.PointingHandCursor : Qt.ArrowCursor


      }
      onReleased: {
         // 编辑模式下禁止点击指示器打开下拉框
         if (d.isInIndicator && containsMouse && !d.isEditingMode) {
            popup.visible ? popup.close() : popup.open()
         }
      }
      onExited: {
         // 鼠标离开时重置所有状态
         d.isInBackground = false
         d.isInIndicator = false
      }
      onDoubleClicked: {


         // 仅在允许编辑且双击背景区域时进入编辑模式
         if (root.isEditing && d.isInBackground && !d.isEditingMode) {
            enterEditMode()
         }

      }
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

      // 正常显示的文本
      Text {
         id: displayText
         text: currentIndex >= 0 && count !== 0 ? model.get(currentIndex).text : ""
         font: root.font
         color: Theme.textColor
         verticalAlignment: Text.AlignVCenter
         elide: Text.ElideRight
         anchors.verticalCenter: parent.verticalCenter
         visible: !textInput.visible  // 编辑时隐藏
         width: parent.width
                - (icon.width + spacing)
                - (indicatorRec.width + indicatorRec.anchors.rightMargin)-14

      }

      // 编辑时显示的输入框
      TextInput {
         clip: true
         id: textInput
         text: displayText.text  // 初始化为当前显示文本
         font: root.font
         verticalAlignment: Text.AlignVCenter
         anchors.verticalCenter: parent.verticalCenter
         selectionColor: "transparent"
         selectedTextColor: Theme.textColor
         color: Theme.textColor
         width:displayText.width//parent.width-icon.width + parent.spacing+icon.padding
         ///selectByMouse: true  // 允许鼠标选择文本

         // 按回车键保存并退出编辑
         Keys.onReturnPressed: exitEditMode(true)
         Keys.onEnterPressed: exitEditMode(true)
         // 按ESC键取消编辑
         Keys.onEscapePressed: exitEditMode(false)

         // 失去焦点时自动保存
         onActiveFocusChanged: {
            if (!activeFocus && visible) {
               exitEditMode(true)
            }
         }
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
            duration: 300
            easing.type: Easing.OutQuad
         }
         NumberAnimation {
            property: "scale"
            from: 0.9
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
         }
      }

      // 关闭动画
      exit: Transition {
         NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 300
            easing.type: Easing.InQuad
         }
         NumberAnimation {
            property: "scale"
            from: 1.0
            to: 0.9
            duration: 300
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

      background: Rectangle {
         radius: d.radius
         color: "transparent"
         border.color:Theme.isDark?Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.2)
         border.width: 1
         layer.enabled: true
         layer.effect: DropShadow {
            radius: 8
            samples: 16
            color:Theme.isDark?Qt.rgba(1,1,1,0.6) : Qt.rgba(0,0,0,0.6)
         }

      }
   }

   // -------------------- 选项代理 --------------------
   delegate: ItemDelegate {
      width: popup.width - popup.leftPadding - popup.rightPadding
      height: itemHeight
      highlighted: root.highlightedIndex === index
      hoverEnabled: true
      padding: 0
      background: Rectangle {
         radius: d.radius
         color: {
            if (currentIndex === index) return itemSelectedColor
            if (pressed) return itemHoverColor
            if(hovered) return itemPressedColor
            return "transparent"
         }
      }
      contentItem: Row {
         spacing: 3
         padding: 2
         AutoLoader{
            id: iconLoader
               active: model.icon !== undefined
               visible: active
               width: active ? root.itemHeight*0.5 : 0
               height: width
               anchors.verticalCenter: parent.verticalCenter
               sourceComponent: GaIcon {
                     iconSize: root.itemHeight*0.5
                     iconSource: model.icon
                     iconColor: {
                         if (currentIndex === index) {
                             return Theme.isDark ? "black" : "white"
                         }
                         return Theme.textColor
                     }
                 }
         }



         Text {
            text: model.text || modelData || ""
            font: root.font
            color: currentIndex === index ? (Theme.isDark ? "black" : "white") : Theme.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft    // 左对齐（默认）
            elide: Text.ElideRight
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
         }
      }
   }

}
