import QtQuick
import QtQuick.Controls

Item {
    id: root
    implicitWidth: 180
    implicitHeight: 40
    width: implicitWidth
    height: implicitHeight

    // 公共属性
    property var model: [ "人生得意须尽欢", "莫使金樽空对月", "莫使金樽空对月", "莫使金樽空对月", "莫使金樽空对月", "莫使金樽空对月", "莫使金樽空对月",

      "天生我材必有用"]
    property string currentText: ""
    property int currentIndex: -1
    signal activated(int index)

    //私有属性和方法容器
    QtObject {
        id: d
        property int itemHeight: 32  //项目高度
        property int visibleItemCount: 7 //显示项目最大数
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
        property int dropDownHeight: Math.min(visibleItemCount * itemHeight, model.length * itemHeight)
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

                    // 背景色逻辑：选中 > 悬停 > 默认
                    color: {
                        if (listView.currentIndex === index) {
                            return "#0078D7"  // 选中状态（蓝色）
                        } else if (mouseArea.containsMouse) {
                            return Qt.rgba(0, 0, 0, 0.05)  // 悬停状态（浅灰色）
                        } else {
                            return "transparent"  // 默认状态
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 8
                        width: parent.width - 16
                        text: modelData
                        color: listView.currentIndex === index ? "#FFFFFF" : "#212121"  // 选中时白色，否则黑色
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    // 新增：悬停交互的 MouseArea
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true  // 启用悬停检测
                        onClicked: {
                            root.currentIndex = index
                            root.currentText = modelData
                            root.activated(index)
                            popup.close()
                        }
                    }
                }


            }
        }
    }
}
