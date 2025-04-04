import QtQuick
import QtQuick.Controls

Item {
  id: root
  implicitWidth: 180
  implicitHeight: 40
  width: implicitWidth
  height: implicitHeight

  property int pressedIndex: -1
  property ListModel model  // 使用标准ListModel
  property int currentIndex: -1
  signal activated(int index)

  QtObject {
    id: d
    property int itemHeight: 32
    property int visibleItemCount: 10
    property int radius: 4
    property int borderWidth: 1
    property int dropDownHeight: Math.min(visibleItemCount * itemHeight, model.count * itemHeight) + 6//修改
    property bool showScrollBar: model.count * itemHeight > dropDownHeight

    // 颜色定义
    property color semiTransparentBg: Qt.rgba(1,1,1,0.1)
    property color indicatorHover: Qt.rgba(0, 0, 0, 0.06)
    property color indicatorPressed: Qt.rgba(0, 0, 0, 0.1)
    property color borderHover: Qt.rgba(0.57, 0.57, 0.57, 0.9)
    property color borderNormal: Qt.rgba(0,0,0,0.25)


    // 判断当前选中项是否有图标
    // 方法2：直接检查（更简洁）
    function hasIcon() {
      if (root.currentIndex < 0) return false
      var item = model.get(root.currentIndex)
      return item && item.icon  // 自动处理undefined/null/空字符串
    }

  }




  Rectangle {
    id: comboBox
    width: root.width
    height: root.height
    radius: d.radius
    border.width: d.borderWidth
    color: d.semiTransparentBg
    border.color: mainMouseArea.containsMouse ? d.borderHover : d.borderNormal


    QIcon{
      anchors.leftMargin: 3
      anchors.verticalCenter: comboBox.verticalCenter
      anchors.left: comboBox.left
      id: comboIconLoader
      iconSize: d.icosize
      icosource: {
        if (root.currentIndex < 0) return ""
        var item = model.get(root.currentIndex)
        return item.icon || ""
      }
      visible:root.model && root.currentIndex >= 0 && root.currentIndex < root.model.count ?
                (root.model.get(root.currentIndex).icon !== undefined && root.model.get(root.currentIndex).icon !== "") : false

    }
    //文本
    Text {
      id: displayText
      anchors {
        left: d.hasIcon() ?comboIconLoader.right:parent.left
        leftMargin: 3
        verticalCenter: comboBox.verticalCenter
      }
      text: root.model && root.currentIndex >= 0 && root.currentIndex < root.model.count ?
              (root.model.get(root.currentIndex).text !== undefined ? root.model.get(root.currentIndex).text : "") : ""
      elide: Text.ElideRight
    }



    Rectangle {
      id: indicatorRec
      radius: d.radius
      anchors.right: parent.right
      anchors.rightMargin: 3
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height - 6
      width: parent.height - 6
      color: {
        if (mainMouseArea.pressed && mainMouseArea.isIndicatorHovered) return d.indicatorPressed
        else if (mainMouseArea.containsMouse && mainMouseArea.isIndicatorHovered) return d.indicatorHover
        else return "transparent"
      }

      QIcon {
        id: icon
        iconSize: parent.height / 2
        anchors.centerIn: parent
        icosource: FluentIcons.q_ChevronDown
        transform: Rotation {
          origin.x: icon.width / 2
          origin.y: icon.height / 2
          axis { x: 0; y: 0; z: 1 }
          angle: popup.opened ? 180 : 0
          Behavior on angle {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
          }
        }
      }
    }

    MouseArea {
      id: mainMouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: isIndicatorHovered ? Qt.PointingHandCursor : Qt.ArrowCursor
      property bool isIndicatorHovered: false

      onPositionChanged: {
        isIndicatorHovered = mouseX >= indicatorRec.x &&
            mouseX <= indicatorRec.x + indicatorRec.width &&
            mouseY >= indicatorRec.y &&
            mouseY <= indicatorRec.y + indicatorRec.height
      }
      onClicked: if (isIndicatorHovered) popup.toggle()
    }
  }


  Popup {
    id: popup
    y: comboBox.height + 2
    width: comboBox.width
    height: d.dropDownHeight
    padding: 3
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Shadow {
      Rectangle {
        id: bg
        anchors.fill: parent
        radius: d.radius
        color: Qt.rgba(1,1,1,0.8)
        opacity: 0.9
        border.color: "#BDBDBD"
        border.width: 1
      }
    }

    contentItem:Item{
      clip: true
      width: popup.width - popup.padding * 2
      height: popup.height - popup.padding * 2
      ListView {
        anchors.fill: parent
        id: listView
        spacing: 2
        clip: true
        model: root.model
        currentIndex: root.currentIndex
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
        cacheBuffer: Math.min(400, root.model.count * d.itemHeight / 2)
        displayMarginBeginning: Math.min(200, root.model.count * d.itemHeight / 3)
        displayMarginEnd: Math.min(200, root.model.count * d.itemHeight / 3)

        //项目数据代理
        delegate: Rectangle {
          id: delegateItem
          width: ListView.view.width
          height: d.itemHeight
          radius: d.radius
          property bool isCurrent: root.currentIndex === index

          color: {
            if (root.pressedIndex === index) return "crimson"
            else if (hoverArea.containsMouse && !isCurrent) return "deeppink"
            else if (isCurrent) return "darkmagenta"
            else return "transparent"
          }

          // 添加 Loader 动态加载 QIcon
          Loader {
            id: iconLoader
            anchors {
              left: parent.left
              leftMargin: 8
              verticalCenter: parent.verticalCenter
            }
            width: d.itemHeight*0.6//16  // 固定图标宽度
            height: d.itemHeight*0.6 // 固定图标高度
            active: model.icon !== undefined // 仅当 model 有 icon 字段时加载
            sourceComponent: QIcon {
              icosource: model.icon || ""
              iconSize: Math.min(iconLoader.width, iconLoader.height)
            }
          }

          // 添加颜色变化的动画效果
          Behavior on color {
            ColorAnimation {
              duration: 300
              easing.type: Easing.OutQuad
            }
          }

          Text {

            anchors.leftMargin: 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: model.icon ? iconLoader.right : parent.left
            width: parent.width - 16
            text: model.text || ""
            color: (root.pressedIndex === index || isCurrent) ? "white" : "black"
            elide: Text.ElideRight
          }

          MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: pressed ? Qt.PointingHandCursor : Qt.ArrowCursorr

            onPressed: if (!isCurrent) {
                         root.currentIndex = index
                         root.pressedIndex = index
                         root.activated(index)
                       }
            onReleased: {
              root.pressedIndex = -1
              popup.close()  // 关键修复点
            }
            onCanceled: root.pressedIndex = -1
            onExited: root.pressedIndex = -1
          }
        }//项目数据代理


        //滚动条实现区域
        Rectangle {
          id: scrollBar
          visible: d.showScrollBar
          width: 6
          height: listView.height
          anchors.right: listView.right
          color: "transparent"
          property real sizeRatio: listView.visibleArea.heightRatio

          Rectangle {
            id: handle
            width: (handleArea.containsMouse || handleArea.pressed) ? 6 : 3
            height: Math.max(30, listView.height * scrollBar.sizeRatio)
            x: (handleArea.containsMouse || handleArea.pressed) ? 0 : 3
            y: {
              if (handleArea.pressed) return y
              var contentHeight = listView.contentHeight - listView.height
              if (contentHeight <= 0) return 0
              return (scrollBar.height - height) * (listView.contentY / contentHeight)
            }
            radius: width / 2
            color: handleArea.pressed ? Qt.rgba(0.6, 0.6, 0.6, 0.9) :
                                        handleArea.containsMouse ? Qt.rgba(0.6, 0.6, 0.6, 0.7) : Qt.rgba(0.6, 0.6, 0.6, 0.5)



            MouseArea {
              id: handleArea
              anchors.fill: parent
              drag.target: parent
              drag.axis: Drag.YAxis
              drag.minimumY: 0
              drag.maximumY: scrollBar.height - handle.height
              hoverEnabled: true
              cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor  // 添加这行



              onPositionChanged: {
                if (pressed) {
                  var contentHeight = listView.contentHeight - listView.height
                  var ratio = handle.y / (scrollBar.height - handle.height)
                  listView.contentY = ratio * contentHeight
                }
              }
            }
          }
        }//滚动条实现区域
      }//ListView
    }//Item




    function toggle() {
      if (opened) close()
      else {
        open()
        if (root.currentIndex >= 0) {
          listView.positionViewAtIndex(root.currentIndex, ListView.Center)
        }
      }
    }
  }
}


