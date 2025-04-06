import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"

FramelessWindow {
    id: root
    width: 650
    height: 480
    visible: true
    title: qsTr("流畅水波纹主题切换演示")
    fixSize:true
   // color: Theme.isDark?"#F2171717":"#F0FFFFFF"
    Component.onCompleted: {

        console.log(Theme.isDark)
    }

    Column{
        spacing: 6
        padding: 5
        Row{
            spacing: 6
            padding: 5
            GaIconButton{
                iconSource: Icons.Bluetooth
            }
            GaIconButton{
                iconSource: Icons.More
            }
        }
        GaIconButton{
            display: Button.TextBesideIcon
            iconSource: Icons.Video
            text: "深色模式"
            onClicked: {
              Theme.themeType=Theme.ModeType.Dark
            }
        }
        GaIconButton{
            display: Button.TextBesideIcon
            iconSource: Icons.Zoom
            text: "浅色模式"
            onClicked: {
              Theme.themeType=Theme.ModeType.Light
            }
        }
    }



}
