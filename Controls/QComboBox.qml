import QtQuick
import QtQuick.Controls

Item {
  id: root
  implicitWidth: 180
  implicitHeight: 40
  width: implicitWidth
  height: implicitHeight

  property int pressedIndex: -1
  property var model: []
  property int currentIndex: -1
  signal activated(int index)

  QtObject {
    id: d
    property int itemHeight: 32
    property int visibleItemCount: 5
    property int radius: 4
    property int borderWidth: 1
    property int dropDownHeight: Math.min(visibleItemCount * itemHeight, model.length * itemHeight) + 6
    property bool showScrollBar: model.length * itemHeight > dropDownHeight

    // 颜色定义
    property color semiTransparentBg: Qt.rgba(1,1,1,0.1)
    property color indicatorHover: Qt.rgba(0, 0, 0, 0.06)
    property color indicatorPressed: Qt.rgba(0, 0, 0, 0.1)
    property color borderHover: Qt.rgba(0.57, 0.57, 0.57, 0.9)
    property color borderNormal: Qt.rgba(0,0,0,0.25)
  }

  Rectangle {
    id: comboBox
    width: root.width
    height: root.height
    radius: d.radius
    border.width: d.borderWidth
    color: d.semiTransparentBg
    border.color: mainMouseArea.containsMouse ? d.borderHover : d.borderNormal

    Text {
      id: displayText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 5
      width: comboBox.width - indicatorRec.width - 8
      text: root.currentIndex >= 0 ? model[root.currentIndex] : "请选择"
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
        // 优化：动态计算缓存区域
        cacheBuffer: Math.min(400, root.model.length * d.itemHeight / 2)
        displayMarginBeginning: Math.min(200, root.model.length * d.itemHeight / 3)
        displayMarginEnd: Math.min(200, root.model.length * d.itemHeight / 3)


        delegate: Rectangle {

          id: delegateItem
          width: ListView.view.width
          height: d.itemHeight
          radius: d.radius
          property bool isCurrent: root.currentIndex === index

          color: {
            if (root.pressedIndex === index) return "crimson"
            else if (hoverArea.containsMouse && !isCurrent) return "darkgray"
            else if (isCurrent) return "darkmagenta"
            else return "transparent"
          }
          Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 8
            width: parent.width - 16
            text: modelData
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
        }

        //滚动条
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
        }




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


