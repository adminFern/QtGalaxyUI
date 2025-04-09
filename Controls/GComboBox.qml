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
    property int itemHeight: 32
    property int visibleItemCount: 6
    property color itemSelectedColor: "#004080"
    property color itemHoverColor: "#ADD8E6"
    property color itemPressedColor: "#4682B4"

    // -------------------- 私有属性 --------------------
    QtObject {
        id: d
        property int radius: 4
        property int borderWidth: 1
        property int dropDownHeight: Math.min(visibleItemCount * itemHeight, root.count * itemHeight)

        // 使用系统主题颜色
        property color indicatorHover: Theme.isDark ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.03)
        property color indicatorPressed: Theme.isDark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.1)



    }

    // -------------------- 背景样式 --------------------
    background: Rectangle {
        implicitWidth: root.width
        implicitHeight: root.height
        radius: d.radius
        border.width: d.borderWidth
        color: root.down ? Theme.itemPressColor :
                           root.hovered ? Theme.itemHoverColor : "transparent"
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
        color: root.down ? d.indicatorPressed :
                           root.hovered ? d.indicatorHover : "transparent"

        GaIcon {
            anchors.centerIn: parent
            iconColor: Theme.textColor
            iconSize: parent.height / 2
            iconSource: Icons.ChevronDown
        }
    }

    // -------------------- 内容项 --------------------
    contentItem: Row {
        spacing: 4

        GaIcon {
           visible: currentIndex >= 0 ? (model.get(currentIndex).icon ? true : false) : false
            iconSize: 16
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
        y: root.height + 1
        width: root.width
        height: d.dropDownHeight
        padding: 4

        contentItem: ListView {
            clip: true
            spacing: 1
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
            ScrollBar.vertical: GaScrollBar {visible: root.count > root.visibleItemCount }
        }

        background: Shadow {
            color: Theme.isDark ? Qt.rgba(1,1,1,0.2) : Qt.rgba(0,0,0,0.6)
            Rectangle {
                anchors.fill: parent
                radius: d.radius
                color: Theme.itemNormalColor
                border.color: Theme.borderNormalColor
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

        background: Rectangle {
            radius: 4
            color: highlighted ? itemSelectedColor :
                                 pressed ? itemPressedColor :
                                           hovered ? itemHoverColor : "transparent"
        }

        contentItem: Row {
            spacing: 4

            GaIcon {
                visible: model.icon !== undefined
                iconSize: 16
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
