import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"

Window {
    id: root
    width: 650
    height: 480
    visible: true
    title: qsTr("主题切换演示")





    // 窗口背景色（带动画过渡）
    color: Theme.dark ? "cornflowerblue" : "white"
    Behavior on color {
        ColorAnimation {
            duration: 800
            easing.type: Easing.InOutCubic
        }
    }

    ListModel{

        id:list
        ListElement { text: "选项1"; icon:"\ue700" } // 无图标的项
        ListElement { text: "选项2"; icon:"\ue700" } // 无图标的项
        ListElement { text: "选项3"; icon: "\ue700" } // 无图标的项
        ListElement { text: "选项4"; icon: "\ue700" } // 无图标的项
        ListElement { text: "选项5"; icon: "\ue700" } // 无图标的项
        ListElement { text: "选项6"; icon: "\ue700" } // 无图标的项
        ListElement { text: "选项7"; icon: "\ue700" } // 无图标的项
        ListElement { text: "选项3"; icon: "\ue700" } // 无图标的项



    }


    QComboBox{
        x:5
        y:5
        id:a
        height: 35
        width: 180
        model: list

    }

    // 主题切换按钮
    Row {
        anchors.centerIn: parent
        spacing: 20

        QButton {
            id: lightButton
            text: "浅色模式"
            width: 120
            height: 40
            onClicked: {
                Theme.ThemeType = Theme.Light

            }

        }

        QButton {
            id: darkButton
            text: "深色模式"
            width: 120
            height: 40

            onClicked: {
                Theme.ThemeType = Theme.Dark
            }
        }
    }
    Connections {
        target: Theme
        function onThemeTypeChanged() {
            console.log("主题变化检测到")

        }
    }

}
