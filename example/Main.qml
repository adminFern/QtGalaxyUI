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
    color: Theme.isDark?"slategray":"white"
    Row{
        spacing: 6
        padding: 5
        QIconLabel{

            icosource: FluentIcons.q_Wifi
            text: "我们的敖犬"
        }
        QIconLabel{

            icosource: FluentIcons.q_VPN

        }
        QIconLabel{
            enabled: false
            spacing: 0
            mirrored:true
            icosource: FluentIcons.q_Wifi
            text: "我们的敖犬"
        }


        Button{
            text: "正常"
            onClicked: {
                Theme.themeType=Theme.ModeType.Dark
            }
        }
        QIconButton{
              display: Button.TextBesideIcon
              text: "saawq"
            iconSource: FluentIcons.q_VPN

        }
    }



}
