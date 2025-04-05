import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"
Window {
    width: 650
    height: 480
    visible: true
    title: qsTr("Hello ccc")
    color: Theme.dark?Qt.rgba(0.32,0.32,0.32):"white"


    Row{
        x:5
        y:5
        spacing: 6
        QButton{
            text: "指针测试"

            onClicked: {
        console.log("xxx")
            }
            onPressed: {
              console.log("2222")

            }
        }
        Button{
            text: "深色"
            onClicked: {

                Theme.ThemeType=Theme.Dark
            }
        }
        Button{
            text: "浅色"
            onClicked: {

                Theme.ThemeType=Theme.Light
            }
        }

    }




    Label{
        id:darktexe
        width: parent.width
        height: 30
        anchors.bottom: parent.bottom
        text: "当前的主题模式是否Dark："+Theme.dark
    }




}
