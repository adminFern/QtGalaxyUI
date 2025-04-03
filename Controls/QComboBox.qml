import QtQuick
import QtQuick.Controls

Item {
  id: root
  implicitWidth: 180
  implicitHeight: 40
  width: implicitWidth
  height: implicitHeight
  // 在根组件中添加
  property int pressedIndex: -1  // 当前按压的项目索引
  property int lastHighlightedIndex: -1  // 上一次高亮的项目索引
  // 公共属性
  property var model: [ "人生得意须尽欢", "莫使金樽空对月", "莫使金樽空对月", "莫使金樽空对月",  "莫使金樽空对月", "莫使金樽空对月",
    "莫使金樽空对月", "莫使金樽空对月", "莫使金樽空对月"]
  property string currentText: ""
  property int currentIndex: -1
  signal activated(int index)

  //私有属性和方法容器
  QtObject {
    id: d
    property int itemHeight: 32  //项目高度
    property int visibleItemCount: 5 //显示项目最大数
    property int margin: 10 //边距
    property int radius: 4 //圆角
    property int borderWidth: 1

    //颜色
    property color hoverBackground: Qt.rgba(0,0,0,0.06)
    property color semiTransparentBg: Qt.rgba(1,1,1,0.1)
    property color indicatorHover: Qt.rgba(0, 0, 0, 0.06)
    property color indicatorPressed: Qt.rgba(0, 0, 0, 0.1)
    property color borderHover: Qt.rgba(0.57, 0.57, 0.57, 0.9)
    property color borderNormal: Qt.rgba(0,0,0,0.25)
    property int dropDownHeight: Math.min(visibleItemCount * itemHeight, model.length * itemHeight)+6
  }

  //---------------组合框
  Rectangle {
    id: comboBox
    width: root.width
    height: root.height
    radius: d.radius
    border.width: d.borderWidth
    color: {
      if (mainMouseArea.containsMouse && root.currentIndex == -1) {
        return mainMouseArea.isIndicatorHovered ? d.semiTransparentBg : d.hoverBackground
      } else {
        return d.semiTransparentBg
      }
    }
    border.color: mainMouseArea.containsMouse ? d.borderHover : d.borderNormal

    Text {
      id: displayText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 5
      width: comboBox.width - indicatorRec.width - 8
      text: "定位在做右边  elide: Text.ElideRight  elide: Text.ElideRight"
      elide: Text.ElideRight
    }

    //指示器矩形
    Rectangle {
      id: indicatorRec
      radius: d.radius
      anchors.right: parent.right
      anchors.rightMargin: 3
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height - 6
      width: parent.height - 6
      color: {
        if (mainMouseArea.pressed && mainMouseArea.isIndicatorHovered) {
          return d.indicatorPressed
        } else if (mainMouseArea.containsMouse && mainMouseArea.isIndicatorHovered) {
          return d.indicatorHover
        } else {
          return "transparent"
        }
      }
      QIcon {
        id: icon
        iconSize: parent.height / 2
        anchors.centerIn: parent
        icosource: FluentIcons.q_ChevronDown
        transform: Rotation {
          id: rotation
          origin.x: icon.width / 2
          origin.y: icon.height / 2
          axis { x: 0; y: 0; z: 1 }
          Behavior on angle {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutCubic
            }
          }
        }
      }
    }

    //组合框鼠标区域
    MouseArea {
      id: mainMouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.ArrowCursor
      property bool isIndicatorHovered: false

      onPositionChanged: {
        isIndicatorHovered = mouseX >= indicatorRec.x &&
            mouseX <= indicatorRec.x + indicatorRec.width &&
            mouseY >= indicatorRec.y &&
            mouseY <= indicatorRec.y + indicatorRec.height
        cursorShape = isIndicatorHovered ? Qt.PointingHandCursor : Qt.ArrowCursor
      }
      onClicked: {
        if (isIndicatorHovered) {
          popup.opened ? popup.close() : popup.open()
          console.log("打开列表")
        }
      }
    }
  }

  //---------------组合框
  Popup {
    id: popup
    y: comboBox.height + 2
    width: comboBox.width
    height: d.dropDownHeight
    padding: 3
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    //property Item currentItem: null  // 新增：记录当前高亮项

    background: Shadow {
      Rectangle {
        id: bg
        anchors.fill: parent
        radius: d.radius
        color: "#F5F5F5"
        opacity: 0.95
        border.color: "#BDBDBD"
        border.width: 1
      }
    }

    contentItem: Item {
      ListView {
        id: listView
        spacing: 2
        anchors.fill: parent
        anchors.margins: 1
        clip: true
        model: root.model
        currentIndex: root.currentIndex

        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
        cacheBuffer: Math.min(400, root.model.length * d.itemHeight / 2)
        displayMarginBeginning: Math.min(200, root.model.length * d.itemHeight / 3)
        displayMarginEnd: Math.min(200, root.model.length * d.itemHeight / 3)

        delegate: Rectangle {
          width: listView.width
          height: d.itemHeight
          color: {
            if (root.pressedIndex === index) return "#0078D7"
            else if (root.currentIndex === index) return "#0078D7"//释放的颜色
            else return "transparent"
          }
          Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 8
            width: parent.width - 16
            text: modelData
            color: (root.pressedIndex === index || root.currentIndex === index) ? "white" : "black"
            elide: Text.ElideRight
            maximumLineCount: 1
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
              // 在按压时立即更新状态
              root.lastHighlightedIndex = root.currentIndex // 保存上一次选中的索引
              root.currentIndex = index // 更新当前选中的索引
              root.pressedIndex = index // 设置按压状态
              root.activated(index) // 触发信号
            }
            onReleased: {
              root.pressedIndex = -1 // 清除按压状态
              popup.close() // 关闭弹出框
            }
            onCanceled: {
              root.pressedIndex = -1 // 清除按压状态
            }
            onExited: {
              root.pressedIndex = -1 // 鼠标移出时清除按压状态
            }
          }
        }
      }
    }
  }
}


