import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import GalaxyUI

T.ComboBox {
   id: root
   // -------------------- 基础属性 --------------------
   implicitWidth: 180
   implicitHeight: itemHeight
   // -------------------- 样式属性 --------------------
   property int itemHeight: 32
   property int visibleItemCount:6

   //颜色
   property color itemSelectedColor: "#004080"
   property color itemHoverColor: "#ADD8E6"
   property color itemPressedColor: "#4682B4"


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
         samples: 20
         color:{
          if (d.isInBackground || d.isInIndicator) return  Theme.itemfocuscolor
           return  Theme.isDark?Qt.rgba(1,1,1,0.6) : Qt.rgba(0,0,0,0.6)
         }
      }
      Behavior on color { ColorAnimation { duration: 300 } }
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
            angle: popup.visible ? 180 : 0  // 根据弹出状态旋转180度
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
         if (d.isInIndicator && containsMouse) {
            // 点击指示器切换弹出状态
            popup.visible ? popup.close() : popup.open()
         }
      }
      onExited: {
         // 鼠标离开时重置所有状态
         d.isInBackground = false
         d.isInIndicator = false
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

      Text {
         text: currentIndex>= 0 && count!==0 ?model.get(currentIndex).text: displayText
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
      background: Rectangle {
         radius: d.radius
         color: {
            if (currentIndex === index) return itemSelectedColor
            if (pressed) return itemHoverColor
            if(hovered) return itemPressedColor
            return "transparent"
         }
         // 背景色变化动画
         Behavior on color {
            ColorAnimation {
               duration: 350
               easing.type: Easing.OutQuad
            }
         }

      }
      contentItem: Row {
         spacing: 3
         GaIcon {
            visible: model.icon !== undefined
            iconSize: root.itemHeight*0.5
            iconSource: model.icon || 0
            anchors.verticalCenter: parent.verticalCenter
            iconColor: {
               if (currentIndex === index) {
                  return Theme.isDark ? "black" : "white"
               }
               return Theme.textColor
            }
         }
         Text {
            text: model.text || modelData || ""
            font: root.font
            color: currentIndex === index ? (Theme.isDark ? "black" : "white") : Theme.textColor
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
         }
      }
   }
}
