import QtQuick
import QtQuick.Controls
import GalaxyUI
Item {
  id: root
  implicitWidth: 180
  implicitHeight: 40
  width: implicitWidth
  height: implicitHeight

  property ListModel model
  property int currentIndex: -1
  signal activated(int index)  // 选中某项时触发
  signal opened()                            // 下拉框展开时触发
  signal closed()                            // 下拉框收起时触发
  signal modelDataChanged()                      // 数据被修改（增/删/改）时触发

  QtObject {
    id: d
    property int itemHeight: 32
    property int visibleItemCount: 6
    property int radius: 4
    property int borderWidth: 1
    property int dropDownHeight: Math.min(visibleItemCount * itemHeight, model.count * itemHeight) + 6//修改
    property bool showScrollBar: model.count * itemHeight > dropDownHeight
    property int pressedIndex: -1
    // 颜色定义

    property color indicatorHover: Theme.dark?  Qt.rgba(1, 1, 1, 0.06):Qt.rgba(0, 0, 0, 0.06)
    property color indicatorPressed: Theme.dark?Qt.rgba(1, 1, 1, 0.1):Qt.rgba(0, 0, 0, 0.1)






    // 判断当前选中项是否有图标
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
    color:mainMouseArea.containsMouse ?Theme.ItemrHovercolor:Theme.ItemBackgroundColor
    border.color: mainMouseArea.containsMouse ? Theme.ItemBorderHovercolor : Theme.ItemBordercolor

    QIcon{
      anchors.leftMargin: 3
      anchors.verticalCenter: comboBox.verticalCenter
      anchors.left: comboBox.left
      id: comboIconLoader
      icocolor:Theme.ItemTextColor
      iconSize: comboBox.height*0.5
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
      color: Theme.ItemTextColor
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
        if (mainMouseArea.pressed && mainMouseArea.isIndicatorHovered){
            return d.indicatorPressed
        }else if (mainMouseArea.containsMouse && mainMouseArea.isIndicatorHovered){
          return d.indicatorHover
        }else return "transparent"
      }

      QIcon {
        id: icon
        icocolor: Theme.ItemTextColor
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
      onClicked:{
        if (!popup.visible)
        {
          popup.open()
        }
      }



    }
  }


  Popup {
    id: popup
    y: comboBox.height + 2
    width: comboBox.width
    height: d.dropDownHeight
    padding: 3
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    // --- 触发展开/收起信号 ---
    onOpened: root.opened()
    onClosed: root.closed()

    enter: Transition {
      ParallelAnimation {
        NumberAnimation {
          property: "opacity";
          from: 0.0; to: 1.0;
          duration: 300
        }
        NumberAnimation {
          property: "scale";
          from: 0.8; to: 1.0;
          duration: 400;
          easing.type: Easing.OutBack
        }
      }
    }
    exit: Transition {
      ParallelAnimation {
        NumberAnimation {
          property: "opacity";
          from: 1.0; to: 0.0;
          duration: 300
        }
        NumberAnimation {
          property: "scale";
          from: 1.0; to: 0.8;
          duration: 400;
          easing.type: Easing.InQuad
        }
      }
    }


    background: Shadow {
      color: Theme.dark?Qt.rgba(1,1,1,0.2):Qt.rgba(0,0,0,0.6)
      Rectangle {
        id: bg
        anchors.fill: parent
        radius: d.radius
        color: Theme.ItemBackgroundColor
        border.color: Theme.ItemBordercolor
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
        spacing: 1
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
            if (d.pressedIndex === index) return "crimson"
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
              icocolor: Theme.ItemTextColor
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
            color:{
              if((d.pressedIndex === index || isCurrent)&&Theme.dark){
                return "black"
              }if((d.pressedIndex === index || isCurrent)&&!Theme.dark){
                return "white"
              }
              return Theme.ItemTextColor
            }
            elide: Text.ElideRight
          }

          MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: pressed ? Qt.PointingHandCursor : Qt.ArrowCursorr

            onPressed: if (!isCurrent) {
                         root.currentIndex = index
                         d.pressedIndex = index
                         root.activated(index)
                       }
            onReleased: {
              d.pressedIndex = -1
              popup.close()  // 关键修复点
            }
            onCanceled: d.pressedIndex = -1
            onExited: d.pressedIndex = -1
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
            width: (handleArea.containsMouse || handleArea.pressed) ? 6 : 2
            height: Math.max(30, listView.height * scrollBar.sizeRatio)
            x: (handleArea.containsMouse || handleArea.pressed) ? 0 : 2
            y: {
              if (handleArea.pressed) return y
              var contentHeight = listView.contentHeight - listView.height
              if (contentHeight <= 0) return 0
              return (scrollBar.height - height) * (listView.contentY / contentHeight)
            }
            radius: width / 2
            color: handleArea.pressed ? Qt.rgba(0.6, 0.6, 0.6, 0.9) :
                                        handleArea.containsMouse ? Qt.rgba(0.6, 0.6, 0.6, 0.5) : Qt.rgba(0.6, 0.6, 0.6, 0.2)
            MouseArea {
              id: handleArea
              anchors.fill: parent
              drag.target: parent
              drag.axis: Drag.YAxis
              drag.minimumY: 0
              drag.maximumY: scrollBar.height - handle.height
              hoverEnabled: true
              cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor



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
  }
  /**
    * 替换指定索引的项
    * @param {int} index - 要替换的索引位置
    * @param {Object} item - 新的数据项（必须包含text属性）
    * @return {bool} 是否替换成功
    */
  function replaceItem(index, item) {
    if (model && index >= 0 && index < model.count && item) {
      model.set(index, item)

      // 如果替换的是当前选中项，更新显示
      if (index === currentIndex) {
        currentIndexUpdated(currentIndex) // 手动触发信号
      }

      root.modelDataChanged() // 触发数据变化信号
      return true
    }
    return false
  }
  //-----------------------
  // 清空模型中的所有数据，并将当前选中索引重置为-1
  function clearAll() {
    if (model) {
      model.clear()
      currentIndex = -1
      root.modelDataChanged()
    }
  }
  /**
   * 删除当前选中的项
   * 1. 自动处理索引越界情况
   * 2. 如果删除后索引超出范围，自动调整到最后一项
   * 3. 如果模型变为空，重置currentIndex为-1
   */
  function removeCurrent() {
    if (model && currentIndex >= 0 && currentIndex < model.count) {
      model.remove(currentIndex)
      // 处理删除后索引越界的情况
      if (currentIndex >= model.count) {
        currentIndex = model.count - 1
      }
      // 处理模型变空的情况
      if (model.count === 0) {
        currentIndex = -1
      }
      root.modelDataChanged()
    }
  }
  // 在模型头部插入新项
  // 参数item: 要插入的对象(必须包含text属性，可选包含icon等属性)
  // 如果是第一个插入的项，自动设为当前选中项
  function prependItem(item) {
    if (model) {
      model.insert(0, item)
      // 如果是第一个项，自动选中
      if (model.count === 1) {
        currentIndex = 0
      }
      root.modelDataChanged()
    }
  }
  // 在模型尾部追加新项
  // 参数item: 要追加的对象(必须包含text属性，可选包含icon等属性)
  // 如果是第一个追加的项，自动设为当前选中项
  function appendItem(item) {
    if (model) {
      model.append(item)
      // 如果是第一个项，自动选中
      if (model.count === 1) {
        currentIndex = 0
      }
      root.modelDataChanged()
    }
  }
  /**
   * 获取当前 model 中的总项数
   * @return {int} 返回 model 的项数，如果 model 不存在则返回 0
   */
  function count() {
    return model ? model.count : 0
  }
  /**
   * 获取当前选中项的数据对象
   * @return {Object|null} 返回当前选中项的数据，如果没有选中项则返回 null
   */
  function getCurrentItem() {
    return (model && currentIndex >= 0 && currentIndex < model.count)
        ? model.get(currentIndex)
        : null
  }
  /**
   * 根据索引获取指定项的数据
   * @param {int} index - 要获取的项的索引
   * @return {Object|null} 返回指定项的数据，如果索引无效则返回 null
   */
  function getItem(index) {
    return (model && index >= 0 && index < model.count)
        ? model.get(index)
        : null
  }
  /**
   * 根据文本查找项的索引
   * @param {string} text - 要查找的文本
   * @return {int} 返回匹配项的索引，未找到返回 -1
   */
  function findIndexByText(text) {
    if (!model) return -1
    for (var i = 0; i < model.count; i++) {
      if (model.get(i).text === text) {
        return i
      }
    }
    return -1
  }

}


