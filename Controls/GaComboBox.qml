import QtQuick
import QtQuick.Controls
import GalaxyUI



Item {
  id: root

  // -------------------- 基础属性 --------------------
  implicitWidth: 180    // 默认宽度
  implicitHeight: 40    // 默认高度
  width: implicitWidth  // 实际宽度
  height: implicitHeight // 实际高度

  // -------------------- 数据模型接口 --------------------
  property ListModel model:ListModel {}  // 绑定的数据模型
  property int currentIndex: -1  // 当前选中项的索引

  // -------------------- 信号定义 --------------------
  signal activated(int index)    // 当选中某项时触发
  signal opened()                // 当下拉框展开时触发
  signal closed()               // 当下拉框收起时触发
  signal modelDataChanged()      // 当数据被修改（增/删/改）时触发

  // -------------------- 样式属性 --------------------
  property int itemHeight: 32  // 每个选项的高度
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
    property int dropDownHeight: Math.min(visibleItemCount * itemHeight+11, model.count * itemHeight+8)  // 下拉框高度计算
    property bool showScrollBar: model.count * itemHeight > dropDownHeight  // 是否需要显示滚动条
    property int pressedIndex: -1  // 当前被按下的项索引
    // 指示器颜色
    property color indicatorHover: Theme.isDark? Qt.rgba(1, 1, 1, 0.06):Qt.rgba(0, 0, 0, 0.03)
    property color indicatorPressed: Theme.isDark?Qt.rgba(1, 1, 1, 0.1):Qt.rgba(0, 0, 0, 0.1)
    // 判断当前选中项是否有图标
    function hasIcon() {
      if (root.currentIndex < 0) return false
      var item = model.get(root.currentIndex)
      return item && item.icon
    }
  }

  // -------------------- 主组合框 --------------------
  Rectangle {
    id: comboBox
    width: root.width
    height: root.height
    radius: d.radius
    border.width: d.borderWidth
    color: mainMouseArea.pressed ? Theme.itemPressColor :
                                   mainMouseArea.containsMouse ? Theme.itemHoverColor :
                                                                 Theme.itemNormalColor
    border.color:mainMouseArea.pressed ? Theme.borderPresslColor :
                                         mainMouseArea.containsMouse ? Theme.borderHoverlColor :
                                                                       Theme.borderNormalColor


    // 当前选中项的图标
    GaIcon {
      anchors.leftMargin: 8
      anchors.verticalCenter: comboBox.verticalCenter
      anchors.left: comboBox.left
      id: comboIconLoader
      iconColor: Theme.textColor  // 图标颜色随主题变化
      iconSize: comboBox.height*0.5  // 图标大小为高度的一半
      iconSource: {  // 动态获取当前选中项的图标
        if (root.currentIndex < 0) return 0
        var item = model.get(root.currentIndex)
        return item.icon || 0
      }
      visible: root.model && root.currentIndex >= 0 && root.currentIndex < root.model.count ?
                 (root.model.get(root.currentIndex).icon !== undefined && root.model.get(root.currentIndex).icon !== "") : false
    }

    // 当前选中项的文本
    Text {
      id: displayText
      color:Theme.textColor  // 文本颜色随主题变化
      anchors {
        left: d.hasIcon() ? comboIconLoader.right : parent.left
        leftMargin: 8
        verticalCenter: comboBox.verticalCenter
      }
      text: root.model && root.currentIndex >= 0 && root.currentIndex < root.model.count ?
              (root.model.get(root.currentIndex).text !== undefined ? root.model.get(root.currentIndex).text : "") : ""
      elide: Text.ElideRight  // 文本过长时显示省略号
    }

    // 下拉指示器区域
    Rectangle {
      id: indicatorRec
      radius: d.radius
      anchors.right: parent.right
      anchors.rightMargin: 3
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height - 6
      width: parent.height - 6
      color: {  // 根据交互状态改变背景色
        if (mainMouseArea.pressed && mainMouseArea.isIndicatorHovered){
          return d.indicatorPressed
        }else if (mainMouseArea.containsMouse && mainMouseArea.isIndicatorHovered){
          return d.indicatorHover
        }else return "transparent"
      }

      // 下拉箭头图标
      GaIcon {
        id: icon
        iconColor:Theme.textColor
        iconSize: parent.height / 2
        anchors.centerIn: parent
        iconSource:Icons.ChevronDown  // 使用预定义的下拉图标
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

    // 主鼠标区域
    MouseArea {
      id: mainMouseArea
      anchors.fill: parent
      hoverEnabled: true  // 启用悬停检测
      cursorShape: isIndicatorHovered ? Qt.PointingHandCursor : Qt.ArrowCursor  // 根据悬停位置改变光标形状
      property bool isIndicatorHovered: false  // 是否悬停在指示器上

      // 鼠标位置变化时检测是否悬停在指示器上
      onPositionChanged: {
        isIndicatorHovered = mouseX >= indicatorRec.x &&
            mouseX <= indicatorRec.x + indicatorRec.width &&
            mouseY >= indicatorRec.y &&
            mouseY <= indicatorRec.y + indicatorRec.height
      }

      // 点击时打开下拉框
      onClicked: {
        root.open()
      }
    }
  }

  // -------------------- 下拉弹出框 --------------------
  Popup {
    id: popup
    y: comboBox.height + 2  // 在组合框下方显示
    width: comboBox.width   // 宽度与组合框一致
    height: d.dropDownHeight  // 动态计算的高度
    padding: 3  // 内边距
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside  // 按ESC或点击外部关闭

    // 触发展开/收起信号
    onOpened: root.opened()
    onClosed: root.closed()

    // 进入动画
    enter: Transition {
      ParallelAnimation {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 300 }  // 淡入
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 400; easing.type: Easing.OutBack }  // 缩放
      }
    }

    // 退出动画
    exit: Transition {
      ParallelAnimation {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 300 }  // 淡出
        NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 400; easing.type: Easing.InQuad }  // 缩放
      }
    }

    // 背景样式
    background: Shadow {
      color: Theme.isDark ? Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.6)  // 根据主题调整阴影颜色
      Rectangle {
        id: bg
        anchors.fill: parent
        radius: d.radius
        color:mainMouseArea.pressed ? Theme.itemPressColor :
                                        mainMouseArea.containsMouse ? Theme.itemHoverColor :
                                                                      Theme.itemNormalColor
        border.color:mainMouseArea.pressed ? Theme.borderPresslColor :
                                              mainMouseArea.containsMouse ? Theme.borderHoverlColor :
                                                                            Theme.borderNormalColor



        border.width: 1
      }
    }

    // 内容区域
    contentItem: Item {
      clip: true  // 裁剪超出部分
      width: popup.width - popup.padding * 2
      height: popup.height - popup.padding * 2

      // 选项列表视图
      ListView {
        anchors.fill: parent
        id: listView
        spacing: 1  // 项间距
        clip: true  // 裁剪超出部分
        model: root.model  // 绑定数据模型
        currentIndex: root.currentIndex  // 当前选中项索引
        boundsBehavior: Flickable.StopAtBounds  // 边界行为
        snapMode: ListView.SnapToItem  // 对齐到项
        cacheBuffer: Math.min(400, root.model.count * root.itemHeight / 2)  // 缓存区域
        displayMarginBeginning: Math.min(200, root.model.count * root.itemHeight / 3)  // 顶部显示边距
        displayMarginEnd: Math.min(200, root.model.count * root.itemHeight / 3)  // 底部显示边距

        // 选项项代理
        delegate: Rectangle {
          id: delegateItem
          width: ListView.view.width
          height: root.itemHeight
          radius: d.radius
          property bool isCurrent: root.currentIndex === index  // 是否是当前选中项

          // 根据交互状态改变背景色
          color: {
            if (d.pressedIndex === index) return root.itemPressedColor  // 按下状态
            else if (hoverArea.containsMouse && !isCurrent) return root.itemHoverColor  // 悬停状态
            else if (isCurrent) return root.itemSelectedColor  // 选中状态
            else return "transparent"  // 默认状态
          }

          // 动态加载图标
          Loader {
            id: iconLoader
            anchors {
              left: parent.left
              leftMargin: 8
              verticalCenter: parent.verticalCenter
            }
            width: root.itemHeight*0.6  // 图标宽度
            height: root.itemHeight*0.6  // 图标高度
            active: model.icon !== undefined  // 仅当有图标时激活
            sourceComponent: GaIcon {
              iconSource: model.icon || 0  // 图标资源
              iconSize: Math.min(iconLoader.width, iconLoader.height)  // 图标大小
              iconColor:  Theme.textColor   // 图标颜色随主题变化
            }
          }

          // 背景色变化动画
          Behavior on color {
            ColorAnimation {
              duration: 300
              easing.type: Easing.OutQuad
            }
          }

          // 选项文本
          Text {
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: model.icon ? iconLoader.right : parent.left
            width: parent.width - 16
            text: model.text || ""  // 显示文本
            color: {  // 根据状态和主题改变文本颜色
              if((d.pressedIndex === index || isCurrent) && Theme.isDark){
                return "black"
              }
              if((d.pressedIndex === index || isCurrent) && !Theme.isDark){
                return "white"
              }
              return Theme.textColor
            }
            elide: Text.ElideRight  // 文本过长时显示省略号
          }

          // 选项鼠标区域
          MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true  // 启用悬停检测
            cursorShape: pressed ? Qt.PointingHandCursor : Qt.ArrowCursor  // 根据状态改变光标形状

            onPressed: if (!isCurrent) {
                         root.currentIndex = index  // 更新当前选中索引
                         d.pressedIndex = index  // 设置按下状态
                         root.activated(index)  // 触发选中信号
                       }
            onReleased: {
              d.pressedIndex = -1  // 清除按下状态
              popup.close()  // 关闭下拉框
            }
            onCanceled: d.pressedIndex = -1  // 取消时清除按下状态
            onExited: d.pressedIndex = -1  // 鼠标离开时清除按下状态
          }
        }

        // 滚动条实现
        Rectangle {
          id: scrollBar
          visible: d.showScrollBar  // 根据需要显示滚动条
          width: 6  // 滚动条宽度
          height: listView.height  // 滚动条高度
          anchors.right: listView.right  // 右侧对齐
          color: "transparent"  // 背景透明
          property real sizeRatio: listView.visibleArea.heightRatio  // 滚动条大小比例

          // 滚动条滑块
          Rectangle {
            id: handle
            width: (handleArea.containsMouse || handleArea.pressed) ? 6 : 2  // 悬停/按下时变宽
            height: Math.max(30, listView.height * scrollBar.sizeRatio)  // 最小高度30
            x: (handleArea.containsMouse || handleArea.pressed) ? 0 : 2  // 悬停/按下时左对齐
            y: {  // 计算滑块位置
              if (handleArea.pressed) return y
              var contentHeight = listView.contentHeight - listView.height
              if (contentHeight <= 0) return 0
              return (scrollBar.height - height) * (listView.contentY / contentHeight)
            }
            radius: width / 2  // 圆角
            color: handleArea.pressed ? Qt.rgba(0.6, 0.6, 0.6, 0.8) :  // 按下状态
                                        handleArea.containsMouse ? Qt.rgba(0.6, 0.6, 0.6, 0.5) : // 悬停状态
                                                                   Qt.rgba(0.6, 0.6, 0.6, 0.1)  // 默认状态

            // 滑块鼠标区域
            MouseArea {
              id: handleArea
              anchors.fill: parent
              drag.target: parent  // 启用拖动
              drag.axis: Drag.YAxis  // 垂直拖动
              drag.minimumY: 0  // 最小Y位置
              drag.maximumY: scrollBar.height - handle.height  // 最大Y位置
              hoverEnabled: true  // 启用悬停检测
              cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor  // 光标形状

              // 拖动时更新列表位置
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
      }
    }
  }

  // -------------------- 公共API --------------------

  /**
   * 打开下拉框
   */
  function open() {
    if (!popup.visible && root.model.count > 0) {
      popup.open()
    }
  }

  /**
   * 关闭下拉框
   */
  function close() {
    if (popup.visible) {
      popup.close()
    }
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

  /**
   * 清空模型中的所有数据，并将当前选中索引重置为-1
   */
  function clearAll() {
    if (model) {
      model.clear()
      currentIndex = -1
      root.modelDataChanged()
    }
  }

  /**
   * 删除指定索引的数据项
   * @param {int} index - 要删除的项的索引
   * @return {bool} 返回 true 表示删除成功，返回 false 表示删除失败（例如索引无效）
   */
  function removeItem(index) {
    if (model && index >= 0 && index < model.count) {
      model.remove(index); // 删除指定索引的项
      root.modelDataChanged(); // 触发数据变化信号
      return true; // 删除成功
    }
    return false; // 删除失败，索引无效
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

  /**
   * 在模型头部插入新项
   * @param {Object} item - 要插入的对象(必须包含text属性，可选包含icon等属性)
   */
  function addHeadItem(item) {
    if (model) {
      model.insert(0, item)
      root.modelDataChanged()
    }
  }

  /**
   * 在模型尾部追加新项
   * @param {Object} item - 要追加的对象(必须包含text属性，可选包含icon等属性)
   */
  function addendItem(item) {
    if (model) {
      model.append(item)
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
   * 根据索引获取指定项的文本数据
   * @param {int} index - 要获取的项的索引
   * @return {string|null} 返回指定项的文本数据，如果索引无效则返回 null
   */
  function getItemText(index) {
    if (model && index >= 0 && index < model.count) {
      var item = model.get(index); // 获取指定索引的数据对象
      return item.text || null;    // 返回 text 属性，如果不存在则返回 null
    }
    return null; // 如果索引无效，返回 null
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
