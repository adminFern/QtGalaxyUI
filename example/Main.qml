import QtQuick
import QtQuick.Controls
import GalaxyUI
import "../Controls"

Window {
    id: root
    width: 650
    height: 480
    visible: true
    title: qsTr("流畅水波纹主题切换演示")

    Row{
        spacing: 6
        padding: 5
        QIconLabel{

            icosource: FluentIcons.q_Wifi
            text: "我们的敖犬"
        }
        QIconLabel{
            spacing: 0
            mirrored:true
            icosource: FluentIcons.q_Wifi
            text: "我们的敖犬"
        }

    }

}
